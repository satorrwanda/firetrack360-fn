import 'dart:async';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    if (token != null) {
      // Optional: Add token validation here
      return AppRoutes.home;
    }
    // Check if user has seen onboarding
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    return hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
  } catch (e) {
    debugPrint('Error determining initial route: $e');
    return AppRoutes.onboarding;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment
    const String envName = String.fromEnvironment(
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

    runApp(MyApp(
      client: client,
      initialRoute: initialRoute,
    ));
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Initialization Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to initialize the app:\n$error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Restart app or retry initialization
                    main();
                  },
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

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.client,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'FireSecure360',
          theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true, // Enable Material 3
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            ),
          ),
          debugShowCheckedModeBanner: EnvironmentConfig.isDevelopment,
          routes: AppRoutes.getRoutes(),
          initialRoute: initialRoute,
          onUnknownRoute: AppRoutes.unknownRoute,
        ),
      ),
    );
  }
}
