import 'package:flutter/material.dart';
import 'package:flutter_crm_prove/remote_config_service.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: RemoteConfigService.instance.primaryLightColor,
    background: RemoteConfigService.instance.backgroundLightColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: RemoteConfigService.instance.floatingButtonLightColor,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: RemoteConfigService.instance.primaryDarkColor,
    background: RemoteConfigService.instance.backgroundDarkColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: RemoteConfigService.instance.floatingButtonDarkColor,
  ),
);