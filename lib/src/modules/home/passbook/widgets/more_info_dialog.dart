import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_bloc.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_event.dart';
import 'package:flutter/material.dart';

class MoreInfoDialog extends StatelessWidget {
  final LocationModel location;
  final PassbookBloc bloc;

  const MoreInfoDialog({
    super.key,
    required this.location,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        location.address,
        style: AppTextStyles.primaryMedium,
      ),
      content: Text(
        'CEP: ${location.zipCode}\n'
        'Endereço: ${location.address}\n'
        'Número: ${location.number}\n'
        'Complemento: ${location.complement}',
        style: AppTextStyles.secondary,
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            final nav = Navigator.of(context);
            bloc.inputReview.add(DeleteLocation(id: location.id ?? 0));
            bloc.inputReview.add(LoadLocations());
            nav.pop();
          },
          label: const Text('Deletar'),
          icon: const Icon(Icons.delete_rounded),
        ),
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          label: const Text('Fechar'),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
