import 'package:flutter/cupertino.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/procedure_selector.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class RunProcedure extends BaseAction {
  String structProcedureId = "";

  RunProcedure();

  @override
  String actionText() {
    return EditorState.structProcedureName(structProcedureId);
  }

  @override
  void exec() {
    final procedure = EditorState.procedureById(structProcedureId);
    if (procedure != null) {
      procedure.exec();
    }
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionRunProcedureProto();
    result.structProcedureId = structProcedureId;
    return AbstractActionProto()
        ..id = id
        ..runProcedure = result;
  }

  factory RunProcedure.fromProto(ActionRunProcedureProto proto) {
    final result = RunProcedure();
    result.structProcedureId = proto.structProcedureId;
    return result;
  }
}

class RunProcedureEditor extends StatefulWidget {
  final RunProcedure action;
  const RunProcedureEditor({super.key, required this.action});

  @override
  State<StatefulWidget> createState() => _RunProcedureEditorState();
}

class _RunProcedureEditorState extends State<RunProcedureEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(
          text: EditorState.structProcedureName(widget.action.structProcedureId),
        tap: () async {
            widget.action.structProcedureId = (await showProcedureSelector(context))?.id ?? widget.action.structProcedureId;
            setState(() {});
        }
      )
    ]);
  }
}