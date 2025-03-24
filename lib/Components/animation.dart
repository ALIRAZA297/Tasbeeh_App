import 'package:flutter/material.dart';

bool enableAppButtonScaleAnimationGlobal = true;
int? appButtonScaleAnimationDurationGlobal;

/// Default App Button
class AppButtonAnimation extends StatefulWidget {
  final bool enabled;
  final bool? enableScaleAnimation;
  final Widget? child;

  const AppButtonAnimation({
    this.child,
    this.enabled = true,
    this.enableScaleAnimation,
    super.key,
  });

  @override
  State<AppButtonAnimation> createState() => _AppButtonAnimationState();
}

class _AppButtonAnimationState extends State<AppButtonAnimation> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;

  @override
  void initState() {
    if (widget.enableScaleAnimation.validate(value: enableAppButtonScaleAnimationGlobal)) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )..addListener(() {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && widget.enabled) {
      _scale = 1 - _controller!.value;
    }

    if (widget.enableScaleAnimation.validate(value: enableAppButtonScaleAnimationGlobal)) {
      return Listener(
        onPointerDown: (details) {
          _controller?.forward();
        },
        onPointerUp: (details) {
          _controller?.reverse();
        },
        child: Transform.scale(
          scale: _scale,
          child: buildButton(),
        ),
      );
    } else {
      return buildButton();
    }
  }

  Widget buildButton() {
    return widget.child ?? const SizedBox.shrink();
  }
}

extension BooleanExtensions on bool? {
  /// Validate given bool is not null and returns given value if null.
  bool validate({bool value = false}) => this ?? value;

  /// get int value from bool
  int getIntBool({bool value = false}) {
    if (this ?? value) {
      return 1;
    } else {
      return 0;
    }
  }
}