namespace FreshMaui;

using CoinFlipLib;

public partial class MainPage : ContentPage
{
	public MainPage()
	{
		InitializeComponent();
	}

	private void OnFlipCoinClicked(object? sender, EventArgs e)
	{
		ResultLabel.Text = CoinFlipper.FlipText();
		SemanticScreenReader.Announce(ResultLabel.Text);
	}
}
