// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'image_generator.dart';

class ImageGenerationSpecMapper extends ClassMapperBase<ImageGenerationSpec> {
  ImageGenerationSpecMapper._();

  static ImageGenerationSpecMapper? _instance;
  static ImageGenerationSpecMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ImageGenerationSpecMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ImageGenerationSpec';

  static String _$prompt(ImageGenerationSpec v) => v.prompt;
  static const Field<ImageGenerationSpec, String> _f$prompt = Field(
    'prompt',
    _$prompt,
  );
  static String _$outputFile(ImageGenerationSpec v) => v.outputFile;
  static const Field<ImageGenerationSpec, String> _f$outputFile = Field(
    'outputFile',
    _$outputFile,
  );

  @override
  final MappableFields<ImageGenerationSpec> fields = const {
    #prompt: _f$prompt,
    #outputFile: _f$outputFile,
  };

  static ImageGenerationSpec _instantiate(DecodingData data) {
    return ImageGenerationSpec(
      prompt: data.dec(_f$prompt),
      outputFile: data.dec(_f$outputFile),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ImageGenerationSpec fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ImageGenerationSpec>(map);
  }

  static ImageGenerationSpec fromJson(String json) {
    return ensureInitialized().decodeJson<ImageGenerationSpec>(json);
  }
}

mixin ImageGenerationSpecMappable {
  String toJson() {
    return ImageGenerationSpecMapper.ensureInitialized()
        .encodeJson<ImageGenerationSpec>(this as ImageGenerationSpec);
  }

  Map<String, dynamic> toMap() {
    return ImageGenerationSpecMapper.ensureInitialized()
        .encodeMap<ImageGenerationSpec>(this as ImageGenerationSpec);
  }

  ImageGenerationSpecCopyWith<
    ImageGenerationSpec,
    ImageGenerationSpec,
    ImageGenerationSpec
  >
  get copyWith =>
      _ImageGenerationSpecCopyWithImpl<
        ImageGenerationSpec,
        ImageGenerationSpec
      >(this as ImageGenerationSpec, $identity, $identity);
  @override
  String toString() {
    return ImageGenerationSpecMapper.ensureInitialized().stringifyValue(
      this as ImageGenerationSpec,
    );
  }

  @override
  bool operator ==(Object other) {
    return ImageGenerationSpecMapper.ensureInitialized().equalsValue(
      this as ImageGenerationSpec,
      other,
    );
  }

  @override
  int get hashCode {
    return ImageGenerationSpecMapper.ensureInitialized().hashValue(
      this as ImageGenerationSpec,
    );
  }
}

extension ImageGenerationSpecValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ImageGenerationSpec, $Out> {
  ImageGenerationSpecCopyWith<$R, ImageGenerationSpec, $Out>
  get $asImageGenerationSpec => $base.as(
    (v, t, t2) => _ImageGenerationSpecCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ImageGenerationSpecCopyWith<
  $R,
  $In extends ImageGenerationSpec,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? prompt, String? outputFile});
  ImageGenerationSpecCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ImageGenerationSpecCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ImageGenerationSpec, $Out>
    implements ImageGenerationSpecCopyWith<$R, ImageGenerationSpec, $Out> {
  _ImageGenerationSpecCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ImageGenerationSpec> $mapper =
      ImageGenerationSpecMapper.ensureInitialized();
  @override
  $R call({String? prompt, String? outputFile}) => $apply(
    FieldCopyWithData({
      if (prompt != null) #prompt: prompt,
      if (outputFile != null) #outputFile: outputFile,
    }),
  );
  @override
  ImageGenerationSpec $make(CopyWithData data) => ImageGenerationSpec(
    prompt: data.get(#prompt, or: $value.prompt),
    outputFile: data.get(#outputFile, or: $value.outputFile),
  );

  @override
  ImageGenerationSpecCopyWith<$R2, ImageGenerationSpec, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ImageGenerationSpecCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

