use std::collections::HashMap;
use std::rc::Rc;

// Recursive data type (linked list)
#[derive(Debug)]
enum List<T> {
    Cons(T, Box<List<T>>),
    Nil,
}

mod foo {
    pub fn do_something() {
        println!("In the foo module");
    }
}

mod bar {
    pub fn do_something() {
        println!("In the bar module");
    }
}

mod outer {
    fn private() {
        println!("outer::private");
    }

    pub fn public() {
        println!("outer::public");
    }

    mod inner {
        fn private() {
            println!("outer::inner::private");
        }

        pub fn public() {
            println!("outer::inner::public");
            super::private();
        }
    }
}

fn main() {
    // String operations
    let mut s1 = String::new();
    s1.push_str("Hello");

    // Prints: "s1: len = 5, capacity = 8"
    println!("s1: len = {}, capacity = {}", s1.len(), s1.capacity());

    let mut s2 = String::with_capacity(s1.len() + 1);
    s2.push_str(&s1);
    s2.push('!'); // s2 == "Hello!"

    // Prints: "s2: len = 6, capacity = 6"
    println!("s2: len = {}, capacity = {}", s2.len(), s2.capacity());

    println!();

    // Option and Result
    let numbers = vec![10, 20, 30];
    // Vector method first() returns the first item in a vector, as an Option<&T> (option of pointer to type T)
    // Remember an Option is either a Some(<T>) or None.
    let first: Option<&i8> = numbers.first();
    println!("first: {first:?}"); // Prints: "first: Some(10)"

    // Vector method binary_search(<&T>) returns Ok(<I>), where I is the index of the value in the vector, if found.
    // If not found, returns Err<msg>.
    let idx: Result<usize, usize> = numbers.binary_search(&10);
    println!("idx: {idx:?}"); // Prints: "idx: Ok(0)" as 10 is the first (0th) item in the vector.

    let idx2: Result<usize, usize> = numbers.binary_search(&1);
    println!("idx2: {idx2:?}"); // Prints: "idx2: Err(0)" as 1 is not in the vector.

    println!();

    // Vec(tor) is the standard, resizable, heap-allocated buffer:
    let mut v1 = Vec::new();
    v1.push(42); // v1 == [42]

    // Prints: "v1: len = 1, capacity = 4"
    println!("v1: len = {}, capacity = {}", v1.len(), v1.capacity());

    let mut v2 = Vec::with_capacity(v1.len() + 1); // v2.capacity == 2
    v2.extend(v1.iter()); // v2 == [42]
    v2.push(9999); // v2 == [42, 9999]

    // Prints: "v2: len = 2, capacity = 2"
    println!("v2: len = {}, capacity = {}", v2.len(), v2.capacity());

    // Adding to v2 increases it's length and capacity
    v2.push(666);
    // Prints: "v2: len = 3, capacity = 4"
    println!("v2: len = {}, capacity = {}", v2.len(), v2.capacity());

    println!();

    // HashMap
    let mut page_counts = HashMap::new();
    page_counts.insert("Adventures of Huckleberry Finn".to_string(), 207);
    page_counts.insert("Grimms' Fairy Tales".to_string(), 751);
    page_counts.insert("Pride and Prejudice".to_string(), 303);

    if !page_counts.contains_key("Les Misérables") {
        // Prints: " 3"
        println!(
            "We've know about {} books, but not Les Misérables.",
            page_counts.len()
        );
    }

    for book in ["Pride and Prejudice", "Alice's Adventure in Wonderland"] {
        match page_counts.get(book) {
            Some(count) => println!("{book}: {count} pages"), // Prints: "Pride and Prejudice: 303 pages"
            None => println!("{book} is unknown."), // Prints: " Alice's Adventure in Wonderland is unknown."
        }
    }

    println!();

    // Box is an owned pointer to data on the heap:
    let five = Box::new(5);
    println!("five: {}", *five); // Prints: "five: 5"

    println!();

    // Recursive data types or data types with dynamic sizes need to use a Box:
    let list: List<i32> = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
    println!("{list:?}"); // Prints: "Cons(1, Cons(2, Nil))"

    println!();

    // Rc is a reference-counted shared pointer.
    // Use to refer to the same data from multiple places:
    let a = Rc::new(10);
    let b = a.clone();

    println!("a: {a}"); // Prints: "a: 0"
    println!("b: {b}"); // Prints: "b: 10"

    println!();

    // Modules let us namespace types and functions:
    foo::do_something(); // Prints: "In the foo module"
    bar::do_something(); // Prints: "In the bar module"

    println!();

    // Module are a privacy boundary:

    // - Module items are private by default (hides implementation details).
    // - Parent and sibling items are always visible.
    outer::public(); // Prints: "outer::public"

    /* You can also refer to a module by path:

       - As a relative path:
         - foo or self::foo refers to foo in the current module
         - super::foo refers to foo in the parent module

       - As an absolute path:
         - crate::foo refers to foo in the root of the current crate
         - bar::foo refers to foo in the bar crate

       You can also find the code for a module in the filesystem.
       For example:

       mod garden;

       The garden module content is found at:

       - src/garden.rs (modern Rust 2018 style)
       - src/garden/mod.rs (older Rust 2015 style)

       Similarly, a garden::vegetables module can be found at:

       - src/garden/vegetables.rs (modern Rust 2018 style)
       - src/garden/vegetables/mod.rs (older Rust 2015 style)

       The crate root is in:

       - src/lib.rs (for a library crate)
       - src/main.rs (for a binary crate)
    */
}
