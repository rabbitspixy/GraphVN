import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/gamepad_event_system.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:universal_gamepad/universal_gamepad.dart';

class ProjectSelector extends StatefulWidget {
  const ProjectSelector({super.key});

  @override
  State<ProjectSelector> createState() => _ProjectSelectorState();
}

enum _Screen { menu, editor, play }

class _ProjectSelectorState extends State<ProjectSelector> {
  _Screen _screen = _Screen.menu;
  int _selectedIndex = 0;
  List<String> _projects = [];
  List<String> _gameZips = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadGameZips();
  }

  void _loadProjects() {
    _projects = GameState.getProjectFolders();
  }

  void _loadGameZips() {
    _gameZips = GameState.getGameFiles();
  }

  void _goToMenu() {
    setState(() {
      _screen = _Screen.menu;
      _selectedIndex = 0;
      _loadProjects();
      _loadGameZips();
    });
  }

  void _goToEditor() {
    setState(() {
      _screen = _Screen.editor;
      _selectedIndex = 0;
    });
  }

  void _goToPlay() {
    setState(() {
      _screen = _Screen.play;
      _selectedIndex = 0;
    });
  }

  void _select(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _createNewProject() async {
    final name = await showRenameDialog(context, 'New Project', '');
    if (name != null && name.isNotEmpty) {
      GameState.createAndLoadNewProject(name);
      setState(() {
        _loadProjects();
      });
    }
  }

  int _itemCount() {
    switch (_screen) {
      case _Screen.menu:
        return 2;
      case _Screen.editor:
        return _projects.length + 1;
      case _Screen.play:
        return _gameZips.length;
    }
  }

  void _onArrowUp() {
    final len = _itemCount();
    if (len == 0) return;
    setState(() {
      _selectedIndex = (_selectedIndex - 1).clamp(0, len - 1);
    });
  }

  void _onArrowDown() {
    final len = _itemCount();
    if (len == 0) return;
    setState(() {
      _selectedIndex = (_selectedIndex + 1).clamp(0, len - 1);
    });
  }

  void _onEnter() {
    switch (_screen) {
      case _Screen.menu:
        if (_selectedIndex == 0) _goToPlay();
        if (_selectedIndex == 1) _goToEditor();
      case _Screen.editor:
        if (_selectedIndex < _projects.length) {
          GameState.loadProjectForEditing(_projects[_selectedIndex]);
        } else if (_selectedIndex == _projects.length) {
          _createNewProject();
        }
      case _Screen.play:
        if (_selectedIndex < _gameZips.length) {
          GameState.loadGameForPlaying(_gameZips[_selectedIndex]);
        }
    }
  }

  void _onBack() {
    switch (_screen) {
      case _Screen.menu:
        break;
      case _Screen.editor:
      case _Screen.play:
        _goToMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = switch (_screen) {
      _Screen.menu => _MenuScreen(
          selectedIndex: _selectedIndex,
          onPlay: _goToPlay,
          onEditor: _goToEditor,
          onSelect: _select,
        ),
      _Screen.editor => _EditorScreen(
          projects: _projects,
          selectedIndex: _selectedIndex,
          onProjectTap: (p) => GameState.loadProjectForEditing(p),
          onCreateNew: _createNewProject,
          onBack: _goToMenu,
          onSelect: _select,
        ),
      _Screen.play => _PlayScreen(
          gameZips: _gameZips,
          selectedIndex: _selectedIndex,
          onZipTap: (path) => GameState.loadGameForPlaying(path),
          onBack: _goToMenu,
          onSelect: _select,
        ),
    };

    return NotificationListener<GamepadButtonPressNotification>(
      onNotification: (GamepadButtonPressNotification event) {
        if (event.button == GamepadButton.dpadUp) {
          _onArrowUp();
          return true;
        }
        if (event.button == GamepadButton.dpadDown) {
          _onArrowDown();
          return true;
        }
        if (event.button == GamepadButton.a) {
          _onEnter();
          return true;
        }
        if (event.button == GamepadButton.b) {
          _onBack();
          return true;
        }
        return false;
      },
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.arrowUp): _onArrowUp,
          const SingleActivator(LogicalKeyboardKey.arrowDown): _onArrowDown,
          const SingleActivator(LogicalKeyboardKey.enter): _onEnter,
          const SingleActivator(LogicalKeyboardKey.backspace): _onBack,
        },
        child: Focus(
          autofocus: true,
          child: screen,
        ),
      ),
    );
  }
}

