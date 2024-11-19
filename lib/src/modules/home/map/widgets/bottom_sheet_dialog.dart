import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';

class BottomSheetDialog extends StatelessWidget {
  final LocationModel location;

  const BottomSheetDialog({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            UtilBrasilFields.obterCep(location.zipCode),
            style: AppTextStyles.primaryLarge,
          ),
          const SizedBox(height: 16),
          Text(
            location.address,
            style: AppTextStyles.secondary,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/home/review', arguments: {
                  'cep': location.zipCode,
                  'address': location.address
                });
              },
              child: const Text('Salvar endereço'),
            ),
          ),
        ],
      ),
    );
  }
}
