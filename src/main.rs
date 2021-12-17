// Copyright: 2020+ Philippe Coval <https://purl.org/rzr>

use iscp::send;

mod thing;
use thing::*;

/// Example client
fn main() {
    use std::env;
    let mut args: Vec<String> = env::args().collect();
    println!("log: Usage: {} <ISCP message>", args[0]);
    args.remove(0);
    for argument in args {
        println!("log: {}", &argument);
        send(&argument).unwrap_or_else(|err| println!("{:?}", err));
    }
}
