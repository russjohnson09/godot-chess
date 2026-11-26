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
}
