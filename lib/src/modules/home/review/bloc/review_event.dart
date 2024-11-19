abstract class ReviewEvent {}

class SaveReviewEvent extends ReviewEvent {
  final String cep;
  final String address;
  final String number;
  final String complement;

  SaveReviewEvent({
    required this.cep,
    required this.address,
    required this.number,
    required this.complement,
  });
}
