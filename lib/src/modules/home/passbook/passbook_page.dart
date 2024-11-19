import 'package:anota_cep/src/core/ui/widgets/search_bar_widget.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_bloc.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_event.dart';
import 'package:anota_cep/src/modules/home/passbook/bloc/passbook_state.dart';
import 'package:anota_cep/src/modules/home/passbook/widgets/location_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class PassbookPage extends StatefulWidget {
  const PassbookPage({super.key});

  @override
  State<PassbookPage> createState() => _PassbookPageState();
}

class _PassbookPageState extends State<PassbookPage> {
  final searchController = TextEditingController();
  final bloc = Injector.get<PassbookBloc>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.inputReview.add(LoadLocations());
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Material(
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                child: SearchBarCustom(
                  controller: searchController,
                  onChanged: (query) {
                    bloc.inputReview.add(
                      FilterLocations(searchQuery: query),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<PassbookState>(
                  stream: bloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data is PassbookLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data is PassbookErrorState) {
                      return Center(
                        child: Text(
                          'Erro: ${(snapshot.data as PassbookErrorState).errorMessage}',
                        ),
                      );
                    }

                    if (snapshot.data is PassbookLoadedState ||
                        snapshot.data is PassbookFilteredState) {
                      final locations = (snapshot.data is PassbookFilteredState)
                          ? (snapshot.data as PassbookFilteredState)
                              .filteredLocations
                          : (snapshot.data as PassbookLoadedState).locations;

                      if (locations.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma localização encontrada.'),
                        );
                      }

                      return ListView.separated(
                        itemCount: locations.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final location = locations[index];

                          return LocationCard(
                            location: location,
                            bloc: bloc,
                          );
                        },
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
