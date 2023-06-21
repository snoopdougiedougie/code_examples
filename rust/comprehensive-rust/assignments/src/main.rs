struct Rectangle {
    width: u32,
    height: u32,
}

// Methods are functions associated with a type.
// In this case area is a function within the struct Rectangle
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn inc_width(&mut self, delta: u32) {
        self.width += delta;
    }
}

// Function parameters can be generic:
fn pick_one<T>(a: T, b: T) -> T {
    if std::process::id() % 2 == 0 {
        a
    } else {
        b
    }
}

fn multiply(x: i16, y: i16) -> i16 {
    x * y
}

fn main() {
    // Array assignment and access:
    // Create a 10 element integer array and give each element the value 42
    let mut a: [i8; 10] = [42; 10];
    a[5] = 0; // Now give the fifth element the value 5
    println!("a: {:?}", a); // Prints: a: [42, 42, 42, 42, 42, 0, 42, 42, 42, 42]

    // Tuple assignment and access:
    // Create tuple with initial values: 7, true
    let t: (i8, bool) = (7, true);
    println!("1st index: {}", t.0); // Prints: 1st index: 7
    println!("2nd index: {}", t.1); // Prints: 2nd index: true

    // References
    // Create a mutable integer and give it the value 10
    let mut x: i32 = 10;
    // Create a reference to x
    let ref_x: &mut i32 = &mut x;
    // Set the reference (and x) to 20
    *ref_x = 20;
    println!("x: {x}"); // Prints: x: 20

    /*
    let ref_y: &i32;
    {
        let y: i32 = 10;
        ref_y = &y;
    }
    println!("ref_y: {ref_y}"); // 'y' does not live long enough
    */

    let ref_y: &i32;

    let y: i32 = 10;
    ref_y = &y;

    println!("ref_y: {ref_y}"); // Prints: "ref_y: 10" as y is now in scope.

    // Slices
    let a: [i32; 6] = [10, 20, 30, 40, 50, 60]; // Index is 0 to n-1, so a[0] to a[5]
    println!("a: {a:?}"); // Prints: "a: [10, 20, 30, 40, 50, 60]"

    let s: &[i32] = &a[2..4];
    println!("s: {s:?}"); // Prints: "s: [30, 40]" (starts with a[2] and ends with entry BEFORE a[4])

    // String vs str
    // &str (string slice) variables are not mutable
    let s1: &str = "Hello";
    println!("s1: '{s1}'"); // Prints: "s1: 'Hello'"

    // String (string buffer) variables are mutable, with mut keyword
    let mut s2: String = String::from("Hello ");
    println!("s2: '{s2}'"); // Prints: "s2: 'Hello '"
    s2.push_str(s1);
    println!("s2: '{s2}'"); // Prints: "s2: 'Hello Hello"

    fizzbuzz_to(20); // Defined below, no forward declaration needed

    let mut rect = Rectangle {
        width: 10,
        height: 5,
    };
    println!("old area: {}", rect.area()); // Prints: "old area: 50"
    rect.inc_width(5);
    println!("new area: {}", rect.area()); // Prints: "new area: 75"

    // pick_one selects the first arg if the proc ID is even, otherwise the second
    println!("coin toss: {}", pick_one("heads", "tails"));
    println!("cash prize: {}", pick_one(500, 1000));

    let x: i8 = 15;
    let y: i16 = 1000;

    // println!("{x} * {y} = {}", multiply(x, y)); // x isn't and i16w
    let x: i8 = 15;
    let y: i16 = 1000;

    println!("{x} * {y} = {}", multiply(x.into(), y)); // Prints: "15 * 1000 = 15000"
}

fn is_divisible_by(lhs: u32, rhs: u32) -> bool {
    if rhs == 0 {
        return false; // Corner case, early return
    }
    lhs % rhs == 0 // The last expression is the return value
}

fn fizzbuzz(n: u32) -> () {
    // No return value means returning the unit type `()`
    match (is_divisible_by(n, 3), is_divisible_by(n, 5)) {
        (true, true) => println!("fizzbuzz"),
        (true, false) => println!("fizz"),
        (false, true) => println!("buzz"),
        (false, false) => println!("{n}"),
    }
}

fn fizzbuzz_to(n: u32) {
    // `-> ()` is normally omitted
    for n in 1..=n {
        fizzbuzz(n);
    }
}
