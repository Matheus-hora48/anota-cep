import 'package:anota_cep/src/core/ui/theme/app_colors.dart';
import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final VoidCallback? onClean;
  final String? Function(String? value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? erroText;

  const SearchBarCustom({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onClean,
    this.validator,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.erroText,
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
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.gray,
                ),
                onPressed: () {
                  if (onClean != null) {
                    onClean!();
                  }

                  controller.clear();
                  if (onChanged != null) {
                    onChanged!('');
                  }
                },
              )
            : null,
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
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
        errorText: erroText,
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onSubmitted,
    );
  }
}
