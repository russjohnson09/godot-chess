using Microsoft.Maui;
using Microsoft.Maui.Hosting;

namespace CSharpCoinFlipMaui;

public class Program : Microsoft.Maui.Controls.MauiWinUIApplication
{
    protected override MauiApp CreateMauiApp() => MauiProgram.CreateMauiApp();

    [STAThread]
    public static void Main(string[] args)
    {
        Microsoft.UI.Xaml.Application.Start((p) =>
        {
            var context = new Microsoft.UI.Xaml.ApplicationInitializationCallback(p);
            new Program();
        });
    }
}
