// use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};

use structopt::StructOpt;

// Run with:
//   cargo run -- -p[ath] TEXT-FILE.txt [-v]

#[derive(Debug, StructOpt)]
struct Opt {
    /// The path to the file to open
    #[structopt(short, long)]
    path: String,

    /// Whether to display additional information.
    #[structopt(short, long)]
    verbose: bool,
}

fn main() {
    let Opt { path, verbose } = Opt::from_args();

    if verbose {
        println!("Reading lines from {}", path);
        println!();
    }

    // let filename = env::args().nth(1).expect("Please provide a filename");

    // WAS: let file = File::open(&filename).unwrap();
    let file = File::open(&path).unwrap();
    let reader = BufReader::new(file);

    // Barf out each line of the file
    for line in reader.lines() {
        let line = line.unwrap();
        println!("{}", line);
    }
}
