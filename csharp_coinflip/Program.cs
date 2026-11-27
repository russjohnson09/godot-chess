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

    public string RunGraphicalStep(string? input)
    {
        if (input?.Trim().ToLower() == "q")
        {
            return "QUIT";
        }
        var result = CoinFlipper.Flip(_rng);
        return CoinGraphicalRenderer.Render(result);
    }
}

class Program
{
    static void Main(string[] args)
    {
        var game = new CoinGame();
        bool isGui = args.Length > 0 && (args[0] == "--gui" || args[0] == "-g");

        if (isGui)
        {
            Console.WriteLine(CoinGraphicalRenderer.RenderWelcome());
            Console.WriteLine("Graphical Mode - Press Enter to flip, or type 'q' to quit.");
            while (true)
            {
                Console.Write("GUI> ");
                var input = Console.ReadLine();
                if (input?.Trim().ToLower() == "q")
                {
                    Console.WriteLine("Exiting Graphical Mode. Goodbye!");
                    break;
                }
                var output = game.RunGraphicalStep(input);
                if (output == "QUIT")
                {
                    break;
                }
                Console.WriteLine(output);
            }
        }
        else
        {
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
}
