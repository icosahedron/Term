

use std::cmp;
use std::default::Default;
use std::mem;

// pub struct DeleteEvent {
//     index: usize,
//     amount: usize
// }

// pub struct InsertEvent {
//     index: usize,
//     amount: usize
// }

#[readonly::make]
pub struct CircularList<T> where T : Default {
    array: Vec<T>,
    start_index: usize,
    pub length: usize,
    // delete_emitter : EventEmitter<DeleteEvent>,
    // insert_emitter : EventEmitter<InsertEvent>,
    // trim_emitter : EventEmitter<usize>
}

impl<T> Default for CircularList<T> where T : Default {
    fn default() -> Self {
        CircularList { 
            array: Vec::new(), 
            start_index: 0,
            length : 0,
            // delete_emitter: EventEmitter::new(), 
            // insert_emitter: EventEmitter::new(), 
            // trim_emitter: EventEmitter::new() 
        }
    }
}

impl<T> CircularList<T> where T : Default {

    pub fn with_capacity(capacity: usize) -> Self {
        CircularList { array: Vec::with_capacity(capacity), .. CircularList::default()}
    }

    pub fn push(&mut self, value: T) {
        // { array is valid, length < capacity,  }
        if self.array.len() < self.array.capacity() {
            self.array.push(value);
            self.length += 1;
            return;
        }
        let cind = self.get_cyclic_index(self.length);
        self.array[cind] = value;
        if self.length == self.array.capacity() {
            self.start_index = (self.start_index + 1) % self.array.capacity();            
        }
        else {
            self.length += 1;
        }
    }

    pub fn pop(&mut self) -> Result<T, String> {
        if self.length == 0 {
            return Err("Tried to pop from an empty CircularList".to_string());
        }
        let pop = self.swap(self.length - 1, T::default()).unwrap();
        self.length -= 1;
        Ok(pop)
    }

    pub fn adjust_capacity(&mut self, new_len: usize) {

        if new_len == self.array.capacity() {
            return;
        }

        let mut new_array : Vec<T> = Vec::with_capacity(new_len);
        let swap_len = cmp::min(self.length, new_len);
        for i in 0..swap_len {
            new_array.push(self.swap(i, T::default()).unwrap());
        }
        self.array = new_array;
        self.start_index = 0;
        self.length = swap_len;
    }

    pub fn get(&mut self, index: usize) -> Result<&T, String> {
        self.check_index(index)?;
        let cind = self.get_cyclic_index(index);
        Ok(&self.array[cind])
    }

    // use this instead of set since Rust can't just pull something out of Vec, so we 
    // swap instead, and since we have it, we return it.
    pub fn swap(&mut self, index: usize, mut value: T) -> Result<T, String> {
        self.check_index(index)?;
        let cind = self.get_cyclic_index(index);
        mem::swap(&mut value, &mut self.array[cind]);
        Ok(value)
    }

    pub fn splice(&mut self, start: usize, delete_count: usize, to_insert: &mut [T]) -> Result<(), String>{
        self.check_index(start)?;
        self.check_index(start + delete_count)?;
        // { start < length; start + delete_count < length }
        let new_capacity = self.array.capacity() - delete_count + to_insert.len();
        self.length = self.array.len() - delete_count + to_insert.len();
        let mut new_array = Vec::with_capacity(new_capacity);
        // copy over the first portion we wish to keep
        for i in 0..start {
            new_array.push(mem::replace(&mut self.array[i], T::default()));
        }
        // insert the new portion
        for i in to_insert {
            new_array.push(mem::replace(i, T::default()));
        }
        // copy over the remaining portion
        for i in start + delete_count..self.array.len() {
            new_array.push(mem::replace(&mut self.array[i], T::default()));
        }
        self.array = new_array;
        self.start_index = 0;
        Ok(())
    }

  /**
   * Gets the cyclic index for the specified regular index. The cyclic index can then be used on the
   * backing array to get the element associated with the regular index.
   * @param index The regular index.
   * @returns The cyclic index.
   */
    fn get_cyclic_index(&self, index: usize) -> usize {
        (self.start_index + index) % self.array.capacity()
    }

