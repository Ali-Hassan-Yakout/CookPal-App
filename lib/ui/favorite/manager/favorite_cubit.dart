import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/model/app_user.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/favorite/manager/favorite_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());
  bool loading = true;
  List<dynamic> favoriteRecipesId = [];
  List<Recipe> recipes = [];

  Future<void> getFavorite() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        final user = AppUser.fromMap(value.data()!);
        favoriteRecipesId = user.favoriteRecipesId;
      });
      recipes.clear();
      for (var element in favoriteRecipesId) {
        await FirebaseFirestore.instance
            .collection('recipes')
            .where('recipeId', isEqualTo: element)
            .get()
            .then((value) {
          for (var document in value.docs) {
            final recipe = Recipe.fromMap(document.data());
            recipes.add(recipe);
          }
        });
      }
      loading = false;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(GetFavoriteSuccess());
        },
      );
    } catch (error) {
      emit(GetFavoriteFailure('Failed to get favorites'));
    }
  }
}
