import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/recipe/manager/recipe_cubit.dart';
import 'package:cookpal/ui/recipe/manager/recipe_state.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final cubit = RecipeCubit();

  @override
  void initState() {
    super.initState();
    cubit.getRecipe(widget.recipe);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<RecipeCubit, RecipeState>(
        listener: (context, state) {
          if (state is GetRecipeFailure) {
            displayToast(state.errorMessage);
          }
        },
        buildWhen: (previous, current) => current is GetRecipeSuccess,
        builder: (context, state) {
          return Scaffold(
            body: cubit.loading
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                    ),
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 85.sp,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/background.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Image.network(
                              widget.recipe.image,
                              width: 70.sp,
                              height: 70.sp,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 20.sp,
                              left: 0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.grey[400],
                                  size: 22.sp,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: BlocBuilder<RecipeCubit, RecipeState>(
                                buildWhen: (previous, current) =>
                                    current is FavoriteChange,
                                builder: (context, state) {
                                  return IconButton(
                                    onPressed: () {
                                      if (cubit.favorite) {
                                        cubit.removeFavorite(widget.recipe);
                                      } else {
                                        cubit.addFavorite(widget.recipe);
                                      }
                                      cubit.favorite = !cubit.favorite;
                                      cubit.onFavoriteChange();
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      cubit.favorite
                                          ? Icons.bookmark
                                          : Icons.bookmark_border_outlined,
                                      color: primaryIconColor,
                                      size: 22.sp,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.recipe.name,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'playFairDisplay',
                              ),
                            ),
                            Text(
                              widget.recipe.description,
                              style: TextStyle(
                                height: 5.5.sp,
                                color: Colors.grey[500],
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 15.sp),
                            Row(
                              children: [
                                const Icon(
                                  Icons.watch_later_outlined,
                                  color: primaryIconColor,
                                ),
                                SizedBox(width: 10.sp),
                                Text(
                                  widget.recipe.time,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10.sp),
                                const Icon(
                                  FontAwesomeIcons.kitchenSet,
                                  color: primaryIconColor,
                                ),
                                SizedBox(width: 10.sp),
                                Text(
                                  widget.recipe.level,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'playFairDisplay',
                              ),
                            ),
                            SizedBox(height: 20.sp),
                            ingredientItemBuilder(),
                            SizedBox(height: 20.sp),
                            Text(
                              'Instructions',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'playFairDisplay',
                              ),
                            ),
                            Text(
                              widget.recipe.instructions,
                              style: TextStyle(
                                height: 5.5.sp,
                                color: Colors.grey[500],
                                fontSize: 17.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget ingredientItemBuilder() {
    return SizedBox(
      height: 45.sp,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cubit.ingredients.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 55.sp,
            margin: EdgeInsets.only(right: 10.sp),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.sp),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Image.network(
                    cubit.ingredients[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.all(18.sp),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.sp),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(16, 57, 95, 0.8),
                        ],
                      ),
                    ),
                    child: Text(
                      cubit.ingredients[index].name,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
