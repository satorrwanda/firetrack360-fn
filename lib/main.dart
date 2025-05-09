import 'dart:async';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:firetrack360/ui/widgets/kinyarwanda_upertino_localizations.dart';
import 'package:firetrack360/ui/widgets/material_localizationsdelegate%20.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

enum Environment { development, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  static Future<void> initialize(Environment env) async {
    _environment = env;
    final filename = _getEnvFileName();
    try {
      await dotenv.load(fileName: filename);
    } catch (e) {
      debugPrint('Error loading environment file $filename: $e');
      rethrow;
    }
  }

  static String _getEnvFileName() {
    switch (_environment) {
      case Environment.development:
        return '.env.development';
      case Environment.production:
        return '.env.production';
    }
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
}

Future<String> _determineInitialRoute() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) return AppRoutes.home;

    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    return hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
  } catch (e) {
    debugPrint('Error determining initial route: $e');
    return AppRoutes.onboarding;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    if (kDebugMode) return ErrorWidget(errorDetails.exception);

    if (errorDetails.exception
        .toString()
        .contains('_lifecycleState != _ElementLifecycle.defunct')) {
      debugPrint(
          'Gracefully handling defunct lifecycle error: ${errorDetails.exception}');
      return const SizedBox.shrink();
    }

    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Something went wrong.',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      ),
    );
  };

  try {
    const envName = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    const environment = envName == 'production'
        ? Environment.production
        : Environment.development;

    await Future.wait([
      EnvironmentConfig.initialize(environment),
      initHiveForFlutter(),
    ]);

    final client = GraphQLConfiguration.initializeClient();
    final initialRoute = await _determineInitialRoute();

    runApp(
      ProviderScope(
        child: MyApp(
          client: client,
          initialRoute: initialRoute,
        ),
      ),
    );
  } catch (e) {
    runApp(ErrorApp(error: e));
  }
}

class ErrorApp extends StatelessWidget {
  final Object error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Initialization Error'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to initialize the app:\n$error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    main();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  final ValueNotifier<GraphQLClient> client;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.client,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the locale provider to rebuild when locale changes
    final currentLocale = ref.watch(localeProvider);

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'FireSecure360',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: EnvironmentConfig.isDevelopment,

        // Set the locale from the provider
        locale: currentLocale,

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MaterialLocalizationsDelegate(),
          KinyarwandaCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.supportedLocales,
        routes: AppRoutes.getRoutes(),
        initialRoute: initialRoute,
        onUnknownRoute: AppRoutes.unknownRoute,
      ),
    );
  }
}
