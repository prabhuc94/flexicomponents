// ignore_for_file: must_be_immutable

import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordTextField extends StatelessWidget {
  final ValueNotifier<bool> _hidePassword = ValueNotifier(true);
  final ValueNotifier<bool> _showIcon = ValueNotifier(false);
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
  PasswordTextField({super.key, this.controller, this.isDense, this.contentPadding, this.border, this.constraints, this.hintText, this.hintTextStyle, this.style, this.onEditingComplete, this.onSubmitted, this.onChanged, this.inputFormatters, this.inputAction}) {
    controller?.addListener(() {
      _showIcon.value = (controller?.isNotNullOrEmpty ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: _hidePassword, builder: (_, value, __) => ValueListenableBuilder(valueListenable: _showIcon, builder: (_, showIcon, __) => FocusableActionDetector(
      onFocusChange: (val) {
        _showIcon.value = (val) ? (controller?.isNotNullOrEmpty ?? false) : val;
        _hidePassword.value = (!val) ? true : _hidePassword.value;
      },
      child: TextField(
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
        inputFormatters: inputFormatters ?? [ FilteringTextInputFormatter.deny(RegExp(r'\s')) ],
        keyboardType: TextInputType.visiblePassword,
        controller: controller,
        onTapOutside: (val) {
          _focusNode.unfocus();
          _hidePassword.value = true;
          _showIcon.value = false;
        },
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintTextStyle ?? context.textTheme.labelSmall,
            constraints: constraints,
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            contentPadding: contentPadding ?? EdgeInsets.only(
                top: 0,
                bottom: 0,
                left: 20.spMin,
                right: 20.spMin),
            isDense: isDense,
            suffixIcon: showIcon ?  MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(onTap: (){
                _hidePassword.value = !value;
              }, child: Icon((value) ? Icons.visibility : Icons.visibility_off, size: 14.spMin,)),
            ) : null
        ),
      ),
    ),));
  }
}
