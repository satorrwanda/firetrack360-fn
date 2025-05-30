import 'package:firetrack360/providers/notification_provider.dart' as notif;
import 'package:firetrack360/ui/pages/admin/service_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firetrack360/generated/l10n.dart';

Widget buildSmallScreenPagination(
  BuildContext context,
  WidgetRef ref,
  int currentPage,
  int totalPages,
  int pageSize,
  int startIndex,
  int endIndex,
  int totalItems,
  S l10n,
) {
  final textColor = Theme.of(context).textTheme.bodyMedium?.color;
  final secondaryTextColor =
      Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);
  final primaryColor = Theme.of(context).primaryColor;
  final disabledColor = Theme.of(context).disabledColor;
  final cardColor = Theme.of(context).cardColor;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.showingRecords(startIndex + 1, endIndex, totalItems, pageSize),
            style: TextStyle(color: secondaryTextColor),
          ),
          Row(
            children: [
              Text(
                l10n.rowsLabel,
                style: TextStyle(color: secondaryTextColor),
              ),
              DropdownButton<int>(
                value: pageSize,
                underline: Container(),
                isDense: true,
                items: [5, 10, 15, 20].map((size) {
                  return DropdownMenuItem<int>(
                    value: size,
                    child: Text('$size', style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(pageSizeProvider.notifier).state = value;
                    ref.read(notif.currentPageProvider.notifier).state = 0;
                  }
                },
                dropdownColor: cardColor,
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.first_page,
                size: 20,
                color: currentPage > 0 ? primaryColor : disabledColor),
            onPressed: currentPage > 0
                ? () {
                    ref.read(currentPageProvider.notifier).state = 0;
                  }
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.chevron_left,
                size: 20,
                color: currentPage > 0 ? primaryColor : disabledColor),
            onPressed: currentPage > 0
                ? () {
                    ref.read(notif.currentPageProvider.notifier).state =
                        currentPage - 1;
                  }
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${currentPage + 1}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.chevron_right,
                size: 20,
                color: currentPage < totalPages - 1
                    ? primaryColor
                    : disabledColor),
            onPressed: currentPage < totalPages - 1
                ? () {
                    ref.read(notif.currentPageProvider.notifier).state =
                        currentPage + 1;
                  }
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.last_page,
                size: 20,
                color: currentPage < totalPages - 1
                    ? primaryColor
                    : disabledColor),
            onPressed: currentPage < totalPages - 1
                ? () {
                    ref.read(notif.currentPageProvider.notifier).state =
                        totalPages - 1;
                  }
                : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    ],
  );
}

Widget buildRegularPagination(
  BuildContext context,
  WidgetRef ref,
  int currentPage,
  int totalPages,
  int pageSize,
  int startIndex,
  int endIndex,
  int totalItems,
  S l10n,
) {
  final textColor = Theme.of(context).textTheme.bodyMedium?.color;
  final secondaryTextColor =
      Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);
  final primaryColor = Theme.of(context).primaryColor;
  final disabledColor = Theme.of(context).disabledColor;
  final cardColor = Theme.of(context).cardColor;

  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          l10n.showingRecords(startIndex + 1, endIndex, totalItems, pageSize),
          style: TextStyle(color: secondaryTextColor),
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.rowsPerPageLabel,
              style: TextStyle(color: secondaryTextColor),
            ),
            DropdownButton<int>(
              value: pageSize,
              underline: Container(),
              items: [5, 10, 15, 20].map((size) {
                return DropdownMenuItem<int>(
                  value: size,
                  child: Text('$size', style: TextStyle(color: textColor)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(pageSizeProvider.notifier).state = value;
                  ref.read(currentPageProvider.notifier).state = 0;
                }
              },
              dropdownColor: cardColor,
            ),
          ],
        ),
      ),
      Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.first_page,
                  color: currentPage > 0 ? primaryColor : disabledColor),
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  : null,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(Icons.chevron_left,
                  color: currentPage > 0 ? primaryColor : disabledColor),
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage - 1;
                    }
                  : null,
              visualDensity: VisualDensity.compact,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentPage + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right,
                  color: currentPage < totalPages - 1
                      ? primaryColor
                      : disabledColor),
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage + 1;
                    }
                  : null,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: Icon(Icons.last_page,
                  color: currentPage < totalPages - 1
                      ? primaryColor
                      : disabledColor),
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          totalPages - 1;
                    }
                  : null,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    ],
  );
}
