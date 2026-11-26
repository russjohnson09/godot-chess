# C# .NET MAUI Coin Flip GUI Example

## Purpose
This module provides a new graphical user interface (GUI) written using .NET MAUI (`csharp_coinflip_maui`). It features a single button "Flip Coin" that simulates a coin flip and a text label that displays "HEADS" or "TAILS".

## How to Run / Build
To build the .NET MAUI coin flip application:
```bash
dotnet build csharp_coinflip_maui/csharp_coinflip_maui.csproj
```

To build and publish an executable / output binaries:
```bash
dotnet publish -c Release -r win-x64 --self-contained true  -p:PublishSingleFile=true
dotnet run --project csharp_coinflip_maui
dotnet publish csharp_coinflip_maui/csharp_coinflip_maui.csproj -c Release
dotnet publish csharp_coinflip_maui/csharp_coinflip_maui.csproj -f net10.0-windows10.0.19041.0 -c Release
dotnet publish csharp_coinflip_maui/csharp_coinflip_maui.csproj -c Release -r win-x64
dotnet publish csharp_coinflip_maui/csharp_coinflip_maui.csproj -c Release -r win-x64 --self-contained true
dotnet publish csharp_coinflip_maui/csharp_coinflip_maui.csproj -c Release -r win-x64 --self-contained true  -p:PublishSingleFile=true


```

## How to Test
To run the unit tests:
```bash
dotnet test csharp_coinflip_maui/Tests/csharp_coinflip_maui.Tests.csproj
```
