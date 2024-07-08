//! 内插查找
//! 是二分查找的变体，使用线性内插法 (y - y0)/(x - x0) = (y1 - y0)/(x1 - x0)
//! 时间复杂度为 O(log log n)
//! 前提条件：数组已经排序完成

fn insert_search(nums: &[i32], target: i32) -> bool {
    if nums.is_empty() {
        return false;
    }

    let mut low = 0;
    let mut high = nums.len() - 1;

    // 一直循环找到上界
    loop {
        let low_val = nums[low];
        let high_val = nums[high];

        if high <= low || target < low_val || target > high_val {
            break;
        }

        // 插值位置
        let offset = (target - low_val) * (high - low) as i32 / (high_val - low_val);
        let insert_index = low + offset as usize;

        // 更新上下界
        if nums[insert_index as usize] > target {
            high = insert_index - 1;
        } else if nums[insert_index] < target {
            low = insert_index + 1;
        } else {
            high = insert_index;
            break;
        }
    }

    target == nums[high]
}

fn main() {
    println!("Hello, world!");
}
