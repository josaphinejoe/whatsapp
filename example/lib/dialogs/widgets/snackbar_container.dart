import 'package:example/dialogs/base/snackbar_base.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class SnackbarContainer extends StatelessWidgetBase {
  final SnackBarBase snackbar;
  final VoidCallback onDismiss;
  final AnimationController controller;
  final kSnackbarHeight = 64.0;

  const SnackbarContainer({
    required this.snackbar,
    required this.onDismiss,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.down,
        resizeDuration: null,
        onDismissed: (direction) {
          this.onDismiss();
        },
        background: Container(
          color: Colors.transparent,
        ),
        child: SlideTransition(
          position: this._buildAnimation(),
          child: Material(
            elevation: 6,
            textStyle: Theme.of(context).snackBarTheme.contentTextStyle,
            color: this.snackbar.backgroundColor,
            child: SafeArea(
              top: false,
              child: Container(
                height: kSnackbarHeight,
                padding: const EdgeInsets.all(16),
                child: this.snackbar.build(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Animation<Offset> _buildAnimation() {
    return Tween(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: this.controller,
        curve: Curves.decelerate,
      ),
    );
  }
}
