using CodeQuest2026.Server.Application.Common;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace CodeQuest2026.Server.Infrastructure;

/// <summary>Temporarily adapts legacy controller errors to RFC 9457 Problem Details.</summary>
public sealed class ApiErrorResponseFilter : IAsyncResultFilter
{
    public Task OnResultExecutionAsync(ResultExecutingContext context, ResultExecutionDelegate next)
    {
        if (context.Result is not ObjectResult { Value: ApiErrorDto legacy } result) return next();
        var statusCode = result.StatusCode ?? context.HttpContext.Response.StatusCode;
        var code = legacy.Error == "unauthorized" ? ApiErrorCodes.Unauthenticated : legacy.Error;
        var detail = code is ApiErrorCodes.EmbeddingFailed or ApiErrorCodes.EmbeddingUnavailable
            ? null
            : legacy.Message;
        result.Value = ApiProblemDetailsFactory.Create(context.HttpContext, statusCode, code, detail);
        result.ContentTypes.Clear();
        result.ContentTypes.Add("application/problem+json");

        return next();
    }
}
