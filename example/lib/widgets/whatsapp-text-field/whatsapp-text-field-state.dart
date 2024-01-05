import 'package:example/widgets/whatsapp-text-field/whatsapp-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class WhatsappTextFieldState extends WidgetStateBase<WhatsappTextField> {
  late TextEditingController controller = TextEditingController(text: this.widget.initialValue);

  WhatsappTextFieldState() : super() {
    this.onInitState(() => this.listen(this.controller, () => this.widget.onChange(this.controller.text)));
    this.onDispose(() => this.controller.dispose());
  }

  @override
  void didUpdateWidget(covariant WhatsappTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.initialValue == oldWidget.initialValue) return;

    if (this.widget.initialValue == this.controller.value.text) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.controller.text = this.widget.initialValue;
    });
  }
}
