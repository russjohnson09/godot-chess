using System;

namespace CSharpCoinFlip;

public static class CoinGraphicalRenderer
{
    public static string Render(Coin coin)
    {
        var label = coin == Coin.Heads ? "HEADS" : "TAILS";
        return string.Join(Environment.NewLine, new[]
        {
            "┌─────────────────┐",
            $"│     [ {label} ]     │",
            "└─────────────────┘"
        });
    }

    public static string RenderWelcome()
    {
        return string.Join(Environment.NewLine, new[]
        {
            "=================================",
            "  C# COIN FLIP - GRAPHICAL MODE  ",
            "================================="
        });
    }
}
