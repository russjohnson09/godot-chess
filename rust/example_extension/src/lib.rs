use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

#[derive(GodotClass)]
#[class(base=Node)]
struct RustGreeter {
    #[base]
    base: Base<Node>,
}

#[godot_api]
impl INode for RustGreeter {
    fn init(base: Base<Node>) -> Self {
        Self { base }
    }
}

#[godot_api]
impl RustGreeter {
    #[func]
    fn greet(&self, name: GString) -> GString {
        format!("Hello, {}!", name).into()
    }
}
