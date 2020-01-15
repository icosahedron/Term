
use std::mem;

pub struct EventEmitter<'a, T: 'a> {
    listeners: Vec<Box<dyn FnMut(&'a T) -> Result<(), String> + 'a>>
}

impl<'a, T: 'a> EventEmitter<'a, T> {

    pub fn new() -> Self {
        EventEmitter { listeners: Vec::new() }
    }

    pub fn fire(&mut self, data: &'a T) -> Result<(), String> {
        for l in &mut self.listeners {
            l(data)?;
        }
        Ok(())
    }

    pub fn add(&mut self, listener: impl FnMut(&'a T) -> Result<(), String> + 'a) {
        self.listeners.push(Box::new(listener));
    }
}

impl<'a, T: 'a> Drop for EventEmitter<'a, T> {
    fn drop(&mut self) {
        for l in 0..self.listeners.len() {
            mem::drop(mem::replace(&mut self.listeners[l], Box::new(|_ : &T| -> Result<(), String> {Ok(())})));
        }
        // self.listeners.clear();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        let a = "a".to_string();
        let b = "b".to_string();
        let mut stupid = String::new();
        {
            let mut emitter : EventEmitter<String> = EventEmitter::new();
            let mut stupid_fn = |x : &String| -> Result<(), String> { &stupid.push_str(x.as_str()); Ok(()) };

            emitter.add(/*&mut*/ stupid_fn);
            emitter.fire(&a);
            emitter.fire(&b);
        }
        assert_eq!(stupid.as_str(), "ab");
    }
}