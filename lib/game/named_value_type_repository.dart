import 'package:graph_vn/game/variables.dart';

class NamedValueTypeRepository {
  final List<NamedValuesType> _namedValueTypes = List.empty(growable: true);

  void create(String name) {
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