import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/modals/struct_action_editor.dart';

import '../../struct_procedure.dart';

class StructProcedures extends StatefulWidget {
  final Struct struct;
  
  StructProcedures({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructProcedures> createState() => _StructProceduresState();
}

class _StructProceduresState extends State<StructProcedures> {
  StructProcedure? _selectedProcedure;

  Widget expandedProcedure(StructProcedure procedure) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(procedure.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final newName = await showRenameDialog(context, 'Edit Procedure Name', procedure.name);
                  if (newName != null) {
                    setState(() {
                      procedure.name = newName;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  procedure.exec();
                  setState(() {});
                },
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              procedure.actions.map((action) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: ElevatedButton(
                    onPressed: () async {
                      final editResult = await editStructAction(context, action);
                      if (editResult != null) {
                        procedure.actions[procedure.actions.indexOf(action)] = editResult;
                        setState(() {});
                      }
                    },
                    child: Text(action.actionText()),
                  ),
                );
              }).toList(),
              [
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Action'),
                  onPressed: () {
                    setState(() {
                      procedure.actions.add(DoNothing());
                    });
                  },
                )
              ]
            ].expand((x) => x).toList()
          ),
        ],
      ),
    );
  }

  Widget minimizedProcedure(StructProcedure procedure) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProcedure = procedure;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(procedure.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      procedure.exec();
                      setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.struct.procedures.length + 1,
            itemBuilder: (context, procIndex) {
              if (procIndex == widget.struct.procedures.length) {
                return Padding(
                  padding: EdgeInsets.all(8),
                    child: OutlinedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Procedure'),
                    onPressed: () {
                      setState(() {
                        widget.struct.procedures.add(StructProcedure());
                      });
                    },
                  ),
                );
              }
              final procedure = widget.struct.procedures[procIndex];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: _selectedProcedure == procedure ? expandedProcedure(procedure) : minimizedProcedure(procedure),
              );
            },
          ),
        ),
      ],
    );
  }
}
