using System;

namespace CSharpCoinFlip;

class Program
{
    static void Main(string[] args)
    {
        var result = CoinFlipper.Flip();
        Console.WriteLine($"The coin landed on: {result}");
    }
}
