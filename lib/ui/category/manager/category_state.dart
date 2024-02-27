abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class GetCategorySuccess extends CategoryState {}

class GetCategoryFailure extends CategoryState {
  final String errorMessage;

  GetCategoryFailure(this.errorMessage);
}
