
mod constants;
mod attribute_data;
mod circular_list;
mod event_emitter;

use circular_list::*;

pub struct Buffer {
    rows : CircularList<u32>,
}

impl Buffer {
    pub fn hello() -> String {
        println!("Hello from hello");
        String::from("Hello, stupid!")
    }
}
