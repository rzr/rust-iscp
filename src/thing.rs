// Copyright: 2020+ Philippe Coval <https://purl.org/rzr>

use iscp::send;

/// Switch on / off
pub fn set_on(value: bool) {
    let message = if value { "PWR01" } else { "PWR00" };
    send(message).unwrap_or_else(|err| println!("{:?}", err));
}

pub fn set_mute(value: bool) {
    let message = if value { "AMT01" } else { "AMT00" };
    send(message).unwrap_or_else(|err| println!("{:?}", err));
}

pub fn set_level(value: u8) {
    let message = format!("MLV{:02}", value);
    send(&message).unwrap_or_else(|err| println!("{:?}", err));
}

/// Select input (eg: "Net")
pub fn set_input(name: &str) {
    use std::collections::HashMap;
    let channels: HashMap<&str, &str> = [
        ("CblSat", "01"),
        ("Game", "02"),
        ("Aux", "03"),
        ("BdDvd", "10"),
        ("StrmBox", "11"),
        ("TV", "12"),
        ("Phono", "22"),
        ("Cd", "23"),
        ("Fm", "24"),
        ("Am", "25"),
        ("Tuner", "26"),
        ("Usb", "29"),
        ("Net", "2B"),
        ("UsbToggle", "2C"),
        ("BtAudio", "2E"),
        ("UsbToggle", "2C"),
        ("Hdmi5", "55"),
        ("Hdmi6", "56"),
        ("Hdmi7", "57"),
        ("Up", "UP"),
        ("Down", "DOWN"),     
    ].iter().cloned().collect();
    
    match channels.get(&name) {
        Some(&value) => {
            let message = format!("SLI{}", value);
            send(&message).unwrap_or_else(|err| println!("{:?}", err));
        }
        _ => println!("error: "),
    }
    

}
