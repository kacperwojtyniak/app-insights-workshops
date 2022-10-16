using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI(options =>
{   
    options.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
    options.RoutePrefix = string.Empty;
});

app.MapGet("/status/{code}", (int code) => Results.StatusCode(code));

app.MapGet("/dependency", async () =>
{
    var url = Environment.GetEnvironmentVariable("API_URL");
    var client = new HttpClient();
    var result = await client.GetAsync(url);
    return $"Downstream returned {result.StatusCode}";
});

app.MapGet("/log", (ILogger<Program> logger) =>
{
    logger.LogInformation("Important information");
    logger.LogWarning("I am warning you!");
    logger.LogError("Something bad happened");
});

app.MapGet("/exception", (ILogger<Program> logger) =>
{
    throw new Exception("Boom!");
});

app.Run();