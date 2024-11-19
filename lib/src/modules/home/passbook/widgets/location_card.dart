import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_bloc.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

import 'more_info_dialog.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final PassbookBloc bloc;

  const LocationCard({
    super.key,
    required this.location,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        UtilBrasilFields.obterCep(location.zipCode),
        style: AppTextStyles.primaryMedium,
      ),
      subtitle: Text(
        location.address,
        style: AppTextStyles.secondary,
        overflow: TextOverflow.clip,
        maxLines: 1,
      ),
      trailing: Icon(
        Icons.bookmark,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => MoreInfoDialog(
            bloc: bloc,
            location: location,
          ),
        );
      },
    );
  }
}
