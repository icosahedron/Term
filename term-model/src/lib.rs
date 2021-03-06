use std::ffi::*;
use std::os::raw::*;

mod buffer;
mod term_log;

#[macro_use]
use log::*;
use crate::buffer::Buffer;

#[macro_use]
extern crate lazy_static;

static mut ALLOC_CALLBACK : Option<extern fn (u32) -> *mut u8> = None;
static mut FREE_CALLBACK : Option<extern fn (*mut u8)> = None;

struct Term {
    buffer: Buffer,
}

impl Term {
    fn new(width: u32, height: u32) -> Self {
        Term { buffer: Buffer::new(height, width) }
    }

    fn write(&self, buf: *const u8, len: u32) -> u32 {
        unsafe {
            let vbuf = Vec::from_raw_parts(buf as *mut u8, len as usize, len as usize);
            self.buffer.write(vbuf.as_slice())
        }
    }
}

#[no_mangle]
pub extern fn term_lib_init(allocfn: extern fn (c_uint) -> *mut u8,
                            freefn: extern fn (*mut u8),
                            logfn: Option<extern fn (*const c_char, u32)>) {
    unsafe {
        term_log::LOG_CALLBACK = logfn;
        ALLOC_CALLBACK = Some(allocfn);
        FREE_CALLBACK = Some(freefn);
    }
    term_log::init();
    info!("term_lib_init");
}

#[no_mangle]
pub extern fn term_new(width: u32, height: u32) -> usize {
    info!("term_new");
    Box::into_raw(Box::new(Term::new(width, height))) as usize
}

#[no_mangle]
pub extern fn term_drop(term: usize) {
    unsafe {
        let term = Box::from_raw(term as *mut Term);
        info!("term_drop");
//        let term = term as *mut Term;
        drop(term);
    }
}

// example of an external function to link against
//extern {
//    fn swift_func(num: i32) -> i32;
//}
// examples of functions to call from swift along with a callback to swift
//#[no_mangle]
//pub extern fn rust_hello(to: *const c_char, cb: extern fn (i32)) -> *mut c_char {
//    let c_str = unsafe { CStr::from_ptr(to) };
//    cb(34);
//    let recipient = match c_str.to_str() {
//        Err(_) => "there",
//        Ok(string) => string,
//    };
//    CString::new("Hello ".to_owned() + recipient).unwrap().into_raw()
//}
//
//#[no_mangle]
//pub extern fn rust_hello_free(s: *mut c_char) {
//    unsafe {
//        let i = swift_func(32);
//        if s.is_null() { return }
//        CString::from_raw(s)
//    };
//}
