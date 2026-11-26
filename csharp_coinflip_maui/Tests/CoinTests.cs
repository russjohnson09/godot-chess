using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSharpCoinFlipMaui;

namespace CSharpCoinFlipMaui.Tests;

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
    public void TestMainPageInitialization()
    {
        var page = new MainPage();
        Assert.IsNotNull(page);
    }
}
