

import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();
  static final instance = RemoteConfigService._();

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await setDefaults();
    await fetchAndActivate();

    handleConfigUpdates();
    
    setupConfigUpdateListener();
  }

  Future<void> setDefaults() async {
    await remoteConfig.setDefaults(const {
      "can_create_crm_leads": true,
      "can_delete_crm_leads": true,
      "crm_leads_limit": 10,
    });
  }

  Future<void> fetchAndActivate() async {
    await remoteConfig.fetchAndActivate();
  }

  void setupConfigUpdateListener() {
    remoteConfig.onConfigUpdated.listen((event) async {
      await fetchAndActivate();
      handleConfigUpdates();
    });
  }

  void handleConfigUpdates() {

  }

  Color rgbToColor(String code) {
    List<int> rgb = code.split(',').map((String value) => int.parse(value.trim())).toList();
    for (int i = 0; i < rgb.length; i++) {
      print(rgb[i]);
    }
    return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);
  }


  bool get canCreateCrmLeads => remoteConfig.getBool('can_create_crm_leads');
  bool get canDeleteCrmLeads => remoteConfig.getBool('can_delete_crm_leads');
  int get crmLeadsLimit => remoteConfig.getInt('crm_leads_limit');
  String get primaryLight => remoteConfig.getString('primary_light');
  String get primaryDark => remoteConfig.getString('primary_dark');
  String get backgroundLight => remoteConfig.getString('background_light');
  String get backgroundDark => remoteConfig.getString('background_dark');
  String get floatingButtonLight => remoteConfig.getString('floating_button_light');
  String get floatingButtonDark => remoteConfig.getString('floating_button_dark');

  Color get primaryLightColor => rgbToColor(primaryLight);
  Color get primaryDarkColor => rgbToColor(primaryDark);
  Color get backgroundLightColor => rgbToColor(backgroundLight);
  Color get backgroundDarkColor => rgbToColor(backgroundDark);
  Color get floatingButtonLightColor => rgbToColor(floatingButtonLight);
  Color get floatingButtonDarkColor => rgbToColor(floatingButtonDark);
}
