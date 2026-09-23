using CodeQuest2026.Server.Application.Common;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace CodeQuest2026.Server.Infrastructure;

/// <summary>Creates the single public error contract used by the HTTP API.</summary>
public static class ApiProblemDetailsFactory
{
    private const string ErrorTypeBase = "https://errors.codequest.dev/";

    public static ProblemDetails Create(HttpContext context, int statusCode, string code, string? detail = null)
    {
        var (title, defaultDetail) = Describe(statusCode, code);
        var problem = new ProblemDetails
        {
            Type = $"{ErrorTypeBase}{code.Replace('_', '-')}",
            Title = title,
            Status = statusCode,
            Detail = detail ?? defaultDetail,
            Instance = context.Request.Path
        };
        AddExtensions(problem, context, code);
        return problem;
    }

    public static ValidationProblemDetails CreateValidation(HttpContext context, ModelStateDictionary modelState)
    {
        var problem = new ValidationProblemDetails(modelState)
        {
            Type = $"{ErrorTypeBase}validation-error",
            Title = "Datos inválidos",
            Status = StatusCodes.Status400BadRequest,
            Detail = "Revisa los datos enviados.",
            Instance = context.Request.Path
        };
        AddExtensions(problem, context, ApiErrorCodes.Validation);
        return problem;
    }

    public static async Task WriteAsync(HttpContext context, int statusCode, string code, string? detail = null,
        CancellationToken cancellationToken = default)
    {
        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/problem+json";
        await context.Response.WriteAsJsonAsync(Create(context, statusCode, code, detail), cancellationToken);
    }

    private static void AddExtensions(ProblemDetails problem, HttpContext context, string code)
    {
        problem.Extensions["code"] = code;
        problem.Extensions["traceId"] = context.TraceIdentifier;
    }

    private static (string Title, string Detail) Describe(int statusCode, string code) => code switch
    {
        ApiErrorCodes.Unauthenticated => ("Autenticación requerida", "Inicia sesión con Discord para continuar."),
        ApiErrorCodes.UserNotRegistered => ("Sesión no disponible", "Inicia sesión nuevamente con Discord."),
        ApiErrorCodes.Forbidden => ("Acceso denegado", "No tienes acceso a este recurso."),
        ApiErrorCodes.Internal => ("Error inesperado", "Ocurrió un error inesperado. Inténtalo nuevamente."),
        ApiErrorCodes.InvalidPreferences => ("Preferencias inválidas", "Revisa el objetivo, intereses y habilidades enviados."),
        ApiErrorCodes.InvalidRoute => ("Ruta inválida", "Indica un objetivo válido y de 1 a 30 cursos sin repetir."),
        ApiErrorCodes.EmbeddingUnavailable => ("Servicio no disponible", "El servicio de recomendaciones no está disponible. Inténtalo nuevamente."),
        ApiErrorCodes.EmbeddingFailed => ("No se pudo generar la recomendación", "El servicio de recomendaciones no pudo procesar la solicitud."),
        _ when statusCode == StatusCodes.Status404NotFound => ("Recurso no encontrado", "No se encontró el recurso solicitado."),
        _ when statusCode == StatusCodes.Status409Conflict => ("Estado incompatible", "No es posible completar esta operación con el estado actual."),
        _ when statusCode == StatusCodes.Status400BadRequest => ("Solicitud inválida", "Revisa los datos enviados."),
        _ when statusCode >= StatusCodes.Status500InternalServerError => ("Error del servicio", "Ocurrió un problema al procesar la solicitud."),
        _ => ("No se pudo completar la solicitud", "Revisa los datos enviados e inténtalo nuevamente.")
    };
}
