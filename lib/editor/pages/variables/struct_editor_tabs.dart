import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/variables/struct_variables_editor.dart';
import 'package:graph_vn/game/struct.dart';

class StructEditorTabs extends StatefulWidget {
  final Struct struct;
  const StructEditorTabs({super.key, required this.struct});

  @override
  State<StructEditorTabs> createState() => _StructEditorTabsState();
}

class _StructEditorTabsState extends State<StructEditorTabs> with TickerProviderStateMixin {

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