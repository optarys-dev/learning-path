using CodeQuest2026.Server.Application.Common;
using Microsoft.AspNetCore.Diagnostics;

namespace CodeQuest2026.Server.Infrastructure;

/// <summary>Convierte fallos imprevistos en una respuesta pública uniforme.</summary>
public sealed class ApiExceptionHandler(ILogger<ApiExceptionHandler> logger) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        using var scope = logger.BeginScope(new Dictionary<string, object?>
        {
            ["TraceId"] = httpContext.TraceIdentifier
        });

        if (exception is DomainValidationException validationException)
        {
            await ApiProblemDetailsFactory.WriteAsync(httpContext, StatusCodes.Status400BadRequest,
                validationException.Code, cancellationToken: cancellationToken);
            return true;
        }

        logger.LogError(exception, "Unhandled API exception for {Path}", httpContext.Request.Path);
        await ApiProblemDetailsFactory.WriteAsync(httpContext, StatusCodes.Status500InternalServerError,
            ApiErrorCodes.Internal, cancellationToken: cancellationToken);
        return true;
    }
}
