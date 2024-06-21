use serde::Deserialize;

//! 校验 Deploy 部署用户的姓名和密码，以及部署的时间
#[derive(Deserialize)]
struct DeployParams {
    username: Option<String>,
    passwd: Option<String>,
}

//! 校验部署的项目名称，模块名称和需要执行的操作
struct ProgramParams {
    project_name: Option<String>,
    module_name: Option<String>,
    method_name: Option<String>,
}

async fn deploy() {
    println!("deploy")
}

async fn rollback() {
    println!("rollback")
}

#[tokio::main]
async fn main() {
    println!("Hello, World!")
}
