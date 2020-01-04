use std::ffi::*;
use std::os::raw::*;

extern crate log;

use log::{Record, Level, Metadata};

pub static mut LOG_CALLBACK : Option<extern fn (*const c_char, u32)> = None;

struct SimpleLogger;

impl log::Log for SimpleLogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        metadata.level() <= Level::Info
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            unsafe {
                let msg = format!("{}:{}:{} - {}", record.file().unwrap(),
                                    record.line().unwrap(), record.level(), record.args());
                (LOG_CALLBACK.unwrap())(msg.as_ptr() as *const c_char, msg.len() as u32);
            }
        }
    }

    fn flush(&self) {}
}

use log::{SetLoggerError, LevelFilter};

static LOGGER: SimpleLogger = SimpleLogger;

pub fn init() -> Result<(), SetLoggerError> {
    log::set_logger(&LOGGER)
        .map(|()| log::set_max_level(LevelFilter::Debug))
}