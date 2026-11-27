# C# .NET MAUI Coin Flip GUI Example

## Purpose
This module updates the existing .NET MAUI application under `csharp_coinflip_maui` (`FreshMaui.csproj`) into a coin flip GUI. It features a single button `"Flip Coin"` that simulates a coin flip using `CoinFlipper` and a text label (`ResultLabel`) that displays `"HEADS"` or `"TAILS"`.

## How to Run / Build
Building and running the MAUI app requires .NET 11 with the MAUI workloads installed for your target platform.

To build the .NET MAUI coin flip application:
```bash
dotnet build csharp_coinflip_maui/FreshMaui.csproj
```

To run on Windows:
```bash
dotnet run --project csharp_coinflip_maui/FreshMaui.csproj -f net11.0-windows10.0.19041.0
```

To publish on Windows:
```bash
dotnet publish csharp_coinflip_maui/FreshMaui.csproj -c Release -f net11.0-windows10.0.19041.0 -r win-x64
```

## How to Test
To run the unit tests (runs on .NET 9+ without requiring MAUI workloads):
```bash
dotnet test csharp_coinflip_maui/Tests/csharp_coinflip_maui.Tests.csproj
```