class _MenuScreen extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onPlay;
  final VoidCallback onEditor;
  final ValueChanged<int> onSelect;

  const _MenuScreen({
    required this.selectedIndex,
    required this.onPlay,
    required this.onEditor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Graph VN',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visual Novel Engine',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 64),
            _MenuButton(
              icon: Icons.play_arrow_rounded,
              label: 'Играть',
              selected: selectedIndex == 0,
              onTap: onPlay,
              onHover: () => onSelect(0),
            ),
            const SizedBox(height: 20),
            _MenuButton(
              icon: Icons.edit_rounded,
              label: 'Редактор',
              selected: selectedIndex == 1,
              onTap: onEditor,
              onHover: () => onSelect(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onHover;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => onHover(),
      child: SizedBox(
        width: 280,
        height: 64,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: selected
                ? const Color(0xFF1D4E8F)
                : const Color(0xFF0F3460),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: selected
                  ? const BorderSide(color: Colors.lightBlueAccent, width: 2)
                  : BorderSide.none,
            ),
            elevation: 4,
            shadowColor: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          label: const Text(
            'Назад',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _EditorScreen extends StatelessWidget {
  final List<String> projects;
  final int selectedIndex;
  final ValueChanged<String> onProjectTap;
  final VoidCallback onCreateNew;
  final VoidCallback onBack;
  final ValueChanged<int> onSelect;

  const _EditorScreen({
    required this.projects,
    required this.selectedIndex,
    required this.onProjectTap,
    required this.onCreateNew,
    required this.onBack,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          _BackButton(onTap: onBack),
          const SizedBox(height: 24),
          const Text(
            'Редактор',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: projects.isEmpty
                ? Center(
                    child: Text(
                      'Нет проектов',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: projects.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      return _ListTile(
                        label: p,
                        selected: index == selectedIndex,
                        onTap: () => onProjectTap(p),
                        onHover: () => onSelect(index),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 48, left: 32, right: 32),
            child: SizedBox(
              width: 280,
              height: 48,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (_) => onSelect(projects.length),
                child: ElevatedButton.icon(
                  onPressed: onCreateNew,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Создать новый проект',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex == projects.length
                        ? const Color(0xFF1D4E8F)
                        : const Color(0xFF0F3460),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: selectedIndex == projects.length
                          ? const BorderSide(
                              color: Colors.lightBlueAccent, width: 2)
                          : BorderSide.none,
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayScreen extends StatelessWidget {
  final List<String> gameZips;
  final int selectedIndex;
  final ValueChanged<String> onZipTap;
  final VoidCallback onBack;
  final ValueChanged<int> onSelect;

  const _PlayScreen({
    required this.gameZips,
    required this.selectedIndex,
    required this.onZipTap,
    required this.onBack,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          _BackButton(onTap: onBack),
          const SizedBox(height: 24),
          const Text(
            'Играть',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: gameZips.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Нет загруженных игр',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Поместите .zip файлы в папку games/',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: gameZips.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final path = gameZips[index];
                      final name = path.split('\\').last.split('/').last;
                      return _ListTile(
                        label: name,
                        icon: Icons.inventory_2_outlined,
                        selected: index == selectedIndex,
                        onTap: () => onZipTap(path),
                        onHover: () => onSelect(index),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onHover;

  const _ListTile({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (_) => onHover(),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF24356B)
                  : const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Colors.lightBlueAccent.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.06),
                width: selected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    icon ?? Icons.folder_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
