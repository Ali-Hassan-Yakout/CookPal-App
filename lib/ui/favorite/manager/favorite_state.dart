abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class GetFavoriteSuccess extends FavoriteState {}

class GetFavoriteFailure extends FavoriteState {
  final String errorMessage;

  GetFavoriteFailure(this.errorMessage);
}
