using System;

namespace CSharpCoinFlip
{
    public enum Coin
    {
        Heads,
        Tails
    }

    public static class CoinFlipper
    {
        private static readonly Random DefaultRandom = new Random();

        public static Coin Flip(Random? rng = null)
        {
            var random = rng ?? DefaultRandom;
            return random.Next(2) == 0 ? Coin.Heads : Coin.Tails;
        }
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            var result = CoinFlipper.Flip();
            Console.WriteLine($"The coin landed on: {result}");
        }
    }
}
