import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavigationActions {
  final Function(String) navigateTo;
  final Function(String) navigateAndReplace;
  final Function(String) navigateAndRemoveUntil;
  final Function() goBack;

  NavigationActions({
    required this.navigateTo,
    required this.navigateAndReplace,
    required this.navigateAndRemoveUntil,
    required this.goBack,
  });
}

NavigationActions useNavigation() {
  final context = useContext();

  return NavigationActions(
    navigateTo: (String route) => AppRoutes.navigateTo(context, route),
    navigateAndReplace: (String route) =>
        AppRoutes.navigateToReplacement(context, route),
    navigateAndRemoveUntil: (String route) =>
        AppRoutes.navigateAndRemoveUntil(context, route),
    goBack: () => Navigator.pop(context),
  );
}
