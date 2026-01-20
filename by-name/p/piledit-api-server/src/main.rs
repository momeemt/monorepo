#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;
extern crate opencv;

use opencv::{
    core,
    highgui,
    imgproc,
    prelude::*,
    videoio,
};

#[get("/")]
fn index() -> &'static str {
    "Hello, Piledit!\n"
}

//#[get("/grayscale/<path>")]
//fn grayscale(path: String) {
//    let pictures_path = "/Users/momiyama/Pictures";
//    let be_copied_image_path = format!("{}/icon.png", pictures_path);
//    let new_image_path = format!("{}/{}.png", pictures_path, path);
//    let img = opencv::imgcodecs::imread(&be_copied_image_path, opencv::imgcodecs::IMREAD_UNCHANGED).unwrap();
//    let _ = opencv::imgcodecs::imwrite(&new_image_path, &img, &opencv::core::Vector::new());
//}

#[get("/grayscale/<origin_path>/<after_path>")]
fn grayscale(origin_path: String, after_path: String) {
    let origin_path = origin_path.replace(":", "/");
    let after_path = after_path.replace(":", "/");
    println!("{} {}", &origin_path, &after_path);
    let img = opencv::imgcodecs::imread(&origin_path, opencv::imgcodecs::IMREAD_UNCHANGED).unwrap();
    let mut dst = opencv::prelude::Mat::copy(&img).unwrap();
    let _ = opencv::imgproc::cvt_color(&img, &mut dst, opencv::imgproc::COLOR_BGR2GRAY, 0);
    let _ = opencv::imgcodecs::imwrite(&after_path, &dst, &opencv::core::Vector::new());
}

#[get("/json_parse")]
fn json_parse() -> &'static str {
    // jsonを受け取る / 処理
    "Json Parse"
}

fn main() {
    println!("Hello, world!");
    rocket::ignite().mount("/", routes![index, json_parse, grayscale]).launch();
}