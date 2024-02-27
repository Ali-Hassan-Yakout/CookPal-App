abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchFailure extends SearchState {
  final String errorMessage;

  SearchFailure(this.errorMessage);
}
