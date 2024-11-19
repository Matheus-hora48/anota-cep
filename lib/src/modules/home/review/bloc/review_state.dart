abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoader extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String message;

  ReviewSuccess(this.message);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}
