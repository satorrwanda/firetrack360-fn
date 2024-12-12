import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActivationCodeInput extends StatelessWidget {
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final List<TextEditingController> controllers;

  const ActivationCodeInput({
    super.key,
    required this.controllers,
    this.onCompleted,
    this.onChanged,
  });

  Widget _buildTextField(BuildContext context, int index, double fieldSize) {
    return Container(
      height: fieldSize,
      width: fieldSize,
      child: TextField(
        controller: controllers[index],
        autofocus: index == 0,
        onChanged: (value) {
          if (value.length == 1 && index < controllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
          if (onChanged != null) {
            onChanged!(controllers.map((c) => c.text).join());
          }
          // Check if all fields are filled
          if (controllers.every((controller) => controller.text.isNotEmpty)) {
            if (onCompleted != null) {
              onCompleted!(controllers.map((c) => c.text).join());
            }
          }
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fieldSize * 0.4, // Responsive font size
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          counter: const Offstage(),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2, 
              color: Colors.white.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2, 
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.1; 
    final availableWidth = screenWidth - (horizontalPadding * 2);
    final spaceBetweenFields = availableWidth * 0.05; 
    final totalSpacing = spaceBetweenFields * (controllers.length - 1);
    final fieldSize = (availableWidth - totalSpacing) / controllers.length;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          controllers.length,
          (index) => _buildTextField(context, index, fieldSize),
        ),
      ),
    );
  }
}