abstract class RecipeState {}

class RecipeInitial extends RecipeState {}
class GetRecipeSuccess extends RecipeState {}
class GetRecipeFailure extends RecipeState {
  final String errorMessage;

  GetRecipeFailure(this.errorMessage);
}
class FavoriteChange extends RecipeState {}
