import 'package:flutter/material.dart';
import 'package:loveblocks/src/widgets/common/indicator.dart';

/// A button that shows a busy indicator in place of title
class AppButton extends StatelessWidget {
  final bool busy;
  final bool enabled;
  final String? title;
  final Widget? child;
  final VoidCallback? onPressed;

  const AppButton({
    this.onPressed,
    this.title,
    this.child,
    this.busy = false,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 12;
    return ElevatedButton(
        onPressed: enabled
            ? () {
                if (onPressed != null || busy == false) {
                  onPressed?.call();
                }
              }
            : null,
        child: Container(
          height: Theme.of(context).buttonTheme.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: padding * 2),
              child ??
                  Text(
                    title ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
              if (busy) const Indicator(radius: padding) else const SizedBox(width: padding * 2),
            ],
          ),
        ));
  }
}
