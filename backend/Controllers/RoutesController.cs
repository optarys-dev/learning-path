using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Routes;
using CodeQuest2026.Server.Application.Routes.Commands;
using CodeQuest2026.Server.Application.Routes.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[Authorize]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
[Route("routes")]
public class RoutesController(ISender sender) : ControllerBase
{
    /// <summary>Actualiza el porcentaje de avance de un curso en una ruta propia.</summary>
    /// <remarks>Permite valores de 0 a 100 y reiniciar el avance. Devuelve la ruta actualizada.</remarks>
    [HttpPatch("{routeId:guid}/courses/{courseId:long}/progress")]
    [ProducesResponseType<LearningRouteDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<LearningRouteDto>> UpdateCourseProgress(
        Guid routeId, long courseId, UpdateCourseProgressRequest request, CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));

        var result = await sender.Send(new UpdateCourseProgressCommand(discordId, routeId, courseId, request), cancellationToken);
        return result.Status switch
        {
            UpdateCourseProgressStatus.InvalidProgress => BadRequest(new ApiErrorDto(
                "invalid_progress", "Indica un porcentaje entero entre 0 y 100.")),
            UpdateCourseProgressStatus.NotFound => NotFound(new ApiErrorDto(
                "route_course_not_found", "No se encontró el curso en la ruta solicitada.")),
            _ => Ok(result.Route)
        };
    }

    /// <summary>Busca cursos con embeddings locales a partir de las preferencias guardadas.</summary>
    /// <remarks>El servicio Python genera el vector de consulta. La API combina similitud en pgvector con títulos y asociaciones observadas entre categorías, tags y cursos. No guarda una ruta.</remarks>
    /// <response code="200">Cursos relevantes con cobertura temática, ordenados para estudio por nivel y requisitos publicados.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="409">Faltan preferencias o todavía no se indexaron cursos con ese modelo.</response>
    /// <response code="502">El servicio local de embeddings rechazó la solicitud o devolvió un error HTTP.</response>
    /// <response code="503">El servicio local de embeddings no está disponible.</response>
    [HttpGet("recommendation/semantic")]
    [ProducesResponseType<SemanticRecommendationDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status502BadGateway)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<ActionResult<SemanticRecommendationDto>> PreviewSemanticRecommendation(CancellationToken cancellationToken)
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

    /// <summary>V2: refina el orden y las razones con el proveedor de IA registrado y JSON Schema estricto.</summary>
    /// <remarks>No guarda la ruta. RefinementStatus indica si se aplicó IA; ante fallos se devuelve la recomendación original.</remarks>
    [HttpGet("recommendation/semantic/v2")]
    [ProducesResponseType<SemanticRecommendationV2Dto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status409Conflict)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status502BadGateway)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<ActionResult<SemanticRecommendationV2Dto>> PreviewSemanticRecommendationV2(
        [FromQuery] long[]? excludeCourseIds,
        CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (string.IsNullOrWhiteSpace(discordId))
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        SemanticRecommendationV2Result result;
        try
        {
            result = await sender.Send(new GetSemanticRecommendationV2Query(discordId, excludeCourseIds), cancellationToken);
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

    /// <summary>Guarda una ruta de aprendizaje ya analizada para el usuario autenticado.</summary>
    /// <remarks>
    /// Requiere la cookie CodeQuest.Session. Las rutas recomendadas requieren preferencias previas.
    /// Goal permite nombrar una ruta manual; si se omite en una recomendación, se usa el objetivo del perfil. El orden del arreglo Courses
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
        var result = await sender.Send(new SaveLearningRouteCommand(discordId, request), cancellationToken);
        return result.Status switch
        {
            SaveRouteStatus.PreferencesRequired => Conflict(new ApiErrorDto("preferences_required", "Guarda tus preferencias antes de crear una ruta.")),
            SaveRouteStatus.CourseUnavailable => BadRequest(new ApiErrorDto("course_unavailable", "Uno o más cursos no están disponibles.")),
            _ => CreatedAtAction(nameof(GetById), new { routeId = result.Route!.RouteId }, result.Route)
        };
    }

    /// <summary>Reemplaza el objetivo, explicación y cursos de una ruta propia.</summary>
    /// <remarks>
    /// PUT reemplaza todos los campos editables. Courses contiene de 1 a 30 cursos activos
    /// sin duplicados; su orden define las posiciones. Conserva fecha, método original y
    /// copia histórica de preferencias. No ejecuta recomendaciones ni requiere preferencias actuales.
    /// </remarks>
    /// <response code="200">Ruta actualizada.</response>
    /// <response code="400">Datos inválidos o curso no disponible.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="404">La ruta no existe o pertenece a otro usuario.</response>
    [HttpPut("{routeId:guid}")]
    [ProducesResponseType<LearningRouteDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<LearningRouteDto>> Update(
        Guid routeId,
        UpdateLearningRouteRequest request,
        CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (string.IsNullOrWhiteSpace(discordId))
        {
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        }

        var result = await sender.Send(
            new UpdateLearningRouteCommand(discordId, routeId, request),
            cancellationToken);

        return result.Status switch
        {
            UpdateRouteStatus.NotFound => NotFound(new ApiErrorDto(
                "route_not_found", "No se encontró la ruta solicitada.")),
            UpdateRouteStatus.InvalidRoute => BadRequest(new ApiErrorDto(
                "invalid_route", "Indica un objetivo válido y de 1 a 30 cursos sin repetir.")),
            UpdateRouteStatus.CourseUnavailable => BadRequest(new ApiErrorDto(
                "course_unavailable", "Uno o más cursos no están disponibles.")),
            _ => Ok(result.Route)
        };
    }

    /// <summary>Elimina una ruta propia y sus asociaciones con cursos.</summary>
    /// <remarks>Elimina permanentemente la ruta. Los cursos del catálogo se conservan.</remarks>
    /// <response code="204">Ruta eliminada.</response>
    /// <response code="401">No hay una sesión válida.</response>
    /// <response code="404">La ruta no existe o pertenece a otro usuario.</response>
    [HttpDelete("{routeId:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid routeId, CancellationToken cancellationToken)
    {
        var discordId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (string.IsNullOrWhiteSpace(discordId))
        {
            return Unauthorized(new ApiErrorDto("unauthorized", "Inicia sesión con Discord para continuar."));
        }

        var deleted = await sender.Send(
            new DeleteLearningRouteCommand(discordId, routeId),
            cancellationToken);

        return deleted
            ? NoContent()
            : NotFound(new ApiErrorDto("route_not_found", "No se encontró la ruta solicitada."));
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
