namespace FreshMaui;

public enum CoinSide
{
	Heads,
	Tails
}

public static class CoinFlipper
{
	public static CoinSide Flip(Random? rng = null)
	{
		rng ??= Random.Shared;
		return rng.Next(2) == 0 ? CoinSide.Heads : CoinSide.Tails;
	}

	public static string ToDisplayText(CoinSide side)
	{
		return side == CoinSide.Heads ? "HEADS" : "TAILS";
	}

	public static string FlipText(Random? rng = null)
	{
		return ToDisplayText(Flip(rng));
	}
}
