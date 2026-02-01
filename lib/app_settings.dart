import 'dart:convert';
import 'dart:io';

import 'package:graph_vn/app_settings_model.dart';
import 'package:graph_vn/main.dart';

AppSettingsModel _appSettings = AppSettingsModel();

AppSettingsModel get appSettings => _appSettings;
set appSettings(AppSettingsModel x) {
  _appSettings = x;
}

final _settingsFile = File("./settings.json");

void loadAppSettings() {
  if (!_settingsFile.existsSync()) {
    return;
  }
  _appSettings = AppSettingsModelMapper.fromJson(_settingsFile.readAsStringSync());
}

void saveAppSettings() async {
  final json = const JsonEncoder.withIndent('  ').convert(_appSettings.toMap());
  AppSettingsModelMapper.fromJson(json); //just check
  _settingsFile.writeAsStringSync(json);
  logger.i('app settings saved');
}