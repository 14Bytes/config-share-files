//! 二分查找
//! 递归方式查找
fn binary_search_recursive<T: PartialEq + PartialOrd>(nums: &[T], num: T) -> bool {
    if nums.len() == 0 {
        return  false;
    }

    let mid = nums.len() >> 1;
    return if num == nums[mid] {
        true
    } else if num < nums[mid] {
        binary_search_recursive(&nums[..mid], num)
    } else {
        binary_search_recursive(&nums[mid..], num)
    }
}

// 二分查找有序数组
fn binary_search<T: PartialEq + PartialOrd>(nums: &[T], num: T) -> bool {
    let mut found = false;
    let mut low = 0;
    let mut high = nums.len() - 1;
    while low <= high && !found {
        let mid = (low + high) >> 1;
        if num == nums[mid] {
            found = true;
            break;
        } else if num < nums[mid] {
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    found
}

fn main() {
    println!("Hello, world!");
}
