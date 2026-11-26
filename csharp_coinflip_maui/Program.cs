namespace CSharpCoinFlipMaui;

public class Program
{
    [STAThread]
    public static void Main(string[] args)
    {
        Console.WriteLine("Starting CSharpCoinFlipMaui Application...");
        var app = MauiProgram.CreateMauiApp();
        // Keep console alive for debug output
        Task.Run(() => app);
        
        // Launch standard application life-cycle
        Microsoft.Maui.Controls.Application.Current = new App();
    }
}
