public class DevOpsRequest
{
    public string? message { get; set; }
    public string? to { get; set; }
    public string? from { get; set; }
    public int timeToLifeSec { get; set; } = 45;
}
