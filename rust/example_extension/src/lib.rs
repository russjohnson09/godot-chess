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
        make_greeting(&name.to_string()).into()
    }
}

fn make_greeting(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::make_greeting;

    #[test]
    fn greet_formats_name() {
        assert_eq!(make_greeting("Godot"), "Hello, Godot!");
    }
}