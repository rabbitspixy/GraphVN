// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'base.dart';

class BaseActionMapper extends ClassMapperBase<BaseAction> {
  BaseActionMapper._();

  static BaseActionMapper? _instance;
  static BaseActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BaseActionMapper._());
      DoNothingMapper.ensureInitialized();
      IncreaseNumberValueMapper.ensureInitialized();
      RotateNamedValueMapper.ensureInitialized();
      SetNamedValueMapper.ensureInitialized();
      SetNumberValueMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BaseAction';

  static String _$id(BaseAction v) => v.id;
  static const Field<BaseAction, String> _f$id = Field('id', _$id);

  @override
  final MappableFields<BaseAction> fields = const {#id: _f$id};

  static BaseAction _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'BaseAction',
      'subclass',
      '${data.value['subclass']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BaseAction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BaseAction>(map);
  }

  static BaseAction fromJson(String json) {
    return ensureInitialized().decodeJson<BaseAction>(json);
  }
}

mixin BaseActionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  BaseActionCopyWith<BaseAction, BaseAction, BaseAction> get copyWith;
}

abstract class BaseActionCopyWith<$R, $In extends BaseAction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id});
  BaseActionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

