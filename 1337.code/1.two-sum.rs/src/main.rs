//! 给定一个整数数组`nums`和一个整数目标值`target`，请你在该数组中找出 和为目标值`target`的那两个整数，并返回它们的数组下标。
//!
//! 你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。
//!
//! 你可以按任意顺序返回答案。
//!
//! 示例 1：
//!
//! 输入：nums = \[2,7,11,15\], target = 9
//! 输出：\[0,1\]
//! 解释：因为 nums\[0\] + nums\[1\] == 9 ，返回 \[0, 1\] 。
//!
//! 示例 2：
//!
//! 输入：nums = \[3,2,4\], target = 6
//! 输出：\[1,2\]
//!
//! 示例 3：
//!
//! 输入：nums = \[3,3\], target = 6
//! 输出：\[0,1\]
//!
//! 提示：
//!     2 <= nums.length <= 104
//!
//!     -109 <= nums\[i\] <= 109
//!
//!     -109 <= target <= 109
//!
//!     只会存在一个有效答案

// 哈希表
use std::collections::HashMap;

// 暴力解
struct Solution1;

impl Solution1 {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        for i in 0..nums.len() {
            for j in i+1..nums.len() {
                if nums[i] + nums[j] == target {
                    return vec![i as i32, j as i32];
                }
            }
        }
        unreachable!()
    }
}

// hash 表解决
struct Solution2;

impl Solution2 {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut map = HashMap::with_capacity(nums.len());

        for i in 0..nums.len() {
            if let Some(k) = map.get(&(target - nums[i])) {
                if *k != i {
                    return vec![*k as i32, i as i32];
                }
            }
            map.insert(nums[i], i);
        }
        panic!("not found")
    }
}

fn main() {
    let ans1 = Solution1::two_sum(vec![2,7,11,15], 9);
    println!("{:?}", ans1);

    let ans2 = Solution2::two_sum(vec![2,7,11,15], 9);
    println!("{:?}", ans2);
}
