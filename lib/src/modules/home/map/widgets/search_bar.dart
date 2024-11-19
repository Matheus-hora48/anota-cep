import 'package:anota_cep/src/core/ui/helpers/debouncer.dart';
import 'package:anota_cep/src/core/ui/theme/app_colors.dart';
import 'package:anota_cep/src/core/ui/theme/app_text_styles.dart';
import 'package:anota_cep/src/core/ui/widgets/search_bar_widget.dart';
import 'package:anota_cep/src/models/location_model.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_bloc.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_event.dart';
import 'package:anota_cep/src/modules/home/map/blocs/map_state.dart';
import 'package:anota_cep/src/modules/home/map/widgets/bottom_sheet_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<bool> onTextChange;
  final MapBloc bloc;

  const SearchBarWidget({
    super.key,
    required this.bloc,
    required this.onTextChange,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        final hasTextNow = searchController.text.isNotEmpty;
        if (hasText != hasTextNow) {
          hasText = hasTextNow;
          widget.onTextChange(hasText);
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showLocationModal(
    BuildContext context,
    LocationModel location,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BottomSheetDialog(location: location);
      },
    ).then((_) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            searchController.text = '';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<MapState>(
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
                    _showLocationModal(
                      context,
                      location,
                    );
                  }
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                            widget.bloc.inputMap.add(
                              FetchSuggestionsEvent(value),
                            );
                          }
                        });
                      },
                      onClean: () {
                        setState(() {
                          widget.bloc.inputMap.add(ClearSuggestionsEvent());
                        });
                      },
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          widget.bloc.inputMap.add(
                            SearchLocationEvent(value),
                          );
                          widget.onTextChange(false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state is SuggestionsLoaded)
                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                              if (state is MapLoaded) {
                                widget.onTextChange(false);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  if (state is MapError)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (hasText)
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  widget.bloc.inputMap.add(
                    SearchLocationEvent(searchController.text),
                  );
                  widget.onTextChange(false);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
