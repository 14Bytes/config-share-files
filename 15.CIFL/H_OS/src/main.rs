#![no_std]
#![no_main]

//! 类型为 PanicInfo 的参数包含了 Panic 发生的文件名、代码行数和可选的错误信息。
//! 这个函数从不返回，所以他被标记为发散函数（diverging function），
//! 发散函数的返回类型称为 Never 类型（Never Type），记为 `!`
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop{}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    loop{}
}
