import 'dart:convert';
import 'dart:io';

import 'package:graph_vn/app_settings_model.dart';
import 'package:graph_vn/editor/editor_constants.dart';
import 'package:graph_vn/main.dart';

AppSettingsModel _appSettings = _loadAppSettings();

AppSettingsModel get appSettings => _appSettings;
set appSettings(AppSettingsModel x) {
  _appSettings = x;
}

final _settingsFile = File("./${EditorConstants.projectsDir}/settings.json");

AppSettingsModel _loadAppSettings() {
  if (!_settingsFile.existsSync()) {
    logger.d("created new default config");
    return AppSettingsModel();
  }
  var result = AppSettingsModelMapper.fromJson(_settingsFile.readAsStringSync());
  logger.d("loaded config: $result");
  return result;
}

void saveAppSettings() async {
  final json = const JsonEncoder.withIndent('  ').convert(_appSettings.toMap());
  AppSettingsModelMapper.fromJson(json); //just check
  _settingsFile.writeAsStringSync(json);
  logger.i('app settings saved');
}