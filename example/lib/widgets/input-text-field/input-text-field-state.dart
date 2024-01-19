import 'package:example/widgets/input-text-field/input-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class InputTextFieldState extends WidgetStateBase<InputTextfield> {
  bool _isEditable = false;

  bool get isEditable => this._isEditable;
  set isEditable(bool val) => (this.._isEditable = val).triggerStateChange();

  late TextEditingController controller = TextEditingController(text: this.widget.initialValue);

  InputTextFieldState() : super() {
    this.onInitState(() => this.listen(this.controller, () => this.widget.onChange(this.controller.text)));
    this.onDispose(() => this.controller.dispose());
  }

  @override
  void didUpdateWidget(covariant InputTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.initialValue == oldWidget.initialValue) return;

    if (this.widget.initialValue == this.controller.value.text) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.controller.text = this.widget.initialValue;
    });
  }
}
