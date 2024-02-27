import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/category/manager/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  bool loading = true;
  List<Recipe> recipes = [];

  Future<void> getCategory({required String categoryId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .where('categoryId', isEqualTo: categoryId)
          .get()
          .then((value) {
        recipes.clear();
        for (var document in value.docs) {
          final recipe = Recipe.fromMap(document.data());
          recipes.add(recipe);
        }
      });
      loading = false;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(GetCategorySuccess());
        },
      );
    } catch (error) {
      emit(GetCategoryFailure('Failed to get category'));
    }
  }
}
