using CodeQuest2026.Server.Extensions;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.ConfigureService(builder.Configuration);

const string frontendCorsPolicy = "Frontend";
var allowedOrigins = builder.Configuration
    .GetSection("Cors:AllowedOrigins")
    .Get<string[]>() ?? [];

builder.Services.AddCors(options =>
{
    options.AddPolicy(frontendCorsPolicy, policy =>
    {
        policy.WithOrigins(allowedOrigins)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}
else if (File.Exists(Path.Combine(app.Environment.WebRootPath
    ?? Path.Combine(app.Environment.ContentRootPath, "wwwroot"), "index.html")))
{
    app.UseDefaultFiles();
    app.MapStaticAssets();
    app.MapFallbackToFile("/index.html");
}

if (!app.Environment.IsDevelopment())
{
    app.UseHttpsRedirection();
}

app.UseCors(frontendCorsPolicy);
app.UseAuthorization();

app.MapControllers();

app.MapHealthChecks("/health");
app.MapHealthChecks("/health/api", new HealthCheckOptions
{
    Predicate = registration => registration.Tags.Contains("api")
});
app.MapHealthChecks("/health/db", new HealthCheckOptions
{
    Predicate = registration => registration.Tags.Contains("db")
});

app.Run();
