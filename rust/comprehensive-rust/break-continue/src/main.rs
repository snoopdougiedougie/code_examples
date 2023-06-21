fn main() {
    let v = vec![10, 20, 30];
    let mut iter = v.into_iter();
    'outer: while let Some(x) = iter.next() {
        println!("x: {x}"); // Prints: "x: 10"
        let mut i = 0;
        while i < x {
            println!("x: {x}, i: {i}"); // Prints: "x: 10, i: 0" to "x: 10, i: 2" then breaks outer loop (ends)
            i += 1;
            if i == 3 {
                break 'outer;
            }
        }
    }
}
