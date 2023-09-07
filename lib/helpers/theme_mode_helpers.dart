import "package:flutter/material.dart";

class ThemeModeHelpers {
  static String getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return "Automatic";
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      default:
        return "Unknown";
    }
  }
}
