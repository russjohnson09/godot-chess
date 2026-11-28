# Test
```
cargo test
```

# Build
<!--   -w /src \
 -->
```
<!-- docker run --rm \
  -v "${PWD}:/src" \
  rust:bookworm \
  cargo build --release --target x86_64-unknown-linux-gnu -->


cargo build and cargo build --release for windows if running on a windows machine.

I'm also building the android version on a windows machine.

For ubuntu it is Ubuntu on WSL 2. This is also what I used for raspberry pi pico.

```
sudo apt update
sudo apt install build-essential
rustup target add x86_64-unknown-linux-gnu
```


ls /c/Users/russj/AppData/Local/Android/Sdk/ndk/30.0.16248370/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android37-clang
ls /c/Users/russj/AppData/Local/Android/Sdk/ndk/30.0.16248370/toolchains/llvm/prebuilt/windows-x86_64/bin/clang

```
rustup target add aarch64-linux-android
cargo build

CLANG_PATH="/c/Users/russj/AppData/Local/Android/Sdk/ndk/30.0.16248370/toolchains/llvm/prebuilt/windows-x86_64/bin/clang"
CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="/c/Users/russj/AppData/Local/Android/Sdk/ndk/30.0.16248370/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android37-clang"
cargo build --target aarch64-linux-android
```




Set CLANG_PATH and Cargo’s linker to the Clang binaries inside the Android NDK Godot is configured to use. Replace the paths and API level with the ones installed on your machine:

C:\Users\russj\AppData\Local/Android/Sdk

export CLANG_PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/clang"
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android35-clang"


cargo build --target aarch64-linux-android


cargo build --release --target aarch64-linux-android

error: linking with `cc` failed: exit code: 1                                                                                                                                               
  |
  = note: "cc" "-Wl,--version-script=C:\\Users\\russj\\dev\\godot-chess\\rust\\example_extension\\target\\aarch64-linux-android\\release\\build\\rust_extension/197b43c3c930378a\\out\\rustctRLLNT\\list" "-Wl,--no-un






https://godot-rust.github.io/book/intro/hello-world.html


cargo new "{YourCrate}" --lib



Build the Rust extension separately for each Android architecture you plan to export. For ARM64, this example uses aarch64-linux-android, which maps to Godot’s android.*.arm64 key.

First, install the Rust target and cargo-ndk:

bash


rustup target add aarch64-linux-android
cargo install cargo-ndk
Set ANDROID_NDK_HOME to the NDK directory Godot uses—not the Android SDK directory—then build debug and release libraries:

bash


export ANDROID_NDK_HOME="$HOME/Android/Sdk/ndk/<your-ndk-version>"

cargo ndk -t arm64-v8a build
cargo ndk -t arm64-v8a build --release



Install it through Android Studio’s SDK Manager:

Open Tools → SDK Manager.
Select SDK Tools.
Check NDK (Side by side), then click Apply.
After installation, find it inside your Android SDK folder under ndk/<version>/. For example: ~/Android/Sdk/ndk/<version> on Linux, ~/Library/Android/sdk/ndk/<version> on macOS, or %LOCALAPPDATA%\Android\Sdk\ndk\<version> on Windows.
Set ANDROID_NDK_HOME to that versioned NDK folder and use the same path with cargo-ndk. Godot’s configured SDK path is the parent folder; don’t point ANDROID_NDK_HOME at the SDK root.


The Android NDK is a toolkit for building native code—such as Rust or C/C++—that runs on Android. It provides Android-specific compilers, linkers, and system libraries.

For your Godot Rust extension, Cargo uses the NDK toolchain to compile Rust into an Android-compatible .so library for the target CPU architecture, such as ARM64. Godot then loads that library when the exported app runs. The Android SDK is the broader toolkit used to package and deploy apps; the NDK supplies the native-build tools needed for your extension.