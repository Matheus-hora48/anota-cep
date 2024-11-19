abstract class PassbookEvent {}

class LoadLocations extends PassbookEvent {}

class DeleteLocation extends PassbookEvent {
  final int id;

  DeleteLocation({required this.id});
}

class FilterLocations extends PassbookEvent {
  final String searchQuery;

  FilterLocations({required this.searchQuery});
}