    fn check_index(&self, index: usize) -> Result<(), String> {
        if index >= self.length {
            return Err(format!("out of bounds reference {} for CircularList of length {}", index, self.length));
        }
        Ok(())
    }
//     NOT USED BY THE BUFFER
//     recycle(&mut self) -> T;
//     trimStart(count: number): void;
//     NOT used by the buffer
//     shiftElements(start: number, count: number, offset: number): void;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_cyclic_index() {
        let mut list : CircularList<u32> = CircularList::with_capacity(3);
        list.push(1);
        let cind = list.get_cyclic_index(0);
        assert_eq!(cind, 0);
        list.push(2);
        let cind = list.get_cyclic_index(1);
        assert_eq!(cind, 1);
        list.push(3);
        let cind = list.get_cyclic_index(2);
        assert_eq!(cind, 2);
        list.push(4);
        let cind = list.get_cyclic_index(2);
        assert_eq!(cind, 0);
        assert_eq!(list.length, 3);
        assert_eq!(list.start_index, 1);
    }

    #[test]
    fn test_empty_circular_list_with_capacity() {
        // { true }
        let list : CircularList<u32> = CircularList::with_capacity(5);
        let CircularList { array, .. } = list;
        // { push = 0, pop = 0, capacity = 5, array.capacity = 5 }
        assert_eq!(array.capacity(), 5); 
    }

    #[test]
    fn test_push() {
        // { true }
        let mut list : CircularList<u32> = CircularList::with_capacity(3);
        // { start_index = 0, length = 0, capacity = 3, array.capacity = 3 }
        list.push(5);
        list.push(3);
        list.push(1);
        // { start_index = 1, length = 1, capacity = 3, array.capacity = 3 }
        let CircularList { start_index, length, .. } = list;
        assert_eq!(start_index, 0);
        assert_eq!(length, 3);
        assert_eq!(*list.get(0).unwrap(), 5);
        assert_eq!(*list.get(1).unwrap(), 3);
        assert_eq!(*list.get(2).unwrap(), 1);
    }

    #[test]
    fn test_push_circle() {
        let mut list : CircularList<u32> = CircularList::with_capacity(2);
        list.push(1);
        list.push(2);
        assert_eq!(*list.get(0).unwrap(), 1);
        assert_eq!(*list.get(1).unwrap(), 2);
        assert_eq!(list.length, 2);
        assert_eq!(list.start_index, 0);
        list.push(3);
        assert_eq!(list.length, 2);
        assert_eq!(list.start_index, 1);
        assert_eq!(*list.get(0).unwrap(), 2);
        assert_eq!(*list.get(1).unwrap(), 3);
        list.push(4);
        assert_eq!(list.length, 2);
        assert_eq!(list.start_index, 0);
        assert_eq!(*list.get(0).unwrap(), 3);
        assert_eq!(*list.get(1).unwrap(), 4);
    }

    #[test]
    fn test_pop_circle() {
        let mut list : CircularList<u32> = CircularList::with_capacity(3);
        // length = 0, start_index = 0, array = {}
        list.push(1);
        // length = 1, start_index = 0, array = {1}
        list.push(2);
        // length = 2, start_index = 0, array = {1, 2}
        list.push(3);
        // length = 3, start_index = 0, array = {1, 2, 3}
        assert_eq!(list.length, 3);
        assert_eq!(list.start_index, 0);
        let pop = list.pop().unwrap();
        // length = 2, start_index = 0, array = {1, 2, 3}
        assert_eq!(pop, 3);
        assert_eq!(list.length, 2);
        assert_eq!(list.start_index, 0);
        list.push(3);
        // length = 3, start_index = 0, array = {1, 2, 3}
        assert_eq!(list.length, 3);
        list.push(4);
        // length = 3, start_index = 1, array = {4, 2, 3}
        println!("list.length = {}", list.length);
        assert_eq!(list.length, 3);
        assert_eq!(list.start_index, 1);
        let pop = list.pop().unwrap();
        // length = 2, start_index = 1, array = {4, 2, 3}
        assert_eq!(list.length, 2);
        assert_eq!(list.start_index, 1);
        assert_eq!(pop, 4);
        let pop = list.pop().unwrap();
        assert_eq!(pop, 3);
        let pop = list.pop().unwrap();
        assert_eq!(pop, 2);
        let pop = list.pop();
        assert_eq!(pop, Err("Tried to pop from an empty CircularList".to_string()));
    }

    #[test]
    fn test_adjust_capacity() {
        let mut list : CircularList<String> = CircularList::with_capacity(2);
        list.push("1".to_string());
        list.push("2".to_string());
        assert_eq!(list.get(0).unwrap(), "1");
        assert_eq!(list.get(1).unwrap(), "2");
        list.adjust_capacity(4);
        list.push("3".to_string());
        list.push("4".to_string());
        assert_eq!(list.get(0).unwrap(), "1");
        assert_eq!(list.get(1).unwrap(), "2");
        assert_eq!(list.get(2).unwrap(), "3");
        assert_eq!(list.get(3).unwrap(), "4");
    }

    #[test]
    fn test_current_length() {
        let mut list : CircularList<&str> = CircularList::with_capacity(2);
        assert_eq!(list.length, 0);
        list.push("1");
        assert_eq!(list.length, 1);
        list.push("2");
        assert_eq!(list.length, 2);
        list.push("3");
        assert_eq!(list.length, 2);
    }

    #[test]
    fn test_swap() {
        let mut list : CircularList<&str> = CircularList::with_capacity(3);
        list.push("1");
        list.push("2");
        list.push("3");
        let old = list.swap(1, "4").unwrap();
        assert_eq!(*(list.get(1).unwrap()), "4");
        assert_eq!(old, "2");
    }

    #[test]
    fn test_out_of_bounds() {
        let mut list : CircularList<u32> = CircularList::with_capacity(3);
        list.push(1);
        list.push(2);
        list.push(3);
        let stupid = list.get(3);
        assert_eq!(stupid, Err("out of bounds reference 3 for CircularList of length 3".to_string()));
    }

    #[test]
    fn test_pop_empty() {
        let mut list : CircularList<u32> = CircularList::with_capacity(3);
        let err = list.pop();
        assert_eq!(err, Err("Tried to pop from an empty CircularList".to_string()));
    }

    #[test]
    fn test_slice() {
        let mut list : CircularList<String> = CircularList::with_capacity(3);
        list.push("1".to_string());
        list.push("2".to_string());
        list.push("3".to_string());
        list.splice(1, 1, &mut ["4".to_string()]);
        assert_eq!(*(list.get(1).unwrap()), "4".to_string());
        let mut list : CircularList<String> = CircularList::with_capacity(3);
        list.push("1".to_string());
        list.push("2".to_string());
        list.push("3".to_string());
        list.splice(0, 1, &mut ["4".to_string()]);
        assert_eq!(*(list.get(0).unwrap()), "4".to_string());
        assert_eq!(*(list.get(1).unwrap()), "2".to_string());
        assert_eq!(*(list.get(2).unwrap()), "3".to_string());
        let mut list : CircularList<String> = CircularList::with_capacity(3);
        list.push("1".to_string());
        list.push("2".to_string());
        list.push("3".to_string());
        list.splice(2, 0, &mut ["4".to_string()]);
        assert_eq!(*(list.get(0).unwrap()), "1".to_string());
        assert_eq!(*(list.get(1).unwrap()), "2".to_string());
        assert_eq!(*(list.get(2).unwrap()), "4".to_string());
        assert_eq!(*(list.get(3).unwrap()), "3".to_string());
        let mut list : CircularList<String> = CircularList::with_capacity(3);
        list.push("1".to_string());
        list.push("2".to_string());
        list.push("3".to_string());
        list.splice(0, 0, &mut ["4".to_string()]);
        assert_eq!(*(list.get(0).unwrap()), "4".to_string());
        assert_eq!(*(list.get(1).unwrap()), "1".to_string());
        assert_eq!(*(list.get(2).unwrap()), "2".to_string());
        assert_eq!(*(list.get(3).unwrap()), "3".to_string());
    }
}
