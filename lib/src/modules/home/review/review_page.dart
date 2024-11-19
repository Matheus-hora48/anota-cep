import 'package:anota_cep/src/core/ui/theme/app_colors.dart';
import 'package:anota_cep/src/modules/home/review/bloc/review_bloc.dart';
import 'package:anota_cep/src/modules/home/review/bloc/review_event.dart';
import 'package:anota_cep/src/modules/home/review/bloc/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Injector.get<ReviewBloc>();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final cep = args['cep'] ?? '';
    final address = args['address'] ?? '';

    var textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontSize: 20,
    );

    final zipCodeEC = TextEditingController(text: cep);
    final addressEC = TextEditingController(text: address);
    final numberEC = TextEditingController();
    final complementEC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisão'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'CEP'),
              controller: zipCodeEC,
              style: textStyle.copyWith(color: AppColors.gray),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Endereço'),
              controller: addressEC,
              style: textStyle.copyWith(color: AppColors.gray),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Número'),
              controller: numberEC,
              style: textStyle,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Complemento'),
              controller: complementEC,
              style: textStyle,
            ),
            const Spacer(),
            StreamBuilder<ReviewState>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state is ReviewError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final scaffold = ScaffoldMessenger.of(context);
                      try {
                        bloc.inputReview.add(SaveReviewEvent(
                          cep: zipCodeEC.text,
                          address: addressEC.text,
                          number: numberEC.text,
                          complement: complementEC.text,
                        ));
                        scaffold.showSnackBar(
                          const SnackBar(
                            content: Text('Local foi salvo com sucesso!'),
                          ),
                        );
                        nav.pop();
                      } catch (e) {
                        scaffold.showSnackBar(
                          SnackBar(content: Text('Erro ao salvar o local: $e')),
                        );
                      }
                    },
                    child: const Text('Confirmar'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
