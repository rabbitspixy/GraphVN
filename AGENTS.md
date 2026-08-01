# GraphVN — agent instructions

## Commands

| Task | Command |
|------|---------|
| Run app (Windows) | `flutter run -d windows` or `run.bat windows` |
| Build (Windows) | `flutter build windows` or `run.bat build windows` |
| Run codegen (dart_mappable) | `dart run build_runner build --delete-conflicting-outputs` or `run.bat build_runner` |
| Regenerate protobuf | `run.bat protoc` (requires `protoc.exe` + `protoc-gen-dart` on PATH) |
| Run all tests | `dart run test` |
| Analyze | `flutter analyze` |

## Code generation

Two separate generators, both produce files that **must not be edited by hand**:

1. **`dart_mappable_builder`** (`build.yaml`) — outputs to `lib/**/generated/{{file}}.mapper.dart`. Re-run after changing any model class annotated with `@Mappable`.
2. **Protobuf** (`data.proto`) — outputs to `lib/generated-proto/`. Re-run after changing `data.proto`. Gitignored.

Generated directories (`lib/generated-proto/`, `lib/**/generated/`) are gitignored.

## Project knowledge base

- [Общая информация о всём проекте](knowledge_base/main.md)
- [Хранение квеста через Protobuf](knowledge_base/persist.md)
- [Поддержка кнопок геймпада](knowledge_base/gamepad.md)

## Tests

Uses `package:test` (not `flutter_test`).
Run with `dart run test`.

## Conventions

- Dart SDK `^3.10.4`, uses `flutter_lints` lint set
- Imports use `package:` paths (not relative)
- Variables in the game engine follow the pattern `variables["Category->Name"]`
- String replacement in code uses `CodeRepository.replaceInCode(old, new)` (handles actions, conditions, replaceables)
