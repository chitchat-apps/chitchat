const fs = require("fs");
const path = require("path");

const version = require("../package.json").version;

const filePath = "src-tauri/target/release.json";

const signature = fs.readFileSync("chitchat.key.pub", "utf8");

const json = {
  version: version,
  notes: "Check the changelog on GitHub for more details.",
  pub_date: new Date(),
  platforms: {
    "darwin-x86_64": {
      signature,
      url: "https://github.com/chitchat-apps/chitchat/releases/latest/download/ChitChat-Mac-x86_64.app.tar.gz",
    },
    "darwin-aarch64": {
      signature,
      url: "https://github.com/chitchat-apps/chitchat/releases/latest/download/ChitChat-Mac-aarch64.app.tar.gz",
    },
    "windows-x86_64": {
      signature,
      url: "https://github.com/chitchat-apps/chitchat/releases/latest/download/https://github.com/chitchat-apps/chitchat/releases/latest/download/ChitChat-Setup-Windows.msi.zip",
    },
  },
};

const jsonString = JSON.stringify(json, null, 2);

fs.writeFileSync(filePath, jsonString);

console.log(`Generated '${filePath}' for version ${version}.`);
