import 'package:flexicomponents/components/app_components_loader_staggered_dots_wave.dart';
import 'package:flexicomponents/components/app_ui_components_button.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonView extends StatelessWidget {
  final VoidCallback? callback;
  final String? label;
  final TextStyle? style;
  final bool? showLoading;
  const ButtonView({super.key, this.callback, this.label, this.style, this.showLoading = false});

  @override
  Widget build(BuildContext context) {
    return FlexiButton(
        borderRadius: BorderRadius.circular(16.spMin),
        buttonColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).colorScheme.primary, style: BorderStyle.solid, width: 0.5.spMin),
        contentPadding: 10.spMin.padding,
        buttonPadding: EdgeInsets.only(
            right: 20.spMin,
            left: 20.spMin,
            top: 8.spMin,
            bottom: 8.spMin), onPressed: callback,
        child: AnimatedSwitcher(duration: const Duration(seconds: 2),
          switchOutCurve: Curves.fastEaseInToSlowEaseOut,
          child: (showLoading ?? false) ? StaggeredDotsWave(size: 18.spMin, color: context.colorScheme.onSecondaryContainer, key: Key("animation"),) : Text(
            label.toNotNull,
            style: style ?? TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12.spMin),
          ),
        ));
  }
}
