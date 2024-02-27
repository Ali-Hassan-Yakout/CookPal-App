import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/search/manager/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  List<Recipe> recipes = [];

  Future<void> search(String searchValue) async {
    try {
      await FirebaseFirestore.instance.collection('recipes').get().then((value) {
        recipes.clear();
        for (var document in value.docs) {
          final recipe = Recipe.fromMap(document.data());
          if (recipe.name.startsWith(searchValue) && searchValue != '') {
            recipes.add(recipe);
          }
        }
      });
      emit(SearchSuccess());
    } catch (error) {
      emit(SearchFailure('Failed to get search result'));
    }
  }
}
