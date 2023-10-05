import 'dart:convert';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';

class QuillEditorView extends StatelessWidget {
  final QuillController controller;
  late QuillController mainController = QuillController.basic();
  bool isReadOnly = false;
  String? content;
  Function()? onUnFocus;
  Function(String? json, String? plainText)? onChange;

  QuillEditorView(
      {super.key,
      required this.controller,
      this.isReadOnly = false,
      this.onUnFocus,
      this.content,
      this.onChange}) {
    mainController = controller;
    mainController.addListener(() {
      onChange?.call(jsonEncode(mainController.document.toDelta().toJson()),
          mainController.document.toPlainText());
    });

    if (content?.contains('{"insert"') ?? false) {
      mainController.document = Document.fromJson(
          jsonDecode(content.toNotNull.replaceAll("\n", "\\n"))
              as List<dynamic>);
    } else {
      if (content.isNotNullOrEmpty &&
          parse(content?.trim()).text.isNotNullOrEmpty) {
        var value = [r'{"insert":' + "\"" + content.toNotNull + "\\n\"" + '}'];
        mainController.document = Document.fromJson(jsonDecode('$value'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Container(
            width: context.width,
            constraints:
                BoxConstraints(maxHeight: 150.spMin, minHeight: 120.spMin),
            child: QuillEditor(
                controller: mainController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                padding: 10.spMin.padding,
                autoFocus: false,
                readOnly: false,
                expands: false,
                contextMenuBuilder: (context, rawEditorState) => Container(),
                customStyles: DefaultStyles(
                    lists: DefaultListBlockStyle(
                        Theme.of(context).textTheme.labelLarge!,
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null,
                        null),
                    leading: DefaultListBlockStyle(
                        Theme.of(context).textTheme.labelLarge!,
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null,
                        null),
                    align: DefaultTextBlockStyle(
                        Theme.of(context).textTheme.labelLarge!,
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null),
                    paragraph: DefaultTextBlockStyle(
                        context.textTheme.labelMedium!,
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null),
                    link: context.textTheme.labelMedium?.copyWith(
                      color: Colors.blueAccent,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline
                    ),
                    placeHolder: DefaultTextBlockStyle(
                        Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: FlexiColors.DATEGREY),
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null)),
                placeholder: "Enter work report here")),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                child: QuillToolbar.basic(controller: mainController,
                  color: Colors.transparent,
                  showSuperscript: false,
                  showSubscript: false,
                  iconTheme: QuillIconTheme(
                    borderRadius: 5.spMin,
                  ),
                  dialogTheme: QuillDialogTheme(
                    dialogBackgroundColor: Colors.white,
                    labelTextStyle: context.textTheme.labelMedium,
                    inputTextStyle: context.textTheme.labelMedium,
                  ),
                  showDividers: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showUndo: false,
                  showRedo: false,
                  showCodeBlock: false,
                  showSearchButton: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showListCheck: false,
                  showQuote: false,
                  showInlineCode: false,
                  showAlignmentButtons: false,
                  showJustifyAlignment: false,
                  showCenterAlignment: false,
                  showLeftAlignment: false,
                  showRightAlignment: false,
                  showHeaderStyle: false,
                  showIndent: false,
                  showStrikeThrough: false,
                  showDirection: false,
                  showSmallButton: false,
                  axis: Axis.horizontal,
                  toolbarIconCrossAlignment: WrapCrossAlignment.start,
                  toolbarIconAlignment: WrapAlignment.start,
                  // toolbarIconSize: 16.spMin,
                  showLink: true,
                  showClearFormat: false,
                )),
            Expanded(
                child: Container()),
          ],
        )
      ],
    );
  }
}
