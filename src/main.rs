#[macro_use]
extern crate rocket;
use std::process::Command;

#[get("/")]
fn index() -> String {
    let output = Command::new("systemctl")
        .args(["is-active", "wg-quick@wg0"])
        .output()
        .expect("Failed")
        .stdout;

    return String::from_utf8(output).expect("Bad string");
}

#[launch]
fn rocket() -> _ {
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
