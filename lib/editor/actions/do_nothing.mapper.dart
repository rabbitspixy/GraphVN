// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'do_nothing.dart';

class DoNothingMapper extends SubClassMapperBase<DoNothing> {
  DoNothingMapper._();

  static DoNothingMapper? _instance;
  static DoNothingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DoNothingMapper._());
      BaseActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'DoNothing';

  static String _$id(DoNothing v) => v.id;
  static const Field<DoNothing, String> _f$id = Field('id', _$id);

  @override
  final MappableFields<DoNothing> fields = const {#id: _f$id};

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'DoNothing';
  @override
  late final ClassMapperBase superMapper = BaseActionMapper.ensureInitialized();

  static DoNothing _instantiate(DecodingData data) {
    return DoNothing.mappableConstructor(id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static DoNothing fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DoNothing>(map);
  }

  static DoNothing fromJson(String json) {
    return ensureInitialized().decodeJson<DoNothing>(json);
  }
}

mixin DoNothingMappable {
  String toJson() {
    return DoNothingMapper.ensureInitialized().encodeJson<DoNothing>(
      this as DoNothing,
    );
  }

  Map<String, dynamic> toMap() {
    return DoNothingMapper.ensureInitialized().encodeMap<DoNothing>(
      this as DoNothing,
    );
  }

  DoNothingCopyWith<DoNothing, DoNothing, DoNothing> get copyWith =>
      _DoNothingCopyWithImpl<DoNothing, DoNothing>(
        this as DoNothing,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DoNothingMapper.ensureInitialized().stringifyValue(
      this as DoNothing,
    );
  }

  @override
  bool operator ==(Object other) {
    return DoNothingMapper.ensureInitialized().equalsValue(
      this as DoNothing,
      other,
    );
  }

  @override
  int get hashCode {
    return DoNothingMapper.ensureInitialized().hashValue(this as DoNothing);
  }
}

extension DoNothingValueCopy<$R, $Out> on ObjectCopyWith<$R, DoNothing, $Out> {
  DoNothingCopyWith<$R, DoNothing, $Out> get $asDoNothing =>
      $base.as((v, t, t2) => _DoNothingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DoNothingCopyWith<$R, $In extends DoNothing, $Out>
    implements BaseActionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id});
  DoNothingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DoNothingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DoNothing, $Out>
    implements DoNothingCopyWith<$R, DoNothing, $Out> {
  _DoNothingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DoNothing> $mapper =
      DoNothingMapper.ensureInitialized();
  @override
  $R call({String? id}) => $apply(FieldCopyWithData({if (id != null) #id: id}));
  @override
  DoNothing $make(CopyWithData data) =>
      DoNothing.mappableConstructor(id: data.get(#id, or: $value.id));

  @override
  DoNothingCopyWith<$R2, DoNothing, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DoNothingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

