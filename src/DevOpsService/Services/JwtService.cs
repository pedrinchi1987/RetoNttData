using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace DevOpsService;

public class JwtService
{
    private readonly string _secret;

    public JwtService(IConfiguration config)
    {
        _secret = Environment.GetEnvironmentVariable("JWT_SECRET") ?? config["JWT_SECRET"] ?? "dev-secret-change-me";
    }

    public bool ValidateToken(string token, out string jti, out string? subject)
    {
        jti = string.Empty;
        subject = null;
        try
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_secret);
            tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ClockSkew = TimeSpan.FromSeconds(5)
            }, out var validatedToken);

            var jwtToken = (JwtSecurityToken)validatedToken;
            jti = jwtToken.Id;
            subject = jwtToken.Subject;
            return true;
        }
        catch
        {
            return false;
        }
    }

    public static string CreateJwt(string secret, string subject = "user", int ttlSeconds = 60)
    {
        var key = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(secret));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var handler = new JwtSecurityTokenHandler();
        var jti = Guid.NewGuid().ToString();
        var token = new JwtSecurityToken(
            claims: new[] { new Claim(JwtRegisteredClaimNames.Sub, subject), new Claim(JwtRegisteredClaimNames.Jti, jti) },
            expires: DateTime.UtcNow.AddSeconds(ttlSeconds),
            signingCredentials: creds
        );
        return handler.WriteToken(token);
    }
}
