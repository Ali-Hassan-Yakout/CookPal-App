import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/database/shared_preferences.dart';
import 'package:cookpal/model/app_user.dart';
import 'package:cookpal/model/category.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/home/manager/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  AppUser user = AppUser(
    email: '',
    favoriteRecipesId: [],
    userId: '',
    userName: '',
  );
  bool loading = true;
  List<Category> categories = [];
  List<Recipe> recipes = [];
  List<Recipe> discover = [];

  Future<void> getHome() async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .get()
          .then((value) {
        recipes.clear();
        discover.clear();
        for (var document in value.docs) {
          final recipe = Recipe.fromMap(document.data());
          recipes.add(recipe);
          if (recipe.discover) {
            discover.add(recipe);
          }
        }
      });
      await FirebaseFirestore.instance
          .collection('categories')
          .get()
          .then((value) {
        categories.clear();
        for (var document in value.docs) {
          final category = Category.fromMap(document.data());
          categories.add(category);
        }
      });
      loading = false;
      emit(GetHomeSuccess());
    } catch (error) {
      emit(GetHomeFailure('Failed to get home'));
    }
  }

  Future<void> getUser() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        final user = AppUser.fromMap(value.data()!);
        this.user = user;
      });
      emit(GetUserSuccess());
    } catch (error) {
      emit(GetHomeFailure('Failed to get user data'));
    }
  }

  void logOut() {
    try {
      FirebaseAuth.instance.signOut();
      PreferenceUtils.setBool(PrefKeys.isLoggedIn, false);
      emit(LogOutSuccess());
    } catch (error) {
      emit(LogOutFailure('Failed to logout'));
    }
  }

  void onThemeChange() => emit(ThemeChange());
}
