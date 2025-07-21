import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpal/database/shared_preferences.dart';
import 'package:cookpal/model/app_user.dart';
import 'package:cookpal/model/category.dart';
import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/home/manager/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
  String? recipeId;

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

  void handleDynamicLinks() async {
    await getHome();
    // Handle the link that opened the app
    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    _processDynamicLink(data);

    // Handle dynamic links while the app is running
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? data) {
      _processDynamicLink(data);
    }).onError((error) {
      emit(LinkHandledFailure('Failed to handle dynamic link'));
    });
  }

  /// Process the deep link and navigate to the recipe screen
  void _processDynamicLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      // Check if the link matches the expected pattern
      if (deepLink.host == 'www.cookpal.com') {
        recipeId =
        deepLink.pathSegments.isNotEmpty ? deepLink.pathSegments[0] : null;
        if (recipeId != null){
          emit(LinkHandledSuccess());
        }
      }
    }
  }

  void onThemeChange() => emit(ThemeChange());
}
