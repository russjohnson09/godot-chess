using Xunit;
using CSharpCoinFlip;
using System;

namespace csharp_coin_flip_tests
{
    public class CoinFlipTests
    {
        [Fact]
        public void TestFlipReturnsValidCoin()
        {
            var coin = CoinFlipper.Flip();
            Assert.True(coin == Coin.Heads || coin == Coin.Tails);
        }

        [Fact]
        public void TestFlipWithSeededRandom()
        {
            var rng1 = new Random(42);
            var rng2 = new Random(42);

            var coin1 = CoinFlipper.Flip(rng1);
            var coin2 = CoinFlipper.Flip(rng2);

            Assert.Equal(coin1, coin2);
        }

        [Fact]
        public void TestMultipleFlipsDistribution()
        {
            var rng = new Random(123);
            int headsCount = 0;
            int tailsCount = 0;

            for (int i = 0; i < 100; i++)
            {
                var coin = CoinFlipper.Flip(rng);
                if (coin == Coin.Heads) headsCount++;
                else tailsCount++;
            }

            Assert.True(headsCount > 0);
            Assert.True(tailsCount > 0);
            Assert.Equal(100, headsCount + tailsCount);
        }

        [Fact]
        public void TestCoinToStringOrDisplay()
        {
            Assert.Equal("Heads", Coin.Heads.ToString());
            Assert.Equal("Tails", Coin.Tails.ToString());
        }
    }
}
