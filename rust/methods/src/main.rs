#[derive(Debug)]
struct Race {
    name: String,
    laps: Vec<i32>,
}

impl Race {
    fn new(name: &str) -> Race {
        // No receiver, a static method
        Race {
            name: String::from(name),
            laps: Vec::new(),
        }
    }

    fn add_lap(&mut self, lap: i32) {
        // Exclusive borrowed read-write access to self
        self.laps.push(lap);
    }

    fn print_laps(&self) {
        // Shared and read-only borrowed access to self
        println!("Recorded {} laps for {}:", self.laps.len(), self.name);
        for (idx, lap) in self.laps.iter().enumerate() {
            let l = idx + 1;
            println!("Lap {l}: {lap} sec");
        }
    }

    fn finish(self) {
        // Exclusive ownership of self
        let total = self.laps.iter().sum::<i32>();
        println!("{} is finished:", self.name);
        println!("   {} laps in {} seconds.", self.laps.len(), total);
        // Note that integer division is a truncate, not a round.
        // So 1/3 -> 0; 2/3 -> 0; 3/3 -> 1.
        println!(
            "For an average lap time of {} seconds.",
            total / i32::try_from(self.laps.len()).unwrap()
        );
    }
}

fn main() {
    let mut race = Race::new("Monaco Grand Prix");
    race.add_lap(70);
    race.add_lap(68);
    race.print_laps();
    race.add_lap(71);
    race.print_laps();
    race.finish();
}
