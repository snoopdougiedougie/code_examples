fn main() {
    /*
    match std::env::args().next().as_deref() {
        Some("cat") => println!("Will do cat things"),
        Some("ls") => println!("Will ls some files"),
        Some("mv") => println!("Let's move some files"),
        Some("rm") => println!("Uh, dangerous!"),
        None => println!("Hmm, no program name?"),
        _ => println!("Unknown program name!"), // Always prints this!!!
    }
    */

    let args: Vec<String> = std::env::args().collect();

    for s in &args[1..] {
        match &s[..] {
            "cat" => println!("Will do cat things"),
            "ls" => println!("Will ls some files"),
            "mv" => println!("Let's move some files"),
            "rm" => println!("Uh, dangerous!"),
            _ => println!("Unknown program name!"),
        }
    }
}
