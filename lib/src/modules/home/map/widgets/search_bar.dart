import 'package:anota_cep/src/core/ui/helpers/debouncer.dart';
import 'package:anota_cep/src/core/ui/theme/app_colors.dart';
import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:anota_cep/src/core/ui/widgets/search_bar_widget.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_event.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_state.dart';
import 'package:anota_cep/src/modules/home/map/widgets/bottom_sheet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';

class SearchBarWidget extends StatefulWidget {
  final MapBloc bloc;

  const SearchBarWidget({
    super.key,
    required this.bloc,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final Debouncer debouncer = Debouncer(milliseconds: 500);

    return StreamBuilder<MapState>(
      stream: widget.bloc.stream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state is MapLoaded) {
          final location = state.location;

          if (location != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.bloc.inputMap.add(
                AddMarkerEvent(
                  zipCode: location.zipCode,
                  latitude: double.parse(location.lat ?? ''),
                  longitude: double.parse(location.lng ?? ''),
                ),
              );

              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return BottomSheetDialog(
                      location: location,
                    );
                  },
                ).then((_) => searchController.text = '');
              }
            });
          }
        }

        return Column(
          children: [
            Material(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              child: SearchBarCustom(
                controller: searchController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
                onChanged: (value) {
                  debouncer(() {
                    if (value.isNotEmpty) {
                      widget.bloc.inputMap.add(FetchSuggestionsEvent(value));
                    } else {
                      widget.bloc.inputMap.add(ClearSuggestionsEvent());
                    }
                  });
                },
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    widget.bloc.inputMap.add(
                      SearchLocationEvent(value),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            if (state is SuggestionsLoaded)
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.suggestions.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final suggestion = state.suggestions[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          suggestion.address,
                          style: AppTextStyles.primaryMedium,
                        ),
                        subtitle: Text(
                          suggestion.zipCode,
                          style: AppTextStyles.secondary,
                        ),
                        onTap: () {
                          searchController.text = suggestion.zipCode;
                          widget.bloc.inputMap.add(
                            SearchLocationEvent(suggestion.zipCode),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            if (state is MapError)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
