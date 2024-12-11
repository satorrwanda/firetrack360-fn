import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActivationCodeInput extends StatelessWidget {
  final List<TextEditingController> controllers;

  const ActivationCodeInput({
    super.key,
    required this.controllers, required BuildContext context,
  });

  Future<void> _handlePaste(BuildContext context) async {
    try {
      // Get clipboard data
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text == null) return;

      // Extract only digits from pasted text
      final digits = clipboardData!.text!.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return;

      // Take only the first 6 digits
      final validCode = digits.substring(0, digits.length > 6 ? 6 : digits.length);

      // Distribute digits across controllers
      for (int i = 0; i < controllers.length; i++) {
        if (i < validCode.length) {
          controllers[i].text = validCode[i];
        } else {
          controllers[i].clear();
        }
      }

      // Move focus to the next available field
      for (int i = 0; i < validCode.length; i++) {
        if (i < controllers.length - 1) {
          FocusScope.of(context).nextFocus();
        }
      }
    } catch (e) {
      debugPrint('Paste error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          child: GestureDetector(
            onLongPress: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(0, 0, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const Text('Paste'),
                    onTap: () => _handlePaste(context),
                  ),
                ],
              );
            },
            child: Focus(
              child: TextField(
                controller: controllers[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
