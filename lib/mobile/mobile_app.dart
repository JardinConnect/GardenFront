import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/mobile/mobile_router.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../analytics/bloc/analytics_bloc.dart';
import '../areas/bloc/area_bloc.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  late final AuthBloc _authBloc;
  late final MobileAppRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _router = MobileAppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<CellBloc>(create: (_) => CellBloc()..add(LoadCells())),
        BlocProvider<AnalyticsBloc>(create: (context) => AnalyticsBloc()),
        BlocProvider<AreaBloc>(create: (context) => AreaBloc()..add(LoadAreas())),
      ],
      child: MaterialApp.router(
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
            shape: RoundedRectangleBorder(
              borderRadius: GardenRadius.radiusLg,
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: GardenRadius.radiusMd,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _router.router,
      ),
    );
  }
}
