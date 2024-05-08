
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
      "can_create_crm_leads": false,
      "can_delete_crm_leads": false,
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
  // TODO: Implementar la lógica para manejar las actualizaciones de configuración
  }

  bool get canCreateCrmLeads => remoteConfig.getBool('can_create_crm_leads');
  bool get canDeleteCrmLeads => remoteConfig.getBool('can_delete_crm_leads');
  int get crmLeadsLimit => remoteConfig.getInt('crm_leads_limit');
}
