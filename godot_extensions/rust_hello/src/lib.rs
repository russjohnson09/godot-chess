use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

#[derive(GodotClass)]
#[class(base=Node)]
struct HelloWorld {
    base: Base<Node>,
}

#[godot_api]
impl INode for HelloWorld {
    fn init(base: Base<Node>) -> Self {
        godot_print!("Hello, World from Rust in Godot!");
        Self { base }
    }
}
