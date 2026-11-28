using Microsoft.VisualStudio.TestTools.UnitTesting;
using CoinFlipLib;

namespace CoinFlipLib.Tests;

[TestClass]
public class CoinFlipLibTests
{
    [TestMethod]
    public void TestToDisplayTextHeads()
    {
        Assert.AreEqual("HEADS", CoinFlipper.ToDisplayText(CoinSide.Heads));
    }

    [TestMethod]
    public void TestToDisplayTextTails()
    {
        Assert.AreEqual("TAILS", CoinFlipper.ToDisplayText(CoinSide.Tails));
    }

    [TestMethod]
    public void TestFlipReturnsValidCoinSide()
    {
        var side = CoinFlipper.Flip();
        Assert.IsTrue(side == CoinSide.Heads || side == CoinSide.Tails);
    }

    [TestMethod]
    public void TestFlipTextReturnsHeadsOrTails()
    {
        var text = CoinFlipper.FlipText();
        Assert.IsTrue(text == "HEADS" || text == "TAILS");
    }

    [TestMethod]
    public void TestMultipleFlipsProduceBothOutcomes()
    {
        int heads = 0;
        int tails = 0;
        var rng = new Random(42);

        for (int i = 0; i < 100; i++)
        {
            var result = CoinFlipper.FlipText(rng);
            if (result == "HEADS") heads++;
            else if (result == "TAILS") tails++;
            else Assert.Fail($"Unexpected result: {result}");
        }

        Assert.IsTrue(heads > 0);
        Assert.IsTrue(tails > 0);
        Assert.AreEqual(100, heads + tails);
    }

    [TestMethod]
    public void TestRenderTerminal()
    {
        var rendered = CoinFlipper.RenderTerminal(CoinSide.Heads);
        Assert.IsTrue(rendered.Contains("HEADS"));
        Assert.IsTrue(rendered.Contains("┌─────────────────┐"));
    }

    [TestMethod]
    public void TestRenderTerminalTails()
    {
        var rendered = CoinFlipper.RenderTerminal(CoinSide.Tails);
        Assert.IsTrue(rendered.Contains("TAILS"));
        Assert.IsTrue(rendered.Contains("┌─────────────────┐"));
    }

    [TestMethod]
    public void TestRenderWelcome()
    {
        var welcome = CoinFlipper.RenderWelcome();
        Assert.IsTrue(welcome.Contains("SHARED LIBRARY"));
    }
}
