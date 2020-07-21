/// Copyright: 2020+ Philippe Coval <https://purl.org/rzr>


fn send(cmd: &str) -> std::io::Result<()> {

   use std::io::prelude::*;
   use std::net::TcpStream;

   let port = 60128;
   let hostname = "am335x-opt.local";
   let host = format!("{}:{}", hostname, port);
   let header = "ISCP\x00\x00\x00\x10\x00\x00\x00";
   let message = format!("{}{}\x0d", "!1", cmd);
   let size = message.len() as u8;
   let char = char::from(size);
   let payload = format!("{}{}\x01\x00\x00\x00{}", header, char, message);
   
   println!("log: Sending {:02x?}", payload.as_bytes());

   println!("log: Connecting to {}", host);
   let mut stream = TcpStream::connect(host)?;
       stream.write(payload.as_bytes())?;
       Ok(())
}

fn main() {
   use std::env;
   let mut args: Vec<String> = env::args().collect();
   args.remove(0);
   for argument in args {
       println!("log: {}", &argument);
       send(&argument).unwrap_or_else(|err| println!("{:?}", err));
   }
}
