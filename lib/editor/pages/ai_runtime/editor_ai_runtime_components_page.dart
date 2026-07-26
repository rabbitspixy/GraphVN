import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/ai_runtime/ai_runtime_downloader.dart';

class EditorAiRuntimeComponentsPage extends StatefulWidget {
  const EditorAiRuntimeComponentsPage({super.key});

  @override
  State<EditorAiRuntimeComponentsPage> createState() => _EditorAiRuntimeComponentsPageState();
}

class _EditorAiRuntimeComponentsPageState extends State<EditorAiRuntimeComponentsPage> {
  late final List<VoidCallback> _callbacks;

  @override
  void initState() {
    super.initState();
    _callbacks = AiRuntimeDownloader.items.map((item) {
      final cb = () => setState(() {});
      item.addListener(cb);
      return cb;
    }).toList();
  }

  @override
  void dispose() {
    for (var i = 0; i < AiRuntimeDownloader.items.length; i++) {
      AiRuntimeDownloader.items[i].removeListener(_callbacks[i]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Компоненты AI Runtime',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: AiRuntimeDownloader.check,
            icon: const Icon(Icons.download_for_offline),
            label: const Text('Скачать всё'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: AiRuntimeDownloader.items.length,
              itemBuilder: (context, index) => _buildItemCard(AiRuntimeDownloader.items[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(AiRuntimeItem item) {
    final showProgress = item.status == AiRuntimeDownloadStatus.checking ||
        item.status == AiRuntimeDownloadStatus.downloading;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _statusIcon(item.status),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 2),
            Text(
              _statusText(item.status),
              style: TextStyle(
                fontSize: 12,
                color: _statusColor(item.status),
              ),
            ),
            if (showProgress) ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: item.totalBytes > 0
                    ? item.completedBytes / item.totalBytes
                    : null,
                color: _statusColor(item.status),
              ),
              if (item.totalBytes > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '${_formatBytes(item.completedBytes)} / ${_formatBytes(item.totalBytes)} (${(item.completedBytes / item.totalBytes * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(AiRuntimeDownloadStatus status) {
    switch (status) {
      case AiRuntimeDownloadStatus.installed:
        return const Icon(Icons.check_circle, color: Colors.green, size: 32);
      case AiRuntimeDownloadStatus.downloading:
      case AiRuntimeDownloadStatus.unpacking:
      case AiRuntimeDownloadStatus.checking:
        return const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 3),
        );
      case AiRuntimeDownloadStatus.missing:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 32);
    }
  }

  Color _statusColor(AiRuntimeDownloadStatus status) {
    switch (status) {
      case AiRuntimeDownloadStatus.installed:
        return Colors.green;
      case AiRuntimeDownloadStatus.checking:
        return Colors.orange;
      case AiRuntimeDownloadStatus.downloading:
        return Colors.blue;
      case AiRuntimeDownloadStatus.unpacking:
        return Colors.orange;
      case AiRuntimeDownloadStatus.missing:
        return Colors.grey;
    }
  }

  String _statusText(AiRuntimeDownloadStatus status) {
    switch (status) {
      case AiRuntimeDownloadStatus.missing:
        return 'Отсутствует';
      case AiRuntimeDownloadStatus.checking:
        return 'Проверка...';
      case AiRuntimeDownloadStatus.downloading:
        return 'Скачивание...';
      case AiRuntimeDownloadStatus.unpacking:
        return 'Распаковка...';
      case AiRuntimeDownloadStatus.installed:
        return 'Установлено';
    }
  }

  String _formatBytes(int bytes) {
    final mib = bytes / (1024 * 1024);
    return '${mib.toStringAsFixed(1)} MiB';
  }
}
