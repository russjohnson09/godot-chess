using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSharpHelloworldMaui;

namespace CSharpHelloworldMaui.Tests;

[TestClass]
public class HelloWorldTests
{
    [TestMethod]
    public void TestMainPageInitialization()
    {
        var page = new MainPage();
        Assert.IsNotNull(page);
    }
}
