using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSharpCoinFlip;

namespace CSharpCoinFlip.Tests;

[TestClass]
public class CoinTests
{
    [TestMethod]
    public void TestFlipReturnsValidCoin()
    {
        var coin = CoinFlipper.Flip();
        Assert.IsTrue(coin == Coin.Heads || coin == Coin.Tails);
    }

    [TestMethod]
    public void TestMultipleFlips()
    {
        int heads = 0;
        int tails = 0;
        for (int i = 0; i < 100; i++)
        {
            var coin = CoinFlipper.Flip();
            if (coin == Coin.Heads) heads++;
            else tails++;
        }
        Assert.IsTrue(heads > 0);
        Assert.IsTrue(tails > 0);
        Assert.AreEqual(100, heads + tails);
    }

    [TestMethod]
    public void TestCoinGameRunStepFlip()
    {
        var game = new CoinGame();
        var response = game.RunStep("");
        Assert.IsTrue(response.StartsWith("The coin landed on:"));
    }

    [TestMethod]
    public void TestCoinGameRunStepQuit()
    {
        var game = new CoinGame();
        var response = game.RunStep("q");
        Assert.AreEqual("QUIT", response);

        var responseUpper = game.RunStep("Q");
        Assert.AreEqual("QUIT", responseUpper);
    }

    [TestMethod]
    public void TestGraphicalRendererHeads()
    {
        var rendered = CoinGraphicalRenderer.Render(Coin.Heads);
        Assert.IsTrue(rendered.Contains("HEADS"));
        Assert.IsTrue(rendered.Contains("┌─────────────────┐"));
    }

    [TestMethod]
    public void TestGraphicalRendererTails()
    {
        var rendered = CoinGraphicalRenderer.Render(Coin.Tails);
        Assert.IsTrue(rendered.Contains("TAILS"));
        Assert.IsTrue(rendered.Contains("└─────────────────┘"));
    }

    [TestMethod]
    public void TestGraphicalRendererWelcome()
    {
        var welcome = CoinGraphicalRenderer.RenderWelcome();
        Assert.IsTrue(welcome.Contains("GRAPHICAL MODE"));
    }

    [TestMethod]
    public void TestCoinGameRunGraphicalStep()
    {
        var game = new CoinGame();
        var response = game.RunGraphicalStep("");
        Assert.IsTrue(response.Contains("┌─────────────────┐"));
    }

    [TestMethod]
    public void TestCoinGameRunGraphicalStepQuit()
    {
        var game = new CoinGame();
        var response = game.RunGraphicalStep("q");
        Assert.AreEqual("QUIT", response);
    }
}
