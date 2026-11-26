Official scripting options
Godot’s officially supported options are GDScript, C#, C, and C++. C and C++ are supported through GDExtension. Community bindings may not be production-ready, so check their current status and compatibility with your Godot version before choosing one.



Pick GDScript by default — it’s built in, needs no extra tooling, exports everywhere including the web, and is fast enough for the vast majority of indie games. Pick C# if you’re coming from Unity, need the .NET/NuGet ecosystem, or are writing compute-heavy systems where its extra speed actually matters. Reach for C++ (via GDExtension) only when a specific hot path — custom physics, procedural generation, pathfinding at scale — needs native performance neither GDScript nor C# can deliver.