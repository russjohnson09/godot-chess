using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSharpCoinFlip;
using System;

namespace csharp_coin_flip_tests;

[TestClass]
public sealed class CoinFlipTests
{
    [TestMethod]
    public void TestFlipCoinValid()
    {
        var coin = CoinFlip.Flip();
        Assert.IsTrue(coin == Coin.Heads || coin == Coin.Tails);
    }

    [TestMethod]
    public void TestCoinString()
    {
        Assert.AreEqual("Heads", CoinFlip.GetCoinString(Coin.Heads));
        Assert.AreEqual("Tails", CoinFlip.GetCoinString(Coin.Tails));
    }

    [TestMethod]
    public void TestMultipleFlips()
    {
        var rng = new Random(42);
        int headsCount = 0;
        int tailsCount = 0;
        for (int i = 0; i < 100; i++)
        {
            var coin = CoinFlip.Flip(rng);
            if (coin == Coin.Heads) headsCount++;
            else tailsCount++;
        }
        Assert.IsTrue(headsCount > 0);
        Assert.IsTrue(tailsCount > 0);
        Assert.AreEqual(100, headsCount + tailsCount);
    }
}
