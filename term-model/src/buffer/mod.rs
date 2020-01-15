
mod constants;
mod attribute_data;
mod circular_list;
mod event_emitter;

use circular_list::*;
use std::convert::TryFrom;

#[readonly::make]
pub struct Buffer {
    // temporarily a Vec<u8> until we get the BufferLine implemented
    rows : CircularList<Vec<u8>>,

    screen_width: usize,
    screen_height: usize,
    bottom: usize,
    x: usize,
    y: usize
}

/// Buffer handles the list of rows and placing text in the rows.
/// It provides read access to the contents by row for rendering.
/// This includes writing to the buffer and resizing the buffer, the cursor tracking,
/// scrolling, and almost everything except the state of the terminal and interpretation of
/// the control sequences.

impl Buffer {
    pub fn new(rows: u32, columns: u32) -> Self {
        Buffer {
            rows: CircularList::with_capacity(usize::try_from(rows).unwrap()),
            screen_width: usize::try_from(columns).unwrap(),
            screen_height: usize::try_from(rows).unwrap(),
            bottom: 0,
            x: 0,
            y: 0
        }
    }

    pub fn write(&self, text: &[u8]) -> u32 {

        let str_text = match str::from_utf8(text) {
            Ok(s) => s,
            Err => ""
        }
        for ch in str_text.chars() {
            if(self.x == 0) {
                
            }
        }
        u32::try_from(text.len()).unwrap()
    }

    pub fn row_at(&self, row: u32) -> &Vec<u8> {
        &self.rows[usize::try_from(row).unwrap()]
    }

    pub fn resize(rows: usize, columns: usize) {

    }
}

