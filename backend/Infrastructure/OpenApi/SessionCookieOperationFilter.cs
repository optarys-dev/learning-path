using Microsoft.AspNetCore.Authorization;
using Microsoft.OpenApi;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace CodeQuest2026.Server.Infrastructure.OpenApi;

/// <summary>Marca en OpenAPI las operaciones que requieren la cookie de sesión.</summary>
public sealed class SessionCookieOperationFilter : IOperationFilter
{
    public void Apply(OpenApiOperation operation, OperationFilterContext context)
    {
        var metadata = context.MethodInfo.DeclaringType?.GetCustomAttributes(true)
            .Concat(context.MethodInfo.GetCustomAttributes(true)) ?? [];

        if (!metadata.OfType<AuthorizeAttribute>().Any()
            || metadata.OfType<AllowAnonymousAttribute>().Any())
            return;

        operation.Security =
        [
            new OpenApiSecurityRequirement
            {
                [new OpenApiSecuritySchemeReference("sessionCookie", context.Document)] = []
            }
        ];
    }
}
