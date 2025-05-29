import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final textColor = Theme.of(context).textTheme.bodyMedium?.color;
        final selectedColor = Theme.of(context).colorScheme.primary;
        final dividerColor = Theme.of(context).dividerColor;

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
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                ),
              ),
              Divider(color: dividerColor),
              ListView.builder(
                shrinkWrap: true,
                itemCount: S.supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = S.supportedLocales[index];
                  final isSelected =
                      Localizations.localeOf(context).languageCode ==
                          locale.languageCode;
                  return ListTile(
                    title: Text(
                      _getLanguageName(locale.languageCode),
                      style: TextStyle(
                        color: isSelected ? selectedColor : textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: selectedColor)
                        : null,
                    onTap: () async {
                      Navigator.pop(context);
                      await ref.read(localeProvider.notifier).setLocale(locale);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String initialLabel = CustomBottomNav.currentLabel;
    if (!['Home', 'Profile', 'Language'].contains(initialLabel)) {
      initialLabel = 'Home';
      CustomBottomNav.currentLabel = 'Home';
    }

    final selectedLabel = useState(initialLabel);
    final navigatorState = Navigator.of(context);
    final l10n = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final startColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.deepPurple.shade700;
    final endColor = isDarkMode ? Colors.black : Colors.deepPurple.shade400;

    final selectedLabelColor = isDarkMode ? Colors.white : Colors.white;
    final unselectedLabelColor = isDarkMode ? Colors.white70 : Colors.white70;

    void handleNavigation(String label) {
      selectedLabel.value = label;
      CustomBottomNav.currentLabel = label;

      switch (label) {
        case 'Home':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
            Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
            if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
              navigatorState.pushReplacementNamed(AppRoutes.home);
            }
          }
          break;
        case 'Profile':
          Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
          navigatorState.pushNamed(AppRoutes.profile);
          break;
        case 'Language':
          _showLanguageSelectionModal(context, ref);
          break;
      }
    }

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined, color: Colors.white),
        activeIcon: const Icon(Icons.home, color: Colors.white),
        label: l10n.bottomNavHome,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline, color: Colors.white),
        activeIcon: const Icon(Icons.person, color: Colors.white),
        label: l10n.bottomNavProfile,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.language_outlined, color: Colors.white),
        activeIcon: const Icon(Icons.language, color: Colors.white),
        label: l10n.bottomNavLanguage,
      ),
    ];

    final currentIndex =
        ['Home', 'Profile', 'Language'].indexOf(selectedLabel.value);

    return Material(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              startColor,
              endColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
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
            selectedItemColor: selectedLabelColor,
            unselectedItemColor: unselectedLabelColor,
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
