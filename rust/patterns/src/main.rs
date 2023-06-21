fn main() {
    let input = 'x';

    match input {
        'q' => println!("Quitting"),
        'a' | 's' | 'w' | 'd' => println!("Moving around"),
        '0'..='9' => println!("Number input"),
        _ => println!("Something else"),
    }
}
