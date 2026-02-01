import 'package:dart_mappable/dart_mappable.dart';

part 'app_settings_model.mapper.dart';

@MappableClass()
class AppSettingsModel with AppSettingsModelMappable {
  String? lastOpenedProjectDir;

  AppSettingsModel({
    this.lastOpenedProjectDir,
  });
}