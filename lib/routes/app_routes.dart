import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/screens/screens.dart';

class AppRoutes {
  const AppRoutes._();

  // Auth Routes
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String activateAccount = '/activate-account';
  static const String verifyLogin = '/verify-login';
  static const String verifyPasswordReset = '/verify-password-reset';
  static const String resetPassword = '/reset-password';

  // Main App Routes
  static const String home = '/home';
  static const String analytics = '/analytics';
  static const String profile = '/profile';

  // Admin Routes
  static const String userManagement = '/user-management';
  static const String serviceRequests = '/service-requests';
  static const String inventory = '/inventory';
  static const String finance = '/finance';

  // Manager Routes
  static const String technicianManagement = '/technician-management';
  static const String taskAssignment = '/task-assignment';
  static const String locationTracking = '/location-tracking';
  static const String serviceFeedback = '/service-feedback';
  static const String stockManagement = '/stock-management';

  // Technician Routes
  static const String myTasks = '/my-tasks';
  static const String navigation = '/navigation';
  static const String serviceHistory = '/service-history';
  static const String offlineMode = '/offline-mode';
  static const String customerFeedback = '/customer-feedback';

  // Client Routes
  static const String dashboard = '/dashboard';
  static const String myExtinguishers = '/my-extinguishers';
  static const String requestService = '/request-service';
  static const String payments = '/payments';
  static const String support = '/support';
  static const String safetyTips = '/safety-tips';

  // common routes
  static const String settings = '/settings';
  static const String notification = '/notification';

  static const String _onboardingKey = 'isOnboardingDone';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      // Auth routes
      onboarding: (_) => const OnboardingPage(),
      login: (_) => const LoginPage(),
      register: (_) => const RegisterPage(),
      forgetPassword: (_) => const ForgetPasswordPage(),
      activateAccount: (_) => const AccountActivationPage(),
      verifyLogin: (_) => const VerifyLoginPage(),
      verifyPasswordReset: (_) => const VerifyPasswordResetPage(),
      resetPassword: (_) => const ResetPasswordPage(),
      // Main app routes
      home: (_) => const HomePage(),
      profile: (_) => ProfileScreen(),

      // Admin routes
      userManagement: (_) => const UserManagementScreen(),
      serviceRequests: (_) => const ServiceRequestsScreen(),
      inventory: (_) => const InventoryScreen(),
      finance: (_) => const FinanceScreen(),
      // Technician routes
      myTasks: (_) => const MyTasksScreen(),
      navigation: (_) => const NavigationScreen(),
      offlineMode: (_) => const OfflineModeScreen(),
      customerFeedback: (_) => const CustomerFeedbackScreen(),

      // Client routes
      dashboard: (_) => const HomePage(),
      myExtinguishers: (_) => const MyExtinguishersScreen(),
      requestService: (_) => const RequestServiceScreen(),
      payments: (_) => const PaymentsScreen(),
      support: (_) => const SupportScreen(),
      safetyTips: (_) => const SafetyTipsScreen(),

      // common routes
      settings: (_) => const SettingsScreen(),
      notification: (_) => const NotificationPage(),
    };
  }

  // Navigation helper methods
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const UnknownRoutePage(),
      settings: settings,
    );
  }

  // Auth navigation methods
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  static void navigateToVerifyPasswordReset(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(verifyPasswordReset);
  }

  static void navigateToResetPassword(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(resetPassword);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(register);
  }

  static void navigateToForgetPassword(BuildContext context) {
    Navigator.of(context).pushNamed(forgetPassword);
  }

  static void navigateToActivateAccount(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(activateAccount);
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(onboarding);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(home);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static void navigateToVerifyLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(verifyLogin);
  }

  static void resetAndNavigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
    );
  }

  static void popUntilRoute(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  static void navigateToAnalytics(BuildContext context) {
    Navigator.of(context).pushNamed(analytics);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(profile);
  }

  // Admin navigation methods
  static void navigateToUserManagement(BuildContext context) {
    Navigator.of(context).pushNamed(userManagement);
  }

  static void navigateToServiceRequests(BuildContext context) {
    Navigator.of(context).pushNamed(serviceRequests);
  }

  static void navigateToInventory(BuildContext context) {
    Navigator.of(context).pushNamed(inventory);
  }

  static void navigateToFinance(BuildContext context) {
    Navigator.of(context).pushNamed(finance);
  }

  // Manager navigation methods
  static void navigateToTechnicianManagement(BuildContext context) {
    Navigator.of(context).pushNamed(technicianManagement);
  }

  static void navigateToTaskAssignment(BuildContext context) {
    Navigator.of(context).pushNamed(taskAssignment);
  }

  static void navigateToLocationTracking(BuildContext context) {
    Navigator.of(context).pushNamed(locationTracking);
  }

  static void navigateToServiceFeedback(BuildContext context) {
    Navigator.of(context).pushNamed(serviceFeedback);
  }

  static void navigateToStockManagement(BuildContext context) {
    Navigator.of(context).pushNamed(stockManagement);
  }

  // Technician navigation methods
  static void navigateToMyTasks(BuildContext context) {
    Navigator.of(context).pushNamed(myTasks);
  }

  static void navigateToTechnicianNavigation(BuildContext context) {
    Navigator.of(context).pushNamed(navigation);
  }

  static void navigateToServiceHistory(BuildContext context) {
    Navigator.of(context).pushNamed(serviceHistory);
  }

  static void navigateToOfflineMode(BuildContext context) {
    Navigator.of(context).pushNamed(offlineMode);
  }

  static void navigateToCustomerFeedback(BuildContext context) {
    Navigator.of(context).pushNamed(customerFeedback);
  }

  // Client navigation methods
  static void navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushNamed(dashboard);
  }

  static void navigateToMyExtinguishers(BuildContext context) {
    Navigator.of(context).pushNamed(myExtinguishers);
  }

  static void navigateToRequestService(BuildContext context) {
    Navigator.of(context).pushNamed(requestService);
  }

  static void navigateToPayments(BuildContext context) {
    Navigator.of(context).pushNamed(payments);
  }

  static void navigateToSupport(BuildContext context) {
    Navigator.of(context).pushNamed(support);
  }

  static void navigateToSafetyTips(BuildContext context) {
    Navigator.of(context).pushNamed(safetyTips);
  }

  // common routes
  static void navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed(settings);
  }
  static void navigateToNotification(BuildContext context) {
    Navigator.of(context).pushNamed(notification);
  }

  // Role-based navigation helper
  static void navigateByRole(
      BuildContext context, String route, String? userRole) {
    if (userRole == null) {
      navigateToLogin(context);
      return;
    }

    if (route.startsWith('/admin') && userRole != 'admin' ||
        route.startsWith('/manager') && userRole != 'manager' ||
        route.startsWith('/technician') && userRole != 'technician' ||
        route.startsWith('/client') && userRole != 'client') {
      Navigator.of(context).pushNamed(route);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const UnauthorizedPage(),
        ),
      );
    }
  }

  // Navigate with animation
  static void navigateWithSlideAnimation(
    BuildContext context,
    String routeName, {
    bool replacement = false,
  }) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        final routes = getRoutes();
        return routes[routeName]!(context);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );

    if (replacement) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  static void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void navigateToReplacement(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  static void navigateAndRemoveUntil(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
