# Поддержка кнопок геймпада

## Как это работает

Отслеживание нажатий геймпада построено на пакете `universal_gamepad` и механизме Flutter `Notification`.

### 1. Глобальная подписка на события (`lib/gamepad_event_system.dart`)

Функция `listenGamepadEvents()` вызывается один раз в `main()` (`lib/main.dart:26`).

Она подписывается на `Gamepad.instance.events` и обрабатывает два типа событий:

- **`GamepadButtonEvent`** — нажатие кнопки. При нажатии (`event.pressed == true`) берётся текущий `FocusManager.instance.primaryFocus` и из его `context` диспатчится `GamepadButtonPressNotification(event.button)` — этот `Notification` всплывает вверх по дереву виджетов.
- **`GamepadConnectionEvent`** — подключение/отключение геймпада. Просто логируется через `logger`.

### 2. Реагирование через `NotificationListener`

`GamepadButtonPressNotification` — это подкласс `Notification`, несущий `GamepadButton button`.

Чтобы обработать нажатие, виджет оборачивается в `NotificationListener<GamepadButtonPressNotification>`. Колбэк возвращает `true`, если событие обработано (поглощено), и `false`, если нужно дать ему всплыть дальше.

## Как добавить поддержку кнопок в новое место

1. **Обернуть виджет** в `NotificationListener<GamepadButtonPressNotification>`.
2. **Сравнить `event.button`** с нужными значениями enum `GamepadButton` (из пакета `universal_gamepad`).
3. **Вернуть `true`**, если нажатие обработано.

```dart
return NotificationListener<GamepadButtonPressNotification>(
  onNotification: (GamepadButtonPressNotification event) {
    if (event.button == GamepadButton.a) {
      _onEnter();
      return true;
    }
    return false;
  },
  child: /* существующее дерево виджетов */,
);
```

## Примеры в проекте

| Место | Кнопки | Что делают |
|---|---|---|
| `lib/main.dart:133` | `start` | Открывает ESC-меню (`_showMenu`) |
| `lib/player/widgets/player_root_widget.dart:164` | `a`, `dpadDown`, `dpadUp` | Подтверждение выбора, навигация по кнопкам переходов |

## Особенности и ограничения

- **Нужен `primaryFocus`**: `Notification` диспатчится из контекста виджета, который сейчас в фокусе. Если ни один виджет не имеет фокуса, событие не будет доставлено.
- **Всплытие**: `NotificationListener` ловит события только от виджетов **ниже** него по дереву (внутри его `child`). Самый верхний `NotificationListener` в `main.dart` ловит события, поднявшиеся из любого места приложения.
- **Поглощение**: если колбэк вернул `true`, событие не уйдёт выше по дереву. Это позволяет, например, игровому экрану перехватывать кнопку раньше глобального обработчика.
- **Enum кнопок**: полный список доступных кнопок — `GamepadButton` из пакета `universal_gamepad` (например, `a`, `b`, `x`, `y`, `dpadUp`, `dpadDown`, `dpadLeft`, `dpadRight`, `start`, `back` и т.д.).
