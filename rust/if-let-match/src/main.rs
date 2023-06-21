extern crate redis;
use redis::Commands;

fn fetch_an_integer() -> redis::RedisResult<isize> {
    // connect to redis
    let client = redis::Client::open("redis://127.0.0.1/")?;
    let mut con = client.get_connection()?;
    // throw away the result, just make sure it does not fail
    let _: () = con.set("my_key", 42)?;
    // read back the key and return it.  Because the return value
    // from the function is a result for integer this will automatically
    // convert into one.
    con.get("my_key")
}

fn main() {
    // Destructuring
    let (a, b) = (1, 2);
    dbg!(a, b);

    struct Thing(u32);
    let Thing(c) = Thing(5);
    dbg!(c);

    let forty_two = fetch_an_integer().unwrap_or(0);
    dbg!(forty_two);

    // connect to redis
    let client = redis::Client::open("redis://127.0.0.1/").unwrap();
    let mut con = client.get_connection().unwrap();

    let get_result = con.get("bob:mood");

    let mood = if let Ok(res) = get_result {
        println!("Got a value from redis");
        res
    } else {
        // error returned
        println!("Could not retrieve a value from redis");
        String::from("Neutral")
    };

    //dbg!(mood);

    // Map moods to an emoji
    // See https://unicode.org/emoji/charts/full-emoji-list.html
    let emoji = match mood.to_lowercase().as_str() {
        s if s.contains("crazy") => "\u{1F62C}",
        "happy" => "\u{1F642}",
        "very happy" => "\u{1F601}",
        _ => "\u{1F610}", // Neutral face
    };

    dbg!(emoji);
}
