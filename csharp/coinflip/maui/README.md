

dotnet run --project src -f net11.0-windows10.0.19041.0

dotnet test Tests/csharp_coinflip_maui.Tests.csproj


dotnet clean
dotnet run -f net11.0-windows10.0.19041.0
dotnet build -f net11.0-windows10.0.19041.0

dotnet run --project csharp_coinflip_maui -f net11.0-windows10.0.19041.0



dotnet new maui -n FreshMaui


dotnet publish -c Release -f net11.0-windows10.0.19041.0 -r win-x64

dotnet run -f net11.0-windows10.0.19041.0


dotnet run -f net11.0-windows10.0.19041.0 --no-restore


dotnet run -f net11.0-windows10.0.19041.0 --no-restore -bl




