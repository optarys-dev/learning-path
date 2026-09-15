using CodeQuest2026.Server.Extensions;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.ConfigureService(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
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

app.UseCors(opt => {
    opt.AllowAnyOrigin();

    if (app.Environment.IsDevelopment())
    {
        opt.WithOrigins("*");
    }
});

app.UseHttpsRedirection();

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

