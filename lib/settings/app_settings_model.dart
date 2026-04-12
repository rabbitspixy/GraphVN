import 'package:dart_mappable/dart_mappable.dart';

part './generated/app_settings_model.mapper.dart';

@MappableClass()
class AppSettingsModel with AppSettingsModelMappable {
  String? lastOpenedProjectDir;

  AppSettingsModel();

  @MappableConstructor()
  AppSettingsModel.mappableConstructor({
    required this.lastOpenedProjectDir,
  });
}