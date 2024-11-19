import 'package:anota_cep/src/core/ui/theme/app_colors.dart';
import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;

  const SearchBarCustom({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: 'Buscar',
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.gray,
        ),
        hintStyle: AppTextStyles.primaryMedium.copyWith(
          color: AppColors.gray,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onSubmitted,
    );
  }
}
