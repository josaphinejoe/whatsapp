import 'package:example/services/theme-provider.dart';
import 'package:example/whats-app/whats-app.dart';
import 'package:floater/floater.dart';

class WhatsAppState extends WidgetStateBase<WhatsApp> {
  final themeProvider = ServiceLocator.instance.resolve<ThemeProvider>();

  WhatsAppState() : super() {
    this.onInitState(() async {
      await themeProvider.init();
    });
  }
}
