import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlexiButton extends StatelessWidget {
  final EdgeInsets? contentPadding;

  final EdgeInsets? buttonPadding;

  final bool? isFlexible;

  final Widget? icon;

  final Widget? child;

  final Color? buttonColor;

  final Color? iconColor;

  /// This Given Color will work only withOut Icon
  final Color? textColor;

  final BorderRadiusGeometry? borderRadius;

  final double? elevation;

  final Function()? onPressed;

  final BorderSide? side;

  final double? iconSize;

  final TextStyle? style;

 const FlexiButton(
      {super.key,
      this.contentPadding,
      this.buttonPadding = EdgeInsets.zero,
      this.isFlexible = false,
      this.icon,
      required this.child,
      this.buttonColor,
      this.iconColor,
      this.textColor,
      this.borderRadius,
      this.side = BorderSide.none,
      this.elevation = 2,
      this.iconSize = 10,
      this.style,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return (isFlexible ?? false)
        ? Flexible(child: _renderButton(context))
        : _renderButton(context);
  }

  Widget _renderButton(BuildContext context) {
    return Padding(
      padding: contentPadding ?? EdgeInsets.zero,
      child: (icon == null)
          ? MaterialButton(
              onPressed: onPressed,
              color: buttonColor ?? Theme.of(context).primaryColor,
              padding: buttonPadding,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: elevation?.spMin,
              textColor: textColor ?? Theme.of(context).cardColor,
              hoverColor: (buttonColor == Colors.transparent) ? Colors.transparent : buttonColor,
              disabledColor: Theme.of(context).disabledColor,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.zero,
                  side: side ?? BorderSide.none),
              key: UniqueKey(),
              child: child,
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon ?? Container(),
              label: child ?? Container(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              key: UniqueKey(),
              style: ButtonStyle(
                alignment: Alignment.center,
                padding: MaterialStatePropertyAll(buttonPadding),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.zero,
                    side: side ?? BorderSide.none)),
                elevation: MaterialStatePropertyAll(elevation?.spMin),
                backgroundColor: MaterialStatePropertyAll(buttonColor ?? Theme.of(context).primaryColor),
                iconSize: MaterialStatePropertyAll(iconSize),
                iconColor: MaterialStatePropertyAll(iconColor ?? Theme.of(context).primaryColor),
                textStyle: MaterialStatePropertyAll(style ?? Theme.of(context).textTheme.labelMedium)
              )),
    );
  }
}
