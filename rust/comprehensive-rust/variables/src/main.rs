// Functions that display the arg type
fn takes_u32(x: u32) {
    println!("u32: {x}");
}

fn takes_i8(y: i8) {
    println!("i8: {y}");
}

// Constants
const DIGEST_SIZE: usize = 3;
const ZERO: Option<u8> = Some(42);

// Static (cannot be changed) string
static BANNER: &str = "Welcome to RustOS 3.14";

fn compute_digest(text: &str) -> [u8; DIGEST_SIZE] {
    let mut digest = [ZERO.unwrap_or(0); DIGEST_SIZE];
    for (idx, &b) in text.as_bytes().iter().enumerate() {
        digest[idx % DIGEST_SIZE] = digest[idx % DIGEST_SIZE].wrapping_add(b);
    }
    digest
}

fn say_hello(name: String) {
    println!("Hello {name}")
}

fn say_hello2(name: &String) {
    println!("Hello {}", &name)
}

fn add_schwartz(name: &mut String) {
    // No can do:
    // name = String::from("Hello, ");
    // Gives the error:
    // expected `&mut String`, found struct `String`
    name.push_str("Schwartz");
}

#[derive(Debug)]
struct Point(i32, i32);

// add takes references to Point objects and returns a new Point
fn add(p1: &Point, p2: &Point) -> Point {
    Point(p1.0 + p2.0, p1.1 + p2.1)
}

// By convention, we use 'a' as part of the borrowed type
// (like the 'T' in C++/Java)
fn left_most<'a>(p1: &'a Point, p2: &'a Point) -> &'a Point {
    if p1.0 < p2.0 {
        p1
    } else {
        p2
    }
}

// If a data type stores borrowed data, it must be annotated with a lifetime (&'doc):
#[derive(Debug)]
struct Highlight<'doc>(&'doc str);

/*
fn erase(text: String) {
    println!("Bye {text}!");
}
*/

fn main() {
    //
    let x = 10;
    let y = 20;

    takes_u32(x);
    takes_i8(y); // At this point, Rust has decided y is an i8
                 // takes_u32(y); // So this is a type error
    println!();

    let digest = compute_digest("Hello");
    println!("Digest: {digest:?}"); // Prints: "Digest: [222, 254, 150]"
    println!();

    println!("{}", BANNER); // Prints: "Welcome to RustOS 3.14"
    println!();

    // Shadowing
    let a = 10;
    println!("before: {a}"); // Prints: "before: 10"

    {
        let a = "hello";
        println!("inner scope: {a}"); // Prints: "inner scrope: hello"

        let a = true;
        println!("shadowed in inner scope: {a}"); // Prints: "shadowed in inner scope: true"
    }

    println!("after: {a}"); // Prints: "after: 10"
    println!();

    {
        let p = Point(3, 4);
        println!("x: {}", p.0);
    } // p dropped (freed) here
      // println!("y: {}", p.1); // Illegal as p is not available.
    println!();

    // Ownership transfer
    let s1: String = String::from("Hello!");
    let s2: String = s1; // s2 now owns the string (value/data moved from s1 to s2)
    println!("s2: {s2}"); // Prints: "Hello!"
                          // println!("s1: {s1}"); // s1 has no data. Error is "value borrowed here after move"
    println!();

    // Ownership transfer to function
    let name = String::from("Alice");
    say_hello(name); // name transferred (value moved) to say_hello here
                     // say_hello(name); // name no longer available; error is: value used here after move

    let name2 = String::from("Ted");
    say_hello(name2.clone());
    say_hello(name2.clone()); // You can repeat as many times as necessary.

    // Borrowing, which avoids clone()
    let name3 = String::from("Snoop");
    say_hello2(&name3);
    say_hello2(&name3); // Repeat as many times as necessary.
    println!();

    // Mutable borrow
    let mut name4 = String::from("Doug ");
    println!("Original name: {}", name4);
    add_schwartz(&mut name4);
    println!("With Schwartz: {}", name4); // hello add this to the end
    println!();

    let p1 = Point(3, 4);
    let p2 = Point(10, 20);
    let p3 = add(&p1, &p2);
    println!("{p1:?} + {p2:?} = {p3:?}"); // Prints: "Point(3, 4) + Point(10, 20) = Point(13, 24)""
    println!();

    // Shared and unique borrows
    // let mut a: i32 = 10; // mut not needed.
    let a: i32 = 10;
    let b: &i32 = &a; // immutable borrow;

    {
        //        let c: &mut i32 = &mut a; // illegal as mutable borrow
        // error is: cannot borrow `a` as mutable because it is also borrowed as immutable
        // *c = 20; // c does not exist
    }

    println!("a: {a}"); // Prints: "*a: 10"
    println!("b: {b}"); // Prints: "*b: 10"
    println!();

    // Explicit lifetime:
    // &'x Point
    // means: “x is a borrowed Point which is valid for at least the lifetime of x”.

    let p1: Point = Point(10, 10);
    let p2: Point = Point(20, 20); // Put into different scope
    let p3: &Point = left_most(&p1, &p2);
    println!("left-most point: {:?}", p3); // Prints: "left-most point: Point(10, 10)"
    println!();

    let text = String::from("The quick brown fox jumps over the lazy dog.");
    let fox = Highlight(&text[4..19]); // borrow of text here
    let dog = Highlight(&text[35..43]);
    // erase(text); // Error: move out of text occurs here
    println!("{fox:?}");
    println!("{dog:?}");
    println!();
}
