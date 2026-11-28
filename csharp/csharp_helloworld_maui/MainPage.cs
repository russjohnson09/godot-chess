using Microsoft.Maui.Controls;

namespace CSharpHelloworldMaui;

public class MainPage : ContentPage
{
    private readonly Label _helloLabel;

    public MainPage()
    {
        _helloLabel = new Label
        {
            Text = "Hello, World!",
            FontSize = 32,
            HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center
        };

        Content = new VerticalStackLayout
        {
            Spacing = 20,
            VerticalOptions = LayoutOptions.Center,
            Children =
            {
                _helloLabel
            }
        };
    }
}
