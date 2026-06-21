/// Фильтрует [map] по списку ключей [keys].
///
/// Возвращает новый Map, содержащий только те ключи из [keys],
/// которые присутствуют в [map]. Значения берутся из [map].
/// Если ключа из [keys] нет в [map], значение будет пустой строкой.
Map<String, String> filterMapByKeys(
  Map<String, String> map,
  List<String> keys,
) {
  return {
    for (var key in keys)
      key: map[key] ?? '',
  };
}
