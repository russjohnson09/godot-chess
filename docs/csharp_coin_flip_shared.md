# C# Coin Flip Shared Library (`CoinFlipLib`)

## Purpose
This shared library (`CoinFlipLib`) provides a common, reusable coin flip core (`CoinFlipper`, `CoinSide`, terminal and display rendering) that can be consumed by both terminal console applications and Windows/MAUI applications.

## How to Build & Test
To build the shared library:
```bash
dotnet build csharp/coinflip/shared/CoinFlipLib.csproj
```

To run the unit tests for the shared library:
```bash
dotnet test csharp/coinflip/shared/Tests/CoinFlipLib.Tests.csproj
```

## Structure
- `csharp/coinflip/shared/CoinFlipLib.csproj`: Class library project file.
- `csharp/coinflip/shared/CoinFlipper.cs`: Core coin flip logic, side enum, text formatting, and terminal UI rendering helpers.
- `csharp/coinflip/shared/Tests/`: Unit tests validating coin flip randomness, text conversion, and rendering helpers.
