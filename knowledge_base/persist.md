# Хранение квеста через Protobuf

## Общая схема

Схема Protobuf описана в файле `data.proto` в корне проекта.
Сгенерированный Dart-код лежит в `lib/generated-proto/data.pb.dart` (gitignored).

Регенерация protobuf: `run.bat protoc`

## Список моделей с `toProto` / `fromProto`

| Модель (класс Dart) | Proto-сообщение | Файл |
|---|---|---|
| `ProjectData` | `ProjectProto` | `lib/game/project_data.dart` |
| `GameNode` | `GameNodeProto` | `lib/game/game_node.dart` |
| `GameTransition` | `GameTransitionProto` | `lib/game/game_transition.dart` |
| `Struct` | `StructProto` | `lib/game/struct.dart` |
| `NumberVariable` (`Variable`) | `NumberVariableProto` → `VariableProto` (oneof) | `lib/game/variables.dart` |
| `NamedVariable` (`Variable`) | `NamedVariableProto` → `VariableProto` (oneof) | `lib/game/variables.dart` |
| `NamedValuesType` | `NamedValueTypeProto` | `lib/game/variables.dart` |
| `NamedValue` | `NamedValueProto` | `lib/game/variables.dart` |
| `CodeRepository` | `CodeRepositoryProto` | `lib/game/code_repository.dart` |
| `GenerateImageMetadata` | `GenerateImageMetadataProto` | `lib/image_generation/generate_image_metadata.dart` |

## Процесс сохранения и загрузки

**Сохранение:** `GameState.save()` (`lib/game/game_state.dart:131`) → создаёт `ProjectData`, вызывает `.toProto()`, затем `projectDataProto.writeToBuffer()` и пишет бинарник в `./projects/{dir}/main.bin`.

**Загрузка:** `GameState._load()` (`lib/game/game_state.dart:74`) → читает `main.bin`, десериализует через `ProjectProto.fromBuffer()`, затем `ProjectData.fromProto(proto)`.

## Conventions

### 1. Именование proto-сообщений

Каждое сообщение в `data.proto` называется как Dart-класс + суффикс `Proto`.
Исключение — `VariableProto`, который использует `oneof` для полиморфизма.

### 2. Поля proto — snake_case

В `data.proto` поля пишутся в `snake_case`, Dart-генератор преобразует их в `camelCase`.
Если в Dart-классе поле называется `naturalLanguageTrigger`, то в proto оно должно быть `natural_language_trigger`.

### 3. `toProto` — метод экземпляра

```dart
GameNodeProto toProto() {
  final result = GameNodeProto();
  result.id = id;
  // ... все поля
  return result;
}
```

### 4. `fromProto` — factory-конструктор

```dart
factory GameNode.fromProto(GameNodeProto proto) {
  final result = GameNode();
  result.id = proto.id;
  // ... все поля
  return result;
}
```

Для неизменяемых классов (например, `NamedValue`) используется `return NamedValue(...)`:

```dart
factory NamedValue.fromProto(NamedValueProto proto) {
  return NamedValue(
    id: proto.id,
    name: proto.name,
    description: proto.description,
  );
}
```

### 5. Int64 для int в proto

В Dart `int` — 64-bit, но protobuf генерирует `Int64` для `int64` полей. При сериализации требуется обёртка:

```dart
result.x = Int64(x);       // toProto
result.x = proto.x.toInt(); // fromProto (в Gamenode, но в других местах просто proto.x)
```

Будьте внимательны: протобаф может сгенерировать `Int64` для `int64`, и нужно использовать `Int64(value)` при записи и `proto.x.toInt()` / `proto.x` при чтении.
Сейчас `Int64` используется только для полей `x`, `y` в `GameNodeProto`.

### 6. Полиморфизм через `oneof`

`Variable` — абстрактный класс с двумя наследниками. В `data.proto` используется `oneof type`:

```protobuf
message VariableProto {
  oneof type {
    NumberVariableProto numberVariable = 1;
    NamedVariableProto namedVariable = 2;
  }
}
```

Диспатчинг:

```dart
// toProto — каждый наследник создаёт свою конкретную proto и оборачивает в VariableProto
@override
VariableProto toProto() {
  final result = NumberVariableProto();
  // ... заполняем поля
  return VariableProto()..numberVariable = result;
}

// fromProto — фабрика в базовом классе использует switch
factory Variable.fromProto(VariableProto proto) {
  return switch (proto.whichType()) {
    VariableProto_Type.numberVariable => NumberVariable.fromProto(proto.numberVariable),
    VariableProto_Type.namedVariable => NamedVariable.fromProto(proto.namedVariable),
    VariableProto_Type.notSet => throw Exception("VariableProto type is not set"),
  };
}
```

### 7. Коллекции

Повторяющиеся (`repeated`) поля заполняются через `.addAll(...)`:

```dart
result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
```

Мапы (`map<string, string>`) — через `.addAll(...)`:

```dart
result.actions.addAll(actions);
```

### 8. Добавление нового поля в существующее сообщение

1. Добавить поле в `data.proto` под новым номером (не переиспользовать старые).
2. Запустить `run.bat protoc`.
3. Добавить новое поле в Dart-класс (если его нет).
4. Добавить строку в `toProto()`: `result.newField = newField;`.
5. Добавить строку в `fromProto()`: `result.newField = proto.newField;`.

Порядок полей в `toProto`/`fromProto` должен совпадать с порядком в proto-файле.

### 9. Добавление нового класса

1. Создать новое proto-сообщение в `data.proto`.
2. Если новый класс — часть иерархии (корневой объект `ProjectProto`), добавить его как поле в `ProjectProto`.
3. Если новый класс — наследник полиморфного типа, добавить его в соответствующий `oneof`.
4. Запустить `run.bat protoc`.
5. Создать Dart-класс с методами `toProto()` и `factory ... fromProto(...)`.
6. Если класс агрегирует другие протобиарные объекты — делегировать вызовы `toProto()` / `fromProto()` вложенным классам.
7. Если класс входит в `ProjectProto` — добавить маппинг в `ProjectData.toProto()` и `ProjectData.fromProto()`.
