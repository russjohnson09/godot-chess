using System;

namespace CSharpCoinFlipMaui;

public enum Coin
{
    Heads,
    Tails
}

public static class CoinFlipper
{
    public static Coin Flip(Random? rng = null)
    {
        rng ??= Random.Shared;
        return rng.Next(2) == 0 ? Coin.Heads : Coin.Tails;
    }
}
