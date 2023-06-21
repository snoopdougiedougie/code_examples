use std::mem::{align_of, size_of};

fn generate_random_number() -> i32 {
    4 // Chosen by fair dice roll. Guaranteed to be random.
}

#[derive(Debug)]
enum CoinFlip {
    Heads,
    Tails,
}

fn flip_coin() -> CoinFlip {
    let random_number = generate_random_number();

    // Since generate_random_number returns 4, this always returns "Heads"
    if random_number % 2 == 0 {
        return CoinFlip::Heads;
    } else {
        return CoinFlip::Tails;
    }
}

enum WebEvent {
    PageLoad,                 // Variant without payload
    KeyPress(char),           // Tuple struct variant
    Click { x: i64, y: i64 }, // Full struct variant
}

#[rustfmt::skip]
fn inspect(event: WebEvent) {
    match event {
        WebEvent::PageLoad       => println!("page loaded"),
        WebEvent::KeyPress(c)    => println!("pressed '{c}'"),
        WebEvent::Click { x, y } => println!("clicked at x={x}, y={y}"),
    }
}

// So we can get the size of the Foo
macro_rules! dbg_size {
    ($t:ty) => {
        println!(
            "{}: size {} bytes, align: {} bytes",
            stringify!($t),
            size_of::<$t>(),
            align_of::<$t>()
        );
    };
}

#[allow(dead_code)]
enum Foo {
    A,
    B,
}

#[allow(dead_code)]
#[derive(Debug)]
struct Person {
    name: String,
    age: u8,
}

impl Person {
    /*  The &self below indicates that the method borrows the object immutably
        (the method cannot change the value).

        There are other possible receivers for a method:

        - No receiver
          this becomes a static method on the struct.
          Typically used to create constructors which are called new by convention.
        - self
          takes ownership of the object and moves it away from the caller.
          The method becomes the owner of the object.
          The object is dropped (deallocated) when the method returns,
          unless its ownership is explicitly transmitted.
        - &self
          borrows the object from the caller using a shared and immutable reference.
          The object can be used again afterwards.
        - &mut self
          borrows the object from the caller using a unique and mutable reference.
          The object can be used again afterwards.

        Beyond variants on self, there are also special wrapper types allowed to be receiver types,
        such as Box<Self>.
    */
    fn say_hello(&self) {
        println!("Hello, my name is {}", self.name);
    }
}

enum Result {
    Ok(i32),
    Err(String),
}

// Returns a Result,
// which can be an Ok(VALUE)
// OR
// Err(ERROR-MESSAGE)
fn divide_in_two(n: i32) -> Result {
    if n % 2 == 0 {
        Result::Ok(n / 2)
    } else {
        Result::Err(format!("cannot divide {} into two equal parts", n))
    }
}

struct Foo2 {
    x: (u32, u32),
    y: u32,
}

fn main() {
    println!("You got: {:?}", flip_coin()); // Prints: "You got: Heads"
    println!();

    let load = WebEvent::PageLoad;
    let press = WebEvent::KeyPress('x');
    let click = WebEvent::Click { x: 20, y: 80 };

    inspect(load);
    inspect(press);
    inspect(click);
    println!();

    dbg_size!(Foo);
    println!();

    let peter = Person {
        name: String::from("Peter"),
        age: 27,
    };

    peter.say_hello(); // Prints: "Hello, my name is Peter"
    println!();

    let n = 100;
    // Since a Result is Ok or Err,
    // we match for those two cases.
    match divide_in_two(n) {
        Result::Ok(half) => println!("{n} divided by two is {half}"), // Prints: "100 divided by two is 50"
        Result::Err(msg) => println!("sorry, an error happened: {msg}"), // Could this be: _ => ...???
    }

    println!();

    // You can also destructure structs:
    let foo = Foo2 { x: (1, 2), y: 3 };
    match foo {
        Foo2 { x: (1, b), y } => println!("x.0 = 1, b = {b}, y = {y}"), // Prints: "x.0 = 1, b = 2, y = 3"
        Foo2 { y: 2, x: i } => println!("y = 2, i = {i:?}"),
        Foo2 { y, .. } => println!("y = {y}, other fields were ignored"),
    }

    println!();

    // Desctruct by matching elements
    let triple = [0, -2, 3];
    println!("Tell me about {triple:?}"); // Prints: "Tell me about [0, -2, 3]"
    match triple {
        [0, y, z] => println!("First is 0, y = {y}, and z = {z}"), // Prints: First is 0, y = -2, and z = 3"
        [1, ..] => println!("First is 1 and the rest were ignored"),
        _ => println!("All elements were ignored"),
    }

    println!();

    // Guard (apply condition to) an expression:
    let pair = (2, -2);
    println!("Tell me about {pair:?}"); // Prints: "Tell me about (2, -2)"
    match pair {
        (x, y) if x == y => println!("These are twins"),
        (x, y) if x + y == 0 => println!("Antimatter, kaboom!"), // Prints: "Antimatter, kaboom!"
        (x, _) if x % 2 == 1 => println!("The first one is odd"),
        _ => println!("No correlation..."),
    }
}
