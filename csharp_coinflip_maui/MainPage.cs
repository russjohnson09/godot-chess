using Microsoft.Maui.Controls;

namespace CSharpCoinFlipMaui;

public class MainPage : ContentPage
{
    private readonly Label _resultLabel;
    private readonly Button _flipButton;

    public MainPage()
    {
        _resultLabel = new Label
        {
            Text = "TAILS",
            FontSize = 32,
            HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center
        };

        _flipButton = new Button
        {
            Text = "Flip Coin",
            FontSize = 24,
            HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center
        };

        _flipButton.Clicked += (sender, args) =>
        {
            var result = CoinFlipper.Flip();
            _resultLabel.Text = result == Coin.Heads ? "HEADS" : "TAILS";
        };

        Content = new VerticalStackLayout
        {
            Spacing = 20,
            VerticalOptions = LayoutOptions.Center,
            Children =
            {
                _resultLabel,
                _flipButton
            }
        };
    }
}
