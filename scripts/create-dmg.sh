#!/usr/bin/env bash

APP_VERSION="0.1.0"
APP_NAME="ChitChat"
DMG_FILE_NAME="${APP_NAME}-Installer-${APP_VERSION}.dmg"
VOLUME_NAME="${APP_NAME} v${APP_VERSION} Installer"
SOURCE_FOLDER_PATH="build/macos/Build/Products/Release"
DMG_SOURCE_FOLDER_PATH="${SOURCE_FOLDER_PATH}/out"
OUTPUT_PATH="build/macos/Build/Products/DMG"
CREATE_DMG=create-dmg

# Make a copy of the chitchat.app, rename it to the "APP_NAME" and then move it to the "DMG_SOURCE_FOLDER_PATH"
rm -rf "${DMG_SOURCE_FOLDER_PATH}"
mkdir -p "${DMG_SOURCE_FOLDER_PATH}"
cp -R "${SOURCE_FOLDER_PATH}/chitchat.app" "${DMG_SOURCE_FOLDER_PATH}/${APP_NAME}.app"

# Make sure the DMG directory exists
mkdir -p "${OUTPUT_PATH}"

# Since create-dmg does not clobber, be sure to delete previous DMG
[[ -f "${OUTPUT_PATH}/${DMG_FILE_NAME}" ]] && rm "${OUTPUT_PATH}/${DMG_FILE_NAME}"

# Create the DMG
$CREATE_DMG \
  --volname "${VOLUME_NAME}" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "${APP_NAME}.app" 200 190 \
  --hide-extension "${APP_NAME}.app" \
  --app-drop-link 600 185 \
  "${OUTPUT_PATH}/${DMG_FILE_NAME}" \
  "${DMG_SOURCE_FOLDER_PATH}"

# --background "installer_background.png" \
