using CodeQuest2026.Server.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging.Abstractions;
using System.Text.Json;
using Xunit;

namespace CodeQuest2026.Server.Tests;

public sealed class ApiExceptionHandlerTests
{
    [Fact]
    public async Task UnexpectedExceptionReturnsSafeApiError()
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
        Assert.Equal("internal_error", body.RootElement.GetProperty("error").GetString());
        Assert.DoesNotContain("private database detail", body.RootElement.ToString());
    }
}
