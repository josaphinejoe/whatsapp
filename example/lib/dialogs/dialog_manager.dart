import 'dart:async';

import 'package:example/dialogs/base/snackbar_base.dart';
import 'package:example/dialogs/dialog_service.dart';
import 'package:example/dialogs/widgets/base_dialog_layout.dart';
import 'package:example/dialogs/widgets/snackbar_container.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class DialogManager extends StatefulWidgetBase<DialogManagerState> {
  final Widget child;

  DialogManager({
    required this.child,
  }) : super(() => DialogManagerState());

  @override
  Widget build(BuildContext context) {
    return this.child;
  }
}

class DialogManagerState extends WidgetStateBase<DialogManager> with TickerProviderStateMixin {
  static const _snackbarVisibilityDuration = Duration(seconds: 4);

  final _dialogService = ServiceLocator.instance.resolve<DialogService>();

  late final _snackBarAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  OverlayEntry? _currentSnackBarEntry;
  Timer? _snackBarTimer;

  DialogManagerState() : super() {
    this.onInitState(() {
      this._dialogService.registerDialogListener(this._showDialog);
      this._dialogService.registerSnackBarListener(this._showSnackBar);
    });

    this.onDispose(() {
      this._snackBarAnimationController.dispose();
    });
  }

  Future<dynamic> _showDialog(Widget dialog, bool barrierDismissible) {
    return showDialog(
      context: context,
      builder: (context) => BaseDialogLayout(
        child: dialog,
      ),
      barrierDismissible: barrierDismissible,
      useSafeArea: false,
      barrierColor: const Color(0xFF387463).withOpacity(0.3),
    );
  }

  Future<void> _showSnackBar(SnackBarBase snackBar) async {
    await this._widgetHideSnackbar();

    // ignore: use_build_context_synchronously
    final overlayState = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => this._buildSnackBar(context, snackBar),
      opaque: false,
    );
    this._currentSnackBarEntry = entry;
    overlayState.insert(
      this._currentSnackBarEntry!,
    );
    await this._snackBarAnimationController.forward();
    this._snackBarTimer = Timer(_snackbarVisibilityDuration, () async {
      if (entry == this._currentSnackBarEntry) await this._widgetHideSnackbar();
    });
  }

  Future<void> _widgetHideSnackbar() async {
    if (this._currentSnackBarEntry == null) return;

    this._snackBarTimer?.cancel();
    this._snackBarTimer = null;
    await this._snackBarAnimationController.reverse();
    await Future.delayed(const Duration(milliseconds: 100));

    if (this._currentSnackBarEntry == null) return;

    this._currentSnackBarEntry!.remove();
    this._currentSnackBarEntry = null;
  }

  Widget _buildSnackBar(BuildContext context, SnackBarBase snackBar) {
    return SnackbarContainer(
      controller: this._snackBarAnimationController,
      onDismiss: this._widgetHideSnackbar,
      snackbar: snackBar,
    );
  }
}
