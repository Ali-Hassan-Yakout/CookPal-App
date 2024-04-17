import 'package:cookpal/model/recipe.dart';
import 'package:cookpal/ui/recipe/manager/recipe_cubit.dart';
import 'package:cookpal/ui/recipe/manager/recipe_state.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:cookpal/utils/determine_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

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
                : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: true,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.grey[400],
                            size: 22.r,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            BlocBuilder<RecipeCubit, RecipeState>(
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
                                    size: 22.r,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        expandedHeight: 250.h,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
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
                                width: 250.w,
                                height: 250.h,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15.h,
                            horizontal: determineMargin() ? 300.w : 15.w,
                          ),
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
                                  height: 1.4.h,
                                  color: Colors.grey[500],
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    color: primaryIconColor,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    widget.recipe.time,
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  const Icon(
                                    FontAwesomeIcons.kitchenSet,
                                    color: primaryIconColor,
                                  ),
                                  SizedBox(width: 10.w),
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
                              SizedBox(height: 20.h),
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'playFairDisplay',
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ingredientItemBuilder(),
                              SizedBox(height: 20.h),
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
                                  height: 1.4.h,
                                  color: Colors.grey[500],
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
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
      height: 120.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cubit.ingredients.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 180.w,
            margin: EdgeInsets.only(right: 10.w),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
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
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  child: Image.network(
                    cubit.ingredients[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 18.w,
                    ),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
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
