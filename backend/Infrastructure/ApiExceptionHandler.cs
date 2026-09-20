using CodeQuest2026.Server.Application.Common;
using Microsoft.AspNetCore.Diagnostics;

namespace CodeQuest2026.Server.Infrastructure;

/// <summary>Convierte fallos imprevistos en una respuesta pública uniforme.</summary>
public sealed class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        logger.LogError(exception, "Unhandled API exception for {Path}", httpContext.Request.Path);
        httpContext.Response.StatusCode = StatusCodes.Status500InternalServerError;
        await httpContext.Response.WriteAsJsonAsync(
            new ApiErrorDto("internal_error", "Ocurrió un error inesperado. Inténtalo nuevamente."),
            cancellationToken);
        return true;
    }
}
