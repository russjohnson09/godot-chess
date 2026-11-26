https://docs.gitar.ai/introduction#with-gitar

A SonarQube product it seems.

https://app.gitar.ai/russjohnson09/dashboard



https://godot-rust.github.io/


https://gtstu.com/gdscript-vs-csharp-godot-4-indie-developers/

Pick GDScript by default — it’s built in, needs no extra tooling, exports everywhere including the web, and is fast enough for the vast majority of indie games. Pick C# if you’re coming from Unity, need the .NET/NuGet ecosystem, or are writing compute-heavy systems where its extra speed actually matters. Reach for C++ (via GDExtension) only when a specific hot path — custom physics, procedural generation, pathfinding at scale — needs native performance neither GDScript nor C# can deliver.


I'm chosing C# because I want something that is portable and easily testable outside of godot. There are community supported unit testing tools, but C# will just have this built in.



https://stackoverflow.com/questions/59269850/caching-apt-packages-in-github-actions-workflow


https://github.com/abarichello/godot-ci


- [ ] Setup a image builder job according to instructions in https://docs.github.com/en/actions/how-tos/manage-runners/larger-runners/use-custom-images#setting-up-an-image-generation-runner



$ dotnet new list



I want to use C# for godot extensions but I'm afraid that will hurt support for steamdeck, andriod, and ubuntu.
Using C# for Godot extensions will not hurt support for Steam Deck, Android, or Ubuntu. Godot has strong, built-in, and officially supported C# (.NET) runtimes for all of these platforms.
Here is how each platform is supported:
1. Steam Deck (Linux x86_64): Fully supported. The Godot .NET runtime for Linux handles C# out of the box. Since the Steam Deck runs SteamOS (an Arch Linux distro), your C# GDExtensions/scripts will run smoothly.
2. Android: Fully supported. Godot exports C# projects to Android by bundling the NativeAOT or Mono runtime for ARM/ARM64. 
3. Ubuntu (Linux): Fully supported. Linux is a primary desktop target for Godot's C# export templates.



https://dotnet.microsoft.com/en-us/apps/maui

* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 500, model: gemini-3.5-flash-lite, description: Generate content requests per day limit exceeded on Free Tier. See https://aistudio.google.com/docs/rate-limits.
