import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Use HookConsumerWidget
class CustomBottomNav extends HookConsumerWidget {
  final String? userRole;
  static String currentLabel = 'Home';

  const CustomBottomNav({
    super.key,
    this.userRole,
  });

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'rw':
        return 'Kinyarwanda';
      default:
        return code.toUpperCase();
    }
  }

  void _showLanguageSelectionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  S.of(context).selectLanguageTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...S.supportedLocales.map((locale) {
                return ListTile(
                  title: Text(_getLanguageName(locale.languageCode)),
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(localeProvider.notifier).setLocale(locale);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  // Build method for HookConsumerWidget
  Widget build(BuildContext context, WidgetRef ref) {
    // Now you can use hooks AND access ref
    String initialLabel = CustomBottomNav.currentLabel;
    if (!['Home', 'Profile', 'Language'].contains(initialLabel)) {
      initialLabel = 'Home';
      CustomBottomNav.currentLabel = 'Home';
    }

    final selectedLabel = useState(initialLabel); // You can still use useState
    final navigatorState = Navigator.of(context);
    final l10n = S.of(context)!;

    void handleNavigation(String label) {
      selectedLabel.value = label; // Update hook state
      CustomBottomNav.currentLabel =
          label; // Keep static updated if needed elsewhere

      switch (label) {
        case 'Home':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
            navigatorState.pushReplacementNamed(AppRoutes.home);
          }
          break;
        case 'Profile':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
            navigatorState.pushReplacementNamed(AppRoutes.profile);
          }
          break;
        case 'Language':
          _showLanguageSelectionModal(context, ref); // Pass ref to modal
          // Do not change the selected label state for the modal
          break;
      }
    }

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: l10n.bottomNavHome,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: l10n.bottomNavProfile,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.language_outlined),
        activeIcon: const Icon(Icons.language),
        label: l10n.bottomNavLanguage,
      ),
    ];

    final currentIndex =
        ['Home', 'Profile', 'Language'].indexOf(selectedLabel.value);

    return Material(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              final tappedLabel = ['Home', 'Profile', 'Language'][index];
              handleNavigation(tappedLabel);
            },
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey.shade600,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: items,
          ),
        ),
      ),
    );
  }
}
