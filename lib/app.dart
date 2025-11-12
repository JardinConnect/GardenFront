import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_ui/ui/design_system.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        theme: ThemeData(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
          useMaterial3: true,
          colorScheme: ColorScheme(
            primary: GardenColors.primary.shade500,
            onPrimary: GardenColors.primary.shade50,
            secondary: GardenColors.secondary.shade500,
            onSecondary: GardenColors.secondary.shade50,
            tertiary: GardenColors.tertiary.shade500,
            onTertiary: GardenColors.tertiary.shade50,
            surface: GardenColors.base.shade50,
            onSurface: GardenColors.base.shade500,
            error: GardenColors.redAlert.shade500,
            onError: GardenColors.redAlert.shade50,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: GardenColors.base.shade50,
          textTheme: TextTheme(
            displayLarge: GardenTypography.displayXl,
            displayMedium: GardenTypography.displayLg,
            headlineLarge: GardenTypography.headingLg,
            headlineMedium: GardenTypography.headingMd,
            headlineSmall: GardenTypography.headingSm,
            bodyLarge: GardenTypography.bodyLg,
            bodyMedium: GardenTypography.bodyMd,
          ),
          cardTheme: CardThemeData(
            color: GardenColors.base.shade50,
            elevation: 1,
            margin: EdgeInsets.all(GardenSpace.paddingMd),
            shadowColor: Colors.black.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(borderRadius: GardenRadius.radiusLg),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: GardenColors.primary.shade500,
              foregroundColor: GardenColors.primary.shade50,
              elevation: 0,
              textStyle: GardenTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: GardenSpace.paddingLg,
                vertical: GardenSpace.paddingMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: GardenRadius.radiusSm,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: GardenColors.base.shade50,
            contentPadding: EdgeInsets.symmetric(
              horizontal: GardenSpace.paddingMd,
              vertical: GardenSpace.paddingMd,
            ),
            border: OutlineInputBorder(
              borderRadius: GardenRadius.radiusMd,
              borderSide: BorderSide(
                color: GardenColors.base.shade400,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: GardenRadius.radiusMd,
              borderSide: BorderSide(
                color: GardenColors.base.shade400,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: GardenRadius.radiusMd,
              borderSide: BorderSide(
                color: GardenColors.primary.shade500,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: GardenRadius.radiusMd,
              borderSide: BorderSide(
                color: GardenColors.redAlert.shade500,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: GardenRadius.radiusMd,
              borderSide: BorderSide(
                color: GardenColors.redAlert.shade500,
                width: 2,
              ),
            ),
            labelStyle: GardenTypography.bodyMd,
            hintStyle: GardenTypography.bodyMd.copyWith(
              color: GardenColors.typography.shade300,
            ),
            errorStyle: GardenTypography.caption.copyWith(
              color: GardenColors.redAlert.shade500,
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: GardenColors.typography.shade800,
            contentTextStyle: GardenTypography.bodyMd.copyWith(
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(borderRadius: GardenRadius.radiusMd),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
