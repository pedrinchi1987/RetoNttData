using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;

namespace DevOpsService.Controllers;

[ApiController]
[Route("/[controller]")]
public class DevOpsController : ControllerBase
{
    private readonly IConfiguration _config;
    private readonly JwtService _jwtService;
    private readonly IMemoryCache _cache;
    private const string API_KEY = "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c";

    public DevOpsController(IConfiguration config, JwtService jwtService, IMemoryCache cache)
    {
        _config = config;
        _jwtService = jwtService;
        _cache = cache;
    }

    [HttpPost]
    public IActionResult Post([FromBody] DevOpsRequest request)
    {
        if (!Request.Headers.TryGetValue("X-Parse-REST-API-Key", out var apiKey) || apiKey != API_KEY)
            return Unauthorized(new { error = "Invalid API Key" });

        if (!Request.Headers.TryGetValue("X-JWT-KWY", out var jwt))
            return Unauthorized(new { error = "Missing JWT header" });

        var validation = _jwtService.ValidateToken(jwt, out var jwtId, out var subject);
        Console.WriteLine("jwt=" + jwt);
        Console.WriteLine("jwtId=" + jwtId);
        Console.WriteLine("subject=" + subject);
        if (!validation)
            return Unauthorized(new { error = "Invalid JWT - (jwt= "+jwt+" ) - (jwtId="+jwtId+") - (subject="+subject+")" });

        if (_cache.TryGetValue(jwtId, out _))
            return BadRequest(new { error = "JWT already used" });

        var ttl = request?.timeToLifeSec ?? 60;
        _cache.Set(jwtId, true, TimeSpan.FromSeconds(Math.Max(30, ttl)));

        if (Request.Method != HttpMethods.Post)
            return BadRequest(new { error = "ERROR" });

        return Ok(new { message = $"Hello {request.to} your message will be sent" });
    }

    [HttpGet, HttpPut, HttpDelete, HttpPatch, HttpHead, HttpOptions]
    public IActionResult OtherMethods()
    {
        return BadRequest(new { error = "ERROR" });
    }
}
