import 'package:graph_vn/game/variables.dart';

class NamedValueTypeRepository {
  final List<NamedValuesType> _namedValueTypes = List.empty(growable: true);

  void add(NamedValuesType t) {
    if (_findByName(t.name) != null) {
      return;
    }
    _namedValueTypes.add(t);
  }

  void addAll(List<NamedValuesType> types) {
    for (final type in types) {
      add(type);
    }
  }

  void createEmpty(String name) {
    if (_findByName(name) != null) {
      return;
    }
    var newType = NamedValuesType();
    newType.name = name;
    _namedValueTypes.add(newType);
  }

  NamedValuesType? first() {
    return _namedValueTypes.firstOrNull;
  }

  List<NamedValuesType> all() {
    return _namedValueTypes.toList();
  }

  NamedValuesType? findById(String typeId) {
    return _namedValueTypes.where((t) => t.id == typeId).firstOrNull;
  }

  NamedValue? findValueById(String valueId) {
    return _namedValueTypes.expand((t) => t.values).where((v) => v.id == valueId).firstOrNull;
  }

  NamedValuesType? findTypeByValueId(String valueId) {
    return _namedValueTypes.where((t) => t.values.where((v) => v.id == valueId).isNotEmpty).firstOrNull;
  }

  NamedValuesType? _findByName(String name) {
    return _namedValueTypes.where((x) => x.name == name).firstOrNull;
  }
}