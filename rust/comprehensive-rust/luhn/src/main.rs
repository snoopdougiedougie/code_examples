/*
   Luhn algorithm is used to validate credit card numbers.
   The algorithm takes a string as input and does the following to validate the credit card number:

   - Ignore all spaces. Reject number with less than two digits.

   - Moving from right to left, double every second digit: for the number 1234, we double 3 and 1.

   - After doubling a digit, sum the digits. So doubling 7 becomes 14 which becomes 5.

   - Sum all the undoubled and doubled digits.

   The credit card number is valid if the sum is ends with 0.
*/

fn get_digit_value(d: char) -> Result<i32, String> {
    match d {
        '0' => return Ok(0),
        '1' => return Ok(1),
        '2' => return Ok(2),
        '3' => return Ok(3),
        '4' => return Ok(4),
        '5' => return Ok(5),
        '6' => return Ok(6),
        '7' => return Ok(7),
        '8' => return Ok(8),
        '9' => return Ok(9),
        _ => return Err("Not a digit".to_string()),
    }
}

fn doubledigit(d: char) -> Result<char, String> {
    match d {
        '0' => return Ok('0'), // 0 * 2 == 0
        '1' => return Ok('2'), // 1 * 2 == 2
        '2' => return Ok('4'), // ...
        '3' => return Ok('6'),
        '4' => return Ok('8'),
        '5' => return Ok('1'), // 5 * 2 == 10 -> 1 + 0 == 1
        '6' => return Ok('3'), // 6 * 2 == 12 -> 1 + 2 == 3
        '7' => return Ok('5'), // ...
        '8' => return Ok('7'),
        '9' => return Ok('9'),
        _ => return Err("Not a digit".to_string()),
    }
}

pub fn luhn(cc_number: &str) -> bool {
    println!();
    println!("Original string: '{}'", cc_number);
    println!();
    // Remove anything that isn't a digit.
    let s: String = cc_number.chars().filter(|c| c.is_digit(10)).collect();

    println!("String of only digits: '{}'", s);
    println!();

    if s.len() < 2 {
        println!("TOO FEW DIGITS!!!");
        return false;
    }

    // Reverse the string
    let rev_chars = s.chars().rev().collect::<String>();

    let mut new_string = "".to_string();

    // Now iterate through it by every other char
    for (i, c) in rev_chars.chars().enumerate() {
        if i % 2 == 1 {
            println!("Doubling {}", c);
            new_string.push(doubledigit(c).unwrap());
        } else {
            new_string.push(c);
        }
    }

    // Now add up the digits
    let mut total: i32 = 0;
    for c in new_string.chars() {
        total += get_digit_value(c).unwrap();
    }

    // Convert total to a string,
    // and return whether the final character is a '0':
    let end_value = total.to_string();

    return end_value.chars().last().unwrap() == '0';
}

#[test]
fn test_non_digit_cc_number() {
    assert!(!luhn("foo"));
}

#[test]
fn test_empty_cc_number() {
    assert!(!luhn(""));
    assert!(!luhn(" "));
    assert!(!luhn("  "));
    assert!(!luhn("    "));
}

#[test]
fn test_single_digit_cc_number() {
    assert!(!luhn("0"));
}

#[test]
fn test_two_digit_cc_number() {
    let valid: bool = luhn(" 0 0 ");
    if valid {
        println!("' 0 0 ' is a Luhn number");
    } else {
        println!("' 0 0 ' is NOT a Luhn number");
    }

    //assert!(luhn(" 0 0 "));
    assert!(valid);
}

#[test]
fn test_valid_cc_number() {
    assert!(luhn("4263 9826 4026 9299"));
    assert!(luhn("4539 3195 0343 6467"));
    assert!(luhn("7992 7398 713"));
}

#[test]
fn test_invalid_cc_number() {
    assert!(!luhn("4223 9826 4026 9299"));
    assert!(!luhn("4539 3195 0343 6476"));
    assert!(!luhn("8273 1232 7352 0569"));
}

#[allow(dead_code)]
fn main() {
    // Prompt user for a card number and tell them if it's valid.
    let mut card_number = String::new();
    println!("Enter your card number:");

    std::io::stdin().read_line(&mut card_number).unwrap();
    println!("You entered: {}", card_number);

    // Chop off trailing \n:
    let len = card_number.len();
    card_number.truncate(len - 1);

    let cc_number = card_number.as_str();

    if luhn(cc_number) {
        println!("It's a valid number")
    } else {
        println!("It's NOT a valid number")
    }
}
