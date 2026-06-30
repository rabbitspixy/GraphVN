import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/variables/struct_variables_editor.dart';
import 'package:graph_vn/editor/struct.dart';

class StructEditor extends StatefulWidget {
  final Struct struct;
  const StructEditor({super.key, required this.struct});

  @override
  State<StructEditor> createState() => _StructEditorState();
}

class _StructEditorState extends State<StructEditor> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar.secondary(
          controller: _tabController,
          tabs: [
            Tab(text: 'Variables'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              StructVariablesEditor(struct: widget.struct),
            ],
          ),
        ),
      ],
    );
  }
}