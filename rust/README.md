# Rust

## Create new rust project

The following command creates a new project *PROJECT-NAME*,
in the folder *PROJECT-NAME* within the current folder.

```shell
cargo new PROJECT-NAME
```

Here's the structure:

```console
./PROJECT-NAME
./PROJECT-NAME/Cargo.toml
./PROJECT-NAME/src/main.rs
```

Here's the content of *src/main.rs*:

```rust
fn main() {
    println!("Hello, world!");
}
```

Run the following command
from the root of *PROJECT-NAME*:

```shell
cargo run
```

It should display:

```console
Hello, world!
```

