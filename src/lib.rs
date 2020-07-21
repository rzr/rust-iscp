// Copyright: 2020+ Philippe Coval <https://purl.org/rzr>

/// Send ISCP command (eg: PWR01)
pub fn send(cmd: &str) -> std::io::Result<()> {

    use std::io::prelude::*;
    use std::net::TcpStream;
    use std::env;
    println!("log: Sending: cmd: {:}", cmd);
    let host;
    match env::var("HOST") {
        Ok(val) => host = val,
        Err(_e) => host = "am335x-opt.local:60128".to_string(),
    }
    let header = "ISCP\x00\x00\x00\x10\x00\x00\x00";
    let message = format!("{}{}\x0d", "!1", cmd);
    let size = message.len() as u8;
    let payload = format!("{}{}\x01\x00\x00\x00{}", header, char::from(size), message);
    println!("log: Sending: bytes: {:02x?}", payload.as_bytes());
    

    println!("log: Connecting to {}", host);
    let mut stream = TcpStream::connect(host)?;
    stream.write(payload.as_bytes())?;
    Ok(())
}


