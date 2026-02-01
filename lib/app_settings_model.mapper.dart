// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_settings_model.dart';

class AppSettingsModelMapper extends ClassMapperBase<AppSettingsModel> {
  AppSettingsModelMapper._();

  static AppSettingsModelMapper? _instance;
  static AppSettingsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppSettingsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppSettingsModel';

  static String? _$lastOpenedProjectDir(AppSettingsModel v) =>
      v.lastOpenedProjectDir;
  static const Field<AppSettingsModel, String> _f$lastOpenedProjectDir = Field(
    'lastOpenedProjectDir',
    _$lastOpenedProjectDir,
    opt: true,
  );

  @override
  final MappableFields<AppSettingsModel> fields = const {
    #lastOpenedProjectDir: _f$lastOpenedProjectDir,
  };

  static AppSettingsModel _instantiate(DecodingData data) {
    return AppSettingsModel(
      lastOpenedProjectDir: data.dec(_f$lastOpenedProjectDir),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppSettingsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppSettingsModel>(map);
  }

  static AppSettingsModel fromJson(String json) {
    return ensureInitialized().decodeJson<AppSettingsModel>(json);
  }
}

mixin AppSettingsModelMappable {
  String toJson() {
    return AppSettingsModelMapper.ensureInitialized()
        .encodeJson<AppSettingsModel>(this as AppSettingsModel);
  }

  Map<String, dynamic> toMap() {
    return AppSettingsModelMapper.ensureInitialized()
        .encodeMap<AppSettingsModel>(this as AppSettingsModel);
  }

  AppSettingsModelCopyWith<AppSettingsModel, AppSettingsModel, AppSettingsModel>
  get copyWith =>
      _AppSettingsModelCopyWithImpl<AppSettingsModel, AppSettingsModel>(
        this as AppSettingsModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppSettingsModelMapper.ensureInitialized().stringifyValue(
      this as AppSettingsModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppSettingsModelMapper.ensureInitialized().equalsValue(
      this as AppSettingsModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AppSettingsModelMapper.ensureInitialized().hashValue(
      this as AppSettingsModel,
    );
  }
}

extension AppSettingsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AppSettingsModel, $Out> {
  AppSettingsModelCopyWith<$R, AppSettingsModel, $Out>
  get $asAppSettingsModel =>
      $base.as((v, t, t2) => _AppSettingsModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppSettingsModelCopyWith<$R, $In extends AppSettingsModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? lastOpenedProjectDir});
  AppSettingsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AppSettingsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppSettingsModel, $Out>
    implements AppSettingsModelCopyWith<$R, AppSettingsModel, $Out> {
  _AppSettingsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppSettingsModel> $mapper =
      AppSettingsModelMapper.ensureInitialized();
  @override
  $R call({Object? lastOpenedProjectDir = $none}) => $apply(
    FieldCopyWithData({
      if (lastOpenedProjectDir != $none)
        #lastOpenedProjectDir: lastOpenedProjectDir,
    }),
  );
  @override
  AppSettingsModel $make(CopyWithData data) => AppSettingsModel(
    lastOpenedProjectDir: data.get(
      #lastOpenedProjectDir,
      or: $value.lastOpenedProjectDir,
    ),
  );

  @override
  AppSettingsModelCopyWith<$R2, AppSettingsModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppSettingsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

