import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/generated/l10n.dart';

class ServiceRequestDetailsDialog extends StatelessWidget {
  const ServiceRequestDetailsDialog({
    Key? key,
    required this.request,
    required this.l10n,
  }) : super(key: key);

  final dynamic request;
  final S l10n;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final dividerColor = Theme.of(context).dividerColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        color: cardBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.serviceRequestDetailsTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textColor.withOpacity(0.7)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoSection(
                l10n.requestInformationTitle,
                [
                  _buildInfoRow(l10n.titleLabel, request.title, context,
                      textColor, secondaryTextColor, dividerColor),
                  _buildInfoRow(
                      l10n.statusLabel,
                      _localizeStatus(request.status, l10n),
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                  _buildInfoRow(
                      l10n.dateLabel,
                      DateFormat('MMM dd, yyyy').format(request.requestDate),
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                  _buildInfoRow(l10n.descriptionLabel, request.description,
                      context, textColor, secondaryTextColor, dividerColor),
                ],
                context,
                textColor,
                primaryColor,
                dividerColor,
                isDarkMode),
            const SizedBox(height: 16),
            _buildInfoSection(
                l10n.clientInformationTitle,
                [
                  _buildInfoRow(
                      l10n.emailLabel,
                      request.client?.email ?? l10n.notAvailable,
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                  _buildInfoRow(
                      l10n.phoneLabel,
                      request.client?.phone ?? l10n.notAvailable,
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                ],
                context,
                textColor,
                primaryColor,
                dividerColor,
                isDarkMode),
            const SizedBox(height: 16),
            _buildInfoSection(
                l10n.technicianInformationTitle,
                [
                  _buildInfoRow(
                      l10n.emailLabel,
                      request.technician?.email ?? l10n.notAvailable,
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                  _buildInfoRow(
                      l10n.phoneLabel,
                      request.technician?.phone ?? l10n.notAvailable,
                      context,
                      textColor,
                      secondaryTextColor,
                      dividerColor),
                ],
                context,
                textColor,
                primaryColor,
                dividerColor,
                isDarkMode),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: onPrimaryColor,
                    backgroundColor: primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.closeButton),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      String title,
      List<Widget> rows,
      BuildContext context,
      Color textColor,
      Color primaryColor,
      Color dividerColor,
      bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context,
      Color textColor, Color secondaryTextColor, Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  String _localizeStatus(String status, S l10n) {
    switch (status.toLowerCase()) {
      case 'pending':
        return l10n.statusPending;
      case 'in progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }
}
