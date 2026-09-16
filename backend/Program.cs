using CodeQuest2026.Server.Application.Oauth2.Discord;
using CodeQuest2026.Server.Extensions;
using CodeQuest2026.Server.Infrastructure.OpenApi;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.OpenApi;
using Swashbuckle.AspNetCore.SwaggerUI;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "CodeQuest2026 API",
        Version = "v1",
        Description = "API para autenticación con Discord, usuarios y recomendaciones de aprendizaje. " +
                      "Para probar rutas protegidas, inicia sesión abriendo /auth/discord en este mismo navegador."
    });
    options.AddSecurityDefinition("sessionCookie", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.ApiKey,
        In = ParameterLocation.Cookie,
        Name = "CodeQuest.Session",
        Description = "Cookie HttpOnly creada por el inicio de sesión con Discord. El navegador la envía automáticamente."
    });
    options.OperationFilter<SessionCookieOperationFilter>();
    var xmlFile = $"{typeof(Program).Assembly.GetName().Name}.xml";
    options.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, xmlFile));
});
builder.Services.ConfigureService(builder.Configuration);
builder.Services.AddDiscordAuthentication(builder.Configuration, builder.Environment.IsDevelopment());

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
            .AllowAnyMethod()
            .AllowCredentials();
    });
});

var app = builder.Build();

app.UseDiscordHttpsCallback(builder.Configuration, app.Environment.IsDevelopment());

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "CodeQuest2026 API v1");
        options.RoutePrefix = "swagger";
        options.DocumentTitle = "CodeQuest2026 API";
        options.DocExpansion(DocExpansion.List);
        options.DisplayRequestDuration();
        options.EnableTryItOutByDefault();
    });
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
app.UseAuthentication();
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
