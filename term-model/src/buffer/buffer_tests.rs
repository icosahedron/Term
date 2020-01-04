
use super::*;

#[test]
fn it_works() {
    let hello = Buffer::hello();
    assert_eq!(hello, "Hello, stupid!");
}
