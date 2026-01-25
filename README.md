# GraphVN

GraphVN is a lightweight, cross‑platform engine for creating visual novels and complex nonlinear quests with images.  
Built on Flutter, it runs on desktop and mobile with a single code base and offers a **no‑code graph editor** that lets designers build stories by connecting nodes instead of writing scripts.

## Features

- **Flutter powered** – one code base, runs on Windows, macOS, Linux, Android, iOS, and the web.
- **No‑code editor** – drag‑and‑drop nodes and transitions on a canvas.  
  No text editor or scripting language is required, lowering the learning curve.
- **Rich media support** – each node can display an image, background color, shake effect, and custom scaling.
- **Extensible** – the engine exposes a simple API for adding custom actions, variables, and expressions.
- **Future integrations** – planned support for ComfyUI image generation and LLM‑based text assistance.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.10 or newer
- Dart 3.0 or newer
- (Optional) A ComfyUI installation for image generation

### Installation

```bash
git clone https://github.com/your-username/graphvn.git
cd graphvn
flutter pub get
```

### Running the App

```bash
flutter run
```

The app starts in **play mode**. Press **F1** to toggle the editor overlay.  
Use **Ctrl+S** to save the current project.

### Project Structure

```
lib/
├─ editor/          # Graph editor, actions, variables, UI widgets
├─ components.dart  # Core game components (Node, Transition, etc.)
├─ engine.dart      # Game logic and state management
├─ game_player.dart # UI for playing the story
└─ main.dart        # Application entry point
```

## Usage

1. **Create a new project** – the editor automatically creates a `projects/<name>/main.xml` file.
2. **Add nodes** – double‑click on the canvas to create a node. Edit its text, label, and start flag.
3. **Connect nodes** – hold **Ctrl** and drag from one node to another to create a transition.
4. **Add actions** – inside a node, add actions such as setting variables or changing the background.
5. **Play** – press **F1** to exit the editor and play the story.  
   The game will follow the graph you built.

## Contributing

Pull requests are welcome!  
Please open an issue first to discuss major changes.  
Make sure to run `flutter analyze` and `flutter test` before submitting.

## License

MIT © 2026 GraphVN

```
