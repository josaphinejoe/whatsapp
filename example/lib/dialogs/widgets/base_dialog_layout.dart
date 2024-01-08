import "package:flutter/material.dart";
import 'package:floater/floater.dart';

class BaseDialogLayout extends StatelessWidgetBase {
  final Widget child;

  const BaseDialogLayout({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => ModalRoute.of(context)?.barrierDismissible ?? false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x90000000),
                offset: Offset(0, 0),
                blurRadius: 36,
                spreadRadius: 0,
              )
            ],
          ),
          child: this.child,
        ),
      ),
    );
  }
}
