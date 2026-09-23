using CodeQuest2026.Server.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging.Abstractions;
using System.Text.Json;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class ApiExceptionHandlerTests
{
    [Fact]
    public async Task UnexpectedExceptionReturnsSafeProblemDetails()
    {
        var context = new DefaultHttpContext();
        context.Request.Path = "/routes";
        context.Response.Body = new MemoryStream();
        var handler = new ApiExceptionHandler(NullLogger<ApiExceptionHandler>.Instance);

        var handled = await handler.TryHandleAsync(
            context, new InvalidOperationException("private database detail"), CancellationToken.None);

        Assert.True(handled);
        Assert.Equal(StatusCodes.Status500InternalServerError, context.Response.StatusCode);
        context.Response.Body.Position = 0;
        using var body = await JsonDocument.ParseAsync(context.Response.Body);
        Assert.Equal("internal_error", body.RootElement.GetProperty("code").GetString());
        Assert.Equal(StatusCodes.Status500InternalServerError, body.RootElement.GetProperty("status").GetInt32());
        Assert.Equal(context.TraceIdentifier, body.RootElement.GetProperty("traceId").GetString());
        Assert.DoesNotContain("private database detail", body.RootElement.ToString());
    }

    [Fact]
    public async Task DomainValidationReturnsStableProblemDetails()
    {
        var context = new DefaultHttpContext();
        context.Request.Path = "/routes";
        context.Response.Body = new MemoryStream();
        var handler = new ApiExceptionHandler(NullLogger<ApiExceptionHandler>.Instance);

        await handler.TryHandleAsync(context,
            new CodeQuest2026.Server.Application.Common.DomainValidationException(
                CodeQuest2026.Server.Application.Common.ApiErrorCodes.InvalidRoute),
            CancellationToken.None);

        Assert.Equal(StatusCodes.Status400BadRequest, context.Response.StatusCode);
        context.Response.Body.Position = 0;
        using var body = await JsonDocument.ParseAsync(context.Response.Body);
        Assert.Equal("invalid_route", body.RootElement.GetProperty("code").GetString());
        Assert.Equal(context.TraceIdentifier, body.RootElement.GetProperty("traceId").GetString());
    }
}
