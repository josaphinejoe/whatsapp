import 'dart:async';

import 'package:example/dialogs/test_dialog/test_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base/snackbar_base.dart';
import 'error_message_snackbar/error_message_snackbar.dart';
import 'success_message_snackbar/success_message_snackbar.dart';
import 'warning_message_snackbar/warning_message_snackbar.dart';

typedef ShowSnackbarListener = void Function(SnackBarBase);
typedef ShowDialogListener = Future<dynamic> Function(Widget, bool);

class DialogService {
  late ShowDialogListener _showDialogListener;
  late ShowSnackbarListener _showSnackBarListener;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(ShowDialogListener showDialogListener) {
    this._showDialogListener = showDialogListener;
  }

  void registerSnackBarListener(ShowSnackbarListener showSnackBarListener) {
    this._showSnackBarListener = showSnackBarListener;
  }

  void showErrorMessage(String errorMessage) {
    this._showSnackBarListener(
      ErrorMessageSnackBar(
        message: errorMessage,
      ),
    );
  }

  void showWarningMessage(String warningMessage) {
    this._showSnackBarListener(
      WarningMessageSnackBar(
        message: warningMessage,
      ),
    );
  }

  void showSuccessMessage(String message) {
    this._showSnackBarListener(
      SuccessMessageSnackBar(
        message: message,
      ),
    );
  }

  Future<bool> showTestDialog() async {
    return await this._showDialogListener(TestDialog(), false) as bool? ?? false;
  }
}
