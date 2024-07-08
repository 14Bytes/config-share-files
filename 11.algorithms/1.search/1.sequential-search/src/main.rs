//! 顺序查找
//! 时间复杂度 O(n)

fn sequential_search<T: PartialEq>(nums: &[T], num: T) -> bool {
    let mut found = false;
    let mut index = 0;
    while index < nums.len() {
        if num == nums[index] {
            found = true;
            break;
        }
        index += 1;
    }
    found
}

fn main() {
    println!("Hello, world!");
}
