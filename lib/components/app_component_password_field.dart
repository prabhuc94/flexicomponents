// ignore_for_file: must_be_immutable

import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordTextField extends StatelessWidget {
  final ValueNotifier<bool> _hidePassword = ValueNotifier(true);
  TextEditingController? controller;
  final FocusNode _focusNode = FocusNode();
  String? hintText;
  TextStyle? hintTextStyle;
  TextStyle? style;
  BoxConstraints? constraints;
  InputBorder? border;
  EdgeInsets? contentPadding;
  bool? isDense;
  Function()? onEditingComplete;
  Function(String val)? onSubmitted;
  Function(String val)? onChanged;
  List<TextInputFormatter>? inputFormatters;
  TextInputAction? inputAction;
  PasswordTextField({super.key, this.controller, this.isDense, this.contentPadding, this.border, this.constraints, this.hintText, this.hintTextStyle, this.style, this.onEditingComplete, this.onSubmitted, this.onChanged, this.inputFormatters, this.inputAction});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: _hidePassword, builder: (_, value, __) => TextField(
      key: key,
      style: style ?? context.textTheme.labelMedium,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      focusNode: _focusNode,
      onTap: () => _focusNode.requestFocus(),
      maxLines: 1,
      minLines: 1,
      obscureText: value,
      textInputAction: inputAction,
      inputFormatters: inputFormatters,
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      onTapOutside: (val) {
        _focusNode.unfocus();
        _hidePassword.value = true;
      },
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
          hintStyle: hintTextStyle ?? context.textTheme.labelSmall,
          constraints: constraints,
          border: border,
          contentPadding: contentPadding,
          isDense: isDense,
          suffix: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(onTap: (){
              _hidePassword.value = !value;
            }, child: Icon((value) ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 14.spMin,)),
          )
      ),
    ));
  }
}
