import 'package:example/dialogs/base/snackbar_base.dart';
import 'package:flutter/material.dart';

class SuccessMessageSnackBar implements SnackBarBase {
  final String message;

  @override
  Color get backgroundColor => Colors.green;

  SuccessMessageSnackBar({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Text(
            this.message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ],
    );
  }
}
