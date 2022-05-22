#[macro_use]
extern crate rocket;
extern crate daemonize;
use daemonize::Daemonize;
use std::process::Command;

#[get("/")]
fn index() -> String {
    # TODO - Simple check to see if the servicice is active.
    # Could be expanded for more options
    let output = Command::new("systemctl")
        .args(["is-active", "wg-quick@wg0"])
        .output()
        .expect("Failed")
        .stdout;

    return String::from_utf8(output).expect("Bad string");
}

#[launch]
fn rocket() -> _ {
    # https://docs.rs/daemonize/latest/daemonize
    let daemonize = Daemonize::new()
        .pid_file("/var/run/wghrs.pid")
        .chown_pid_file(true)
        .working_directory("/")
        .user("nobody")
        .group("daemon")
        .umask(0o027)
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit());

    match daemonize.start() {
        Ok(_) => println!("Success, daemonized"),
        Err(e) => eprintln!("Error, {}", e),
    }

    rocket::build().mount("/", routes![index])
}

#[cfg(test)]
mod test {
    use super::Command;
    use super::rocket;
    use rocket::local::blocking::Client;
    use rocket::http::Status;

    #[test]
    fn is_active() {
        let output = Command::new("systemctl")
            .args(["is-active", "wg-quick@wg0"])
            .output()
            .expect("Failed")
            .stdout;

        let client = Client::tracked(rocket()).expect("valid rocket instance");
        let response = client.get(uri!(super::index)).dispatch();
        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.into_string().unwrap(), String::from_utf8(output).expect("Bad string"));
    }
}
