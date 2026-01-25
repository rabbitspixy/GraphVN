import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/variables/struct_procedures.dart';
import 'package:graph_vn/editor/pages/variables/struct_variables.dart';
import 'package:graph_vn/editor/variables.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
            Tab(text: 'Procedures'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              StructVariables(struct: widget.struct),
              StructProcedures(struct: widget.struct),
            ],
          ),
        ),
      ],
    );
  }
}