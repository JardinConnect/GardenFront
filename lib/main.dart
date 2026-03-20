import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:garden_connect/app.dart';
import 'package:garden_connect/mobile/mobile_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await initializeDateFormatting('fr_FR', null);
  final isMobile =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  runApp(isMobile ? const MobileApp() : const App());
}
