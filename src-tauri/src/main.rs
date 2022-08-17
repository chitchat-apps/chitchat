#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use std::collections::HashMap;

use tauri::Manager;
use url::Url;

const CLIENT_ID: &str = "wef2n99fmkbuzr08m7ivd2r2tgboom";
const SCOPES: &str = "bits:read channel:read:subscriptions user:edit:follows user:read:broadcast user:read:email channel:moderate chat:edit chat:read whispers:read whispers:edit";

#[tauri::command]
fn get_client_id() -> &'static str {
    CLIENT_ID
}

#[tauri::command]
async fn request_login(handle: tauri::AppHandle) {
    let window = match handle.get_window("twitch_login") {
        Some(window) => window,
        None => return,
    };

    window.show().expect("window not found");
    window.eval(format!("window.location.replace('https://id.twitch.tv/oauth2/authorize?redirect_uri=http://localhost:5173/token&client_id={}&response_type=token&scope={}&force_verify=true')", CLIENT_ID, SCOPES).as_str()).expect("eval failed");
}

#[tauri::command]
fn debug(str: String) {
    println!("{}", str);
}

fn get_token(url: &str) -> String {
    let query_url = url.replace("#", "?");
    let parsed_url = Url::parse(query_url.as_str()).expect("url parse failed");
    let hash_query: HashMap<_, _> = parsed_url.query_pairs().into_owned().collect();
    let token = match hash_query.get("access_token") {
        Some(token) => token.to_string(),
        None => return String::new(),
    };

    token.to_string()
}

fn on_page_load(window: tauri::Window, payload: tauri::PageLoadPayload) {
    let token = get_token(payload.url());

    if window.label() == "twitch_login" {
        window
            .eval("window.location.replace('about:blank')")
            .expect("eval failed");
        window.hide().expect("window not found");
    }

    println!("{}", token);

    if !token.is_empty() {
        let main_window = match window.get_window("main") {
            Some(window) => window,
            None => return,
        };
        main_window.emit("token", token).unwrap();
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            debug,
            get_client_id,
            request_login,
        ])
        .on_page_load(on_page_load)
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
