import 'dart:async';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'routes/app_routes.dart';

// Add environment enum
enum Environment { development, production }

// Environment configuration class
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment based on build configuration
    const String envName = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    const environment = envName == 'production'
        ? Environment.production
        : Environment.development;

    await EnvironmentConfig.initialize(environment);
    await initHiveForFlutter();

    final client = GraphQLConfiguration.initializeClient();
    runApp(MyApp(client: client));
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
          child: Text(
            'Failed to initialize the app:\n$error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'FireSecure360',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: EnvironmentConfig.isDevelopment,
        routes: AppRoutes.getRoutes(),
        initialRoute: AppRoutes.onboarding,
        onUnknownRoute: AppRoutes.unknownRoute,
      ),
    );
  }
}
