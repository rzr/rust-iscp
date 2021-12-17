// Copyright: 2020+ Philippe Coval <https://purl.org/rzr>

use iscp::send;

mod thing;
use thing::*;

/// Example client
fn main() {
    use std::env;
    set_on(true);
    set_mute(true);
    set_level(42);
    set_input("Fm");
    set_mute(false);
}
