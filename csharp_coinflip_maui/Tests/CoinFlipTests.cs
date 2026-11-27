using System.Text.RegularExpressions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using FreshMaui;

namespace FreshMaui.Tests;

[TestClass]
public class CoinFlipTests
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
    public void TestMainPageXamlContainsSingleFlipCoinButtonAndResultLabel()
    {
        var xamlPath = Path.Combine(AppContext.BaseDirectory, "MainPage.xaml");
        Assert.IsTrue(File.Exists(xamlPath), $"Expected MainPage.xaml at {xamlPath}");

        var xaml = File.ReadAllText(xamlPath);
        Assert.AreEqual(1, Regex.Matches(xaml, @"<Button\b").Count);
        Assert.IsTrue(xaml.Contains("Text=\"Flip Coin\""));
        Assert.IsTrue(xaml.Contains("Clicked=\"OnFlipCoinClicked\""));
        Assert.IsTrue(xaml.Contains("<Label"));
        Assert.IsTrue(xaml.Contains("x:Name=\"ResultLabel\""));
    }
}
