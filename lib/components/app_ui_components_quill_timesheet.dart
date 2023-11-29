import 'dart:convert';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flexicomponents/helper/app_paths_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

class QuillEditorView extends StatelessWidget {
  final QuillController controller;
  late QuillController mainController = QuillController.basic();
  bool isReadOnly = false;
  String? content;
  Function()? onUnFocus;
  Function(String? json, String? plainText, String? htmlText)? onChange;

  QuillEditorView(
      {super.key,
        required this.controller,
        this.isReadOnly = false,
        this.onUnFocus,
        this.content,
        this.onChange}) {
    mainController = controller;
    mainController.addListener(() {
      onChange?.call(
          jsonEncode(mainController.document.toDelta().toJson()),
          mainController.document.toPlainText(),
          mainController.document.toDelta().toHtml());
    });

    if (content?.contains('{"insert"') ?? false) {
      mainController.document = Document.fromJson(
          jsonDecode(content.toNotNull.replaceAll("\n", "\\n"))
          as List<dynamic>);
    } else {
      if (content.isNotNullOrEmpty &&
          parse(content?.trim()).text.isNotNullOrEmpty) {
        if (content.isHtml) {
          mainController.document =
              Document.fromDelta(DeltaHtmlExt.fromHtml(content.toNotNull));
        } else {
          var value = [
            r'{"insert":' + "\"" + content.toNotNull + "\\n\"" + '}'
          ];
          mainController.document = Document.fromJson(jsonDecode('$value'));
        }
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
            child: QuillProvider(
              configurations: QuillConfigurations(controller: controller),
              child: Column(
                children: [
                  Expanded(
                      child: QuillEditor(
                        focusNode: FocusNode(),
                        scrollController: ScrollController(),
                        configurations: QuillEditorConfigurations(
                          // controller: mainController,
                          placeholder: "Enter work report here",
                          scrollable: true,
                          padding: 10.spMin.padding,
                          autoFocus: false,
                          readOnly: false,
                          expands: false,
                          contextMenuBuilder: (context, rawEditorState) =>
                              Container(),
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
                                  decoration: TextDecoration.underline),
                              placeHolder: DefaultTextBlockStyle(
                                  Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: FlexiColors.DATEGREY),
                                  const VerticalSpacing(0, 0),
                                  const VerticalSpacing(0, 0),
                                  null)),
                        ),
                      )),
                  QuillBaseToolbar(
                    configurations: QuillBaseToolbarConfigurations(
                      axis: Axis.horizontal,
                      toolbarIconAlignment: WrapAlignment.start,
                      toolbarIconCrossAlignment: WrapCrossAlignment.center,
                      childrenBuilder: (context) => [
                        QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(),
                            controller: controller,
                            attribute: Attribute.bold),
                        QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(),
                            controller: controller,
                            attribute: Attribute.underline),
                        QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(),
                            controller: controller,
                            attribute: Attribute.italic),
                        QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                controller: controller),
                            controller: controller,
                            attribute: Attribute.ol),
                        QuillToolbarToggleStyleButton(
                            options: QuillToolbarToggleStyleButtonOptions(
                                controller: controller),
                            controller: controller,
                            attribute: Attribute.ul),
                        QuillToolbarLinkStyleButton(
                            controller: controller,
                            options: QuillToolbarLinkStyleButtonOptions(
                                dialogTheme: QuillDialogTheme(
                                  dialogBackgroundColor: context.theme.cardColor,
                                  inputTextStyle: context.textTheme.labelMedium,
                                  buttonTextStyle: context.textTheme.labelMedium,
                                  labelTextStyle: context.textTheme.labelSmall,
                                ))),
                        QuillToolbarHistoryButton(
                            options:
                            QuillToolbarHistoryButtonOptions(isUndo: true),
                            controller: controller),
                        QuillToolbarHistoryButton(
                            options:
                            QuillToolbarHistoryButtonOptions(isUndo: false),
                            controller: controller),
                        QuillToolbarIndentButton(
                            controller: controller,
                            isIncrease: true,
                            options: QuillToolbarIndentButtonOptions()),
                        QuillToolbarIndentButton(
                            controller: controller,
                            isIncrease: false,
                            options: QuillToolbarIndentButtonOptions()),
                        QuillToolbarSelectHeaderStyleButtons(
                            controller: controller,
                            options:
                            QuillToolbarSelectHeaderStyleButtonsOptions()),
                        QuillToolbarColorButton(
                            controller: controller, isBackground: true),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
