using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;
using Microsoft.AspNetCore.Mvc.Testing;
using DevOpsService;

namespace DevOpsService.Tests;

public class DevOpsControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public DevOpsControllerTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Post_ValidRequest_ReturnsOkMessage()
    {
        var client = _factory.CreateClient();

        var jwt = DevOpsService.Services.JwtService.CreateJwt(
            secret: Environment.GetEnvironmentVariable("JWT_SECRET") ?? "dev-secret-change-me",
            subject: "test-subject",
            ttlSeconds: 60);

        var request = new
        {
            message = "This is a test",
            to = "Juan Perez",
            from = "Rita Asturia",
            timeToLifeSec = 45
        };

        var httpRequest = new HttpRequestMessage(HttpMethod.Post, "/DevOps");
        httpRequest.Content = JsonContent.Create(request);
        httpRequest.Headers.Add("X-Parse-REST-API-Key", "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c");
        httpRequest.Headers.Add("X-JWT-KWY", jwt);

        var response = await client.SendAsync(httpRequest);
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Contains("Hello Juan Perez your message will be sent", body);
    }
}
