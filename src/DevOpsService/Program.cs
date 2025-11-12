using DevOpsService;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// configure services
builder.Services.AddControllers();
builder.Services.AddMemoryCache();
builder.Services.AddSingleton<JwtService>();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.MapGet("/", () => Results.Ok(new
{
    message = "DevOps microservice is running. Try POST /DevOps or open /swagger"
}));

app.Run();
 
public partial class Program {}