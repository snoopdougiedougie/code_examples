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
}
