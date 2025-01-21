using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHealthChecks();

var app = builder.Build();

app.MapHealthChecks("/healthz")
    .RequireHost("localhost:5001")
    .AllowAnonymous();

app.MapGet("/", () => "Hello World!");

app.MapPost("/name", ([FromForm] string name) => $"Hello {name}!").DisableAntiforgery();

app.Run();
