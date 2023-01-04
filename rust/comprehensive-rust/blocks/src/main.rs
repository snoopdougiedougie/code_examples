// A block in Rust has a value and a type: the value is the last expression of the block:
fn double(x: i32) -> i32 {
    x + x
}

fn main() {
    let x = {
        let y = 10;

        println!("y: {y}"); // Prints: "y: 10"

        let z = {
            let w = { 3 + 4 };

            println!("w: {w}"); // Prints: "w: 7"

            y * w
        };
        println!("z: {z}"); // Prints: "z: 70"
        z - y
    };

    println!("x: {x}"); // Prints: "x: 60"
    println!();

    println!("doubled: {}", double(7)); // Prints: "doubled: 14"
}
