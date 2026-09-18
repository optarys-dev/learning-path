using System.Security.Claims;
using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Application.Routes.Commands;
using CodeQuest2026.Server.Application.Routes.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[Authorize]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
[Route("routes")]
public class RoutesController(ISender sender) : ControllerBase
{
    /// <summary>Previsualiza una recomendación estática basada en las preferencias guardadas.</summary>
    /// <remarks>No guarda una ruta. El motor usa cursos activos, objetivo, intereses, idioma y nivel. La puntuación no representa una probabilidad.</remarks>
    /// <response code="200">Recomendación calculada; Courses puede estar vacío si no hay coincidencias.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="409">Faltan preferencias; error = preferences_required.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpGet("recommendation")]
    [ProducesResponseType<StaticRecommendationDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<StaticRecommendationDto>> PreviewRecommendation(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        var recommendation = await sender.Send(new GetStaticRecommendationQuery(discordId), cancellationToken);
        return recommendation is null
            ? Conflict(new ApiErrorDto("preferences_required", "Guarda tus preferencias antes de generar una ruta."))
            : Ok(recommendation);
    }

    /// <summary>Busca cursos con embeddings locales a partir de las preferencias guardadas.</summary>
    /// <remarks>El servicio Python genera el vector de consulta. La API combina similitud en pgvector con títulos y asociaciones observadas entre categorías, tags y cursos. No guarda una ruta.</remarks>
    /// <response code="200">Cursos relevantes con cobertura temática, ordenados para estudio por nivel y requisitos publicados.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="409">Faltan preferencias o todavía no se indexaron cursos con ese modelo.</response>
    /// <response code="502">El servicio local de embeddings rechazó la solicitud o devolvió un error HTTP.</response>
    /// <response code="503">El servicio local de embeddings no está disponible.</response>
    [HttpGet("recommendation/semantic")]
    [ProducesResponseType<StaticRecommendationDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status502BadGateway)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<ActionResult<StaticRecommendationDto>> PreviewSemanticRecommendation(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        SemanticRecommendationResult result;
        try
        {
            result = await sender.Send(new GetSemanticRecommendationQuery(discordId), cancellationToken);
        }
        catch (HttpRequestException exception) when (exception.StatusCode is not null
            && exception.StatusCode != System.Net.HttpStatusCode.ServiceUnavailable)
        {
            return StatusCode(502, new ApiErrorDto("embedding_service_error",
                $"El servicio de embeddings devolvió HTTP {(int)exception.StatusCode}."));
        }
        catch (HttpRequestException)
        {
            return StatusCode(503, new ApiErrorDto("embedding_service_unavailable", "El servicio de embeddings no está disponible."));
        }
        catch (TaskCanceledException) when (!cancellationToken.IsCancellationRequested)
        {
            return StatusCode(503, new ApiErrorDto("embedding_service_unavailable", "El servicio de embeddings no respondió a tiempo."));
        }
        if (result.PreferencesRequired)
            return Conflict(new ApiErrorDto("preferences_required", "Guarda tus preferencias antes de generar una ruta."));
        if (!result.EmbeddingsAvailable)
            return Conflict(new ApiErrorDto("embeddings_unavailable", "Indexa los cursos con el mismo modelo de embeddings antes de consultar."));
        return Ok(result.Recommendation);
    }

    /// <summary>Genera y guarda una ruta con el motor de recomendación estático.</summary>
    /// <remarks>Usa las preferencias actuales del usuario y cursos activos. Guarda el método static-v1 y una copia de las preferencias.</remarks>
    /// <response code="201">Ruta generada y guardada; Location apunta a GET /routes/{routeId}.</response>
    /// <response code="400">Un curso cambió de estado durante la generación; error = course_unavailable.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="409">Faltan preferencias o no hay coincidencias; error = preferences_required o no_recommendations.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpPost("generate")]
    [ProducesResponseType<LearningRouteDto>(StatusCodes.Status201Created)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<LearningRouteDto>> Generate(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        var result = await sender.Send(new GenerateStaticRouteCommand(discordId), cancellationToken);
        return result.Status switch
        {
            GenerateRouteStatus.PreferencesRequired => Conflict(new ApiErrorDto("preferences_required", "Guarda tus preferencias antes de generar una ruta.")),
            GenerateRouteStatus.NoMatches => Conflict(new ApiErrorDto("no_recommendations", "No encontramos cursos relacionados con tus preferencias actuales.")),
            GenerateRouteStatus.CourseUnavailable => BadRequest(new ApiErrorDto("course_unavailable", "Un curso dejó de estar disponible. Inténtalo de nuevo.")),
            _ => CreatedAtAction(nameof(GetById), new { routeId = result.Route!.RouteId }, result.Route)
        };
    }

    /// <summary>Guarda una ruta de aprendizaje ya analizada para el usuario autenticado.</summary>
    /// <remarks>
    /// Requiere preferencias previas y la cookie CodeQuest.Session. El orden del arreglo Courses
    /// define la posición de cada curso. Acepta entre 1 y 30 cursos activos, sin repetidos.
    /// Guarda una copia de las preferencias utilizadas y devuelve la ruta creada.
    /// </remarks>
    /// <response code="201">Ruta guardada; Location apunta a GET /routes/{routeId}.</response>
    /// <response code="400">Ruta inválida o curso no disponible; error = invalid_route o course_unavailable.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="409">Faltan preferencias; error = preferences_required.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpPost]
    [ProducesResponseType<LearningRouteDto>(StatusCodes.Status201Created)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<LearningRouteDto>> Save(
        SaveLearningRouteRequest request, CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        SaveRouteResult result;
        try
        {
            result = await sender.Send(new SaveLearningRouteCommand(discordId, request), cancellationToken);
        }
        catch (ArgumentException exception) when (exception.Message == "invalid_route")
        {
            return BadRequest(new ApiErrorDto("invalid_route", "La ruta debe incluir de 1 a 30 cursos activos, sin repetir."));
        }
        return result.Status switch
        {
            SaveRouteStatus.PreferencesRequired => Conflict(new ApiErrorDto("preferences_required", "Guarda tus preferencias antes de crear una ruta.")),
            SaveRouteStatus.CourseUnavailable => BadRequest(new ApiErrorDto("course_unavailable", "Uno o más cursos no están disponibles.")),
            _ => CreatedAtAction(nameof(GetById), new { routeId = result.Route!.RouteId }, result.Route)
        };
    }

    /// <summary>Lista las rutas guardadas del usuario autenticado, de la más reciente a la más antigua.</summary>
    /// <response code="200">Lista de rutas; vacía si todavía no hay ninguna.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpGet]
    [ProducesResponseType<LearningRouteDto[]>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<IReadOnlyList<LearningRouteDto>>> List(CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        return Ok(await sender.Send(new GetLearningRoutesQuery(discordId), cancellationToken));
    }

    /// <summary>Consulta una ruta guardada que pertenece al usuario autenticado.</summary>
    /// <param name="routeId">Identificador UUID de la ruta.</param>
    /// <param name="cancellationToken">Permite cancelar la solicitud.</param>
    /// <response code="200">Ruta encontrada.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="404">La ruta no existe o pertenece a otro usuario.</response>
    /// <response code="500">Error inesperado; error = internal_error.</response>
    [HttpGet("{routeId:guid}")]
    [ProducesResponseType<LearningRouteDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<LearningRouteDto>> GetById(Guid routeId, CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        var route = await sender.Send(new GetLearningRouteByIdQuery(discordId, routeId), cancellationToken);
        return route is null
            ? NotFound(new ApiErrorDto("route_not_found", "No se encontró la ruta solicitada."))
            : Ok(route);
    }
}
