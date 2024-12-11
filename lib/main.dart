import 'dart:async';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env").catchError((error) {
      debugPrint("Error loading .env file: $error");
    });

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
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.getRoutes(),
        initialRoute: AppRoutes.onboarding,
        onUnknownRoute: AppRoutes.unknownRoute,
      ),
    );
  }
}