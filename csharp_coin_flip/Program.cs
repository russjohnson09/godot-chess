using System;

namespace CSharpCoinFlip
{
    public enum Coin
    {
        Heads,
        Tails
    }

    public static class CoinFlip
    {
        private static readonly Random s_random = new Random();

        public static Coin Flip(Random? rng = null)
        {
            var r = rng ?? s_random;
            return r.Next(2) == 0 ? Coin.Heads : Coin.Tails;
        }

        public static string GetCoinString(Coin coin)
        {
            return coin switch
            {
                Coin.Heads => "Heads",
                Coin.Tails => "Tails",
                _ => throw new ArgumentOutOfRangeException(nameof(coin))
            };
        }
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            var coin = CoinFlip.Flip();
            Console.WriteLine($"The coin landed on: {CoinFlip.GetCoinString(coin)}");
        }
    }
}
