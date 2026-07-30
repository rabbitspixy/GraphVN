import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';

class ProjectSelector extends StatefulWidget {
  const ProjectSelector({super.key});

  @override
  State<ProjectSelector> createState() => _ProjectSelectorState();
}

enum _Screen { menu, editor, play }

class _ProjectSelectorState extends State<ProjectSelector> {
  _Screen _screen = _Screen.menu;
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

  Future<void> _createNewProject() async {
    final name = await showRenameDialog(context, 'New Project', '');
    if (name != null && name.isNotEmpty) {
      GameState.createAndLoadNewProject(name);
      setState(() {
        _loadProjects();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case _Screen.menu:
        return _MenuScreen(
          onPlay: () => setState(() => _screen = _Screen.play),
          onEditor: () => setState(() => _screen = _Screen.editor),
        );
      case _Screen.editor:
        return _EditorScreen(
          projects: _projects,
          onProjectTap: (p) => GameState.loadProjectForEditing(p),
          onCreateNew: _createNewProject,
          onBack: () => setState(() {
            _screen = _Screen.menu;
            _loadProjects();
          }),
        );
      case _Screen.play:
        return _PlayScreen(
          gameZips: _gameZips,
          onZipTap: (path) => GameState.loadGameForPlaying(path),
          onBack: () => setState(() {
            _screen = _Screen.menu;
            _loadGameZips();
          }),
        );
    }
  }
}

class _MenuScreen extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onEditor;

  const _MenuScreen({
    required this.onPlay,
    required this.onEditor,
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
              onTap: onPlay,
            ),
            const SizedBox(height: 20),
            _MenuButton(
              icon: Icons.edit_rounded,
              label: 'Редактор',
              onTap: onEditor,
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
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F3460),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
  final ValueChanged<String> onProjectTap;
  final VoidCallback onCreateNew;
  final VoidCallback onBack;

  const _EditorScreen({
    required this.projects,
    required this.onProjectTap,
    required this.onCreateNew,
    required this.onBack,
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
                        onTap: () => onProjectTap(p),
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
              child: ElevatedButton.icon(
                onPressed: onCreateNew,
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Создать новый проект',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3460),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
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
  final ValueChanged<String> onZipTap;
  final VoidCallback onBack;

  const _PlayScreen({
    required this.gameZips,
    required this.onZipTap,
    required this.onBack,
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
                        onTap: () => onZipTap(path),
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
  final VoidCallback onTap;

  const _ListTile({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
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
    );
  }
}
