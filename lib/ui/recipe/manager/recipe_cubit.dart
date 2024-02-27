import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/model/app_user.dart';
import 'package:cookpal/model/ingredient.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/recipe/manager/recipe_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit() : super(RecipeInitial());
  bool loading = true;
  bool favorite = false;
  List<dynamic> ingredients = [];

  Future<void> getRecipe(Recipe recipe) async {
    try {
      ingredients.clear();
      for (int i = 0; i < recipe.ingredientsId.length; i++) {
        await FirebaseFirestore.instance
            .collection('ingredients')
            .where('ingredientId', isEqualTo: recipe.ingredientsId[i])
            .get()
            .then((value) {
          for (var document in value.docs) {
            final ingredient = Ingredient.fromMap(document.data());
            ingredients.add(ingredient);
          }
        });
      }
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        final user = AppUser.fromMap(value.data()!);
        for (var element in user.favoriteRecipesId) {
          if (recipe.recipeId == element) {
            favorite = true;
          }
        }
      });
      loading = false;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(GetRecipeSuccess());
        },
      );
    } catch (error) {
      emit(GetRecipeFailure('Failed to get recipe'));
    }
  }

  void addFavorite(Recipe recipe) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favoriteRecipesId': FieldValue.arrayUnion([recipe.recipeId]),
    });
  }

  void removeFavorite(Recipe recipe) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favoriteRecipesId': FieldValue.arrayRemove([recipe.recipeId]),
    });
  }

  void onFavoriteChange() => emit(FavoriteChange());
}
