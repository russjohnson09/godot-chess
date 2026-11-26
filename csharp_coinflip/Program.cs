using System;

namespace CSharpCoinFlip;

public class CoinGame
{
    private readonly Random _rng;

    public CoinGame(Random? rng = null)
    {
        _rng = rng ?? Random.Shared;
    }

    public string RunStep(string? input)
    {
        if (input?.Trim().ToLower() == "q")
        {
            return "QUIT";
        }
        var result = CoinFlipper.Flip(_rng);
        return $"The coin landed on: {result}";
    }
}

class Program
{
    static void Main(string[] args)
    {
        var game = new CoinGame();
        Console.WriteLine("C# Coin Flip UI - Press Enter to flip, or type 'q' to quit.");
        
        while (true)
        {
            Console.Write("> ");
            var input = Console.ReadLine();
            var output = game.RunStep(input);
            if (output == "QUIT")
            {
                Console.WriteLine("Exiting. Goodbye!");
                break;
            }
            Console.WriteLine(output);
        }
    }
}
