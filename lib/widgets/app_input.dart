import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label wajib diisi';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: icon != null
                ? Icon(icon, size: 20, color: Colors.grey.shade600)
                : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
