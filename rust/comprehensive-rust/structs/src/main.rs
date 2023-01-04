use std::fmt;

// tuple struct (both of the same type)
struct Point(i32, i32);

// Single field wrappers (called newtypes)
struct PoundOfForce(f64);
impl fmt::Display for PoundOfForce {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}
impl PoundOfForce {
    pub fn to_newtons(&self) -> Newtons {
        Newtons(self.0 * 4.44822)
    }
}

struct Newtons(f64);
impl fmt::Display for Newtons {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

fn compute_thruster_force() -> PoundOfForce {
    PoundOfForce(1.23)
}

fn set_thruster_force(_force: &Newtons) {}

#[derive(Debug)]
struct Person {
    name: String,
    age: u8,
}

// Field shorthand
impl Person {
    fn new(name: String, age: u8) -> Person {
        Person { name, age } // Versus: Person {name: name, age: age}
    }
}

fn main() {
    let peter = Person {
        name: String::from("Peter"),
        age: 27,
    };

    println!("{} is {} years old", peter.name, peter.age); // Prints: "Peter is 27 years old"
    println!();

    let p = Point(17, 23);
    println!("({}, {})", p.0, p.1); // Prints: "(17, 23)"
    println!();

    let force = compute_thruster_force();
    println!("Force in pounds: {}", &force); // Prints: "Force in pounds: 1.23"
    let newtons = force.to_newtons();
    // set_thruster_force(force); // Even though both are i64, this is the wrong type.
    set_thruster_force(&newtons);
    println!("Force in Newtons: {}", &newtons); // Prints: "Force in Newtons: 5.4713106"
    println!();

    let peter = Person::new(String::from("Peter"), 27);
    println!("{peter:?}"); // Prints: "Person {name: "Peter", age: 27 }"
    println!();
}
