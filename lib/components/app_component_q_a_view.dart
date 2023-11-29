import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dart_code_viewer2/dart_code_viewer2.dart';

class QuestionAnswerView extends StatelessWidget {
  final String? question;
  final String? answer;
  final TextStyle? questionStyle;
  final TextStyle? answerStyle;
  final EdgeInsets? padding;
  final Widget? answerChild;
  final int? answerId;
  final bool? showOnlyText;
  const QuestionAnswerView({super.key, required this.question, required this.answer, this.questionStyle, this.answerStyle, this.padding, this.answerChild, this.answerId, this.showOnlyText = false});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(child: Container(
      padding: padding ?? 10.spMin.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(question.toNotNull, style: questionStyle ?? context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.start),
          if ((showOnlyText ?? false))
            10.spMin.height,
          if ((showOnlyText ?? false))
            Container(
            alignment: AlignmentDirectional.centerStart,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: padding ?? 10.spMin.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.spMin),
              color: context.theme.hintColor.withOpacity(0.08),
            ),
            child: answerChild ?? Text(answer.toNotNull, textAlign: TextAlign.start, style: answerStyle ?? context.textTheme.labelSmall),
          ),
          if (!(showOnlyText ?? false))
            10.spMin.height,
          if (!(showOnlyText ?? false))
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.spMin)
              ),
              child: DartCodeViewer((answerId == 0) ? "\n${answer.toNotNull}".toNotNull : answer.toNotNull,
                  height: (answer.toNotNull.length > 300) ? 250.spMin : 60.spMin,
                  backgroundColor: (answerId == 0) ? context.colorScheme.error.withOpacity(0.08) : context.theme.hintColor.withOpacity(0.08),
                  showCopyButton: false))
        ],
      ),
    ));
  }
}
