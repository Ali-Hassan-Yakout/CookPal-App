import 'package:cookpal/ui/favorite/manager/favorite_cubit.dart';
import 'package:cookpal/ui/favorite/manager/favorite_state.dart';
import 'package:cookpal/ui/recipe/screen/recipe_screen.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final cubit = FavoriteCubit();

  @override
  void initState() {
    super.initState();
    cubit.getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is GetFavoriteFailure) {
            displayToast(state.errorMessage);
          }
        },
        buildWhen: (previous, current) => current is GetFavoriteSuccess,
        builder: (context, state) {
          return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    leading: IconButton(
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
                    title: Text(
                      "Favorite",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'playFairDisplay',
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: cubit.loading
                      ? Center(
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                          ),
                        )
                      : recipeItemBuilder(),
                );
        },
      ),
    );
  }

  Widget recipeItemBuilder() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(14.sp),
      itemCount: cubit.recipes.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecipeScreen(recipe: cubit.recipes[index]),
              ),
            ).then((value) => cubit.getFavorite());
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.sp),
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
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cubit.recipes[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'playFairDisplay',
                              ),
                            ),
                            Text(
                              cubit.recipes[index].description,
                              style: TextStyle(
                                height: 5.2.sp,
                                color: Colors.white38,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 15.sp),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: primaryIconColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.sp),
                                Text(
                                  cubit.recipes[index].time,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 10.sp),
                                Icon(
                                  FontAwesomeIcons.kitchenSet,
                                  color: primaryIconColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.sp),
                                Text(
                                  cubit.recipes[index].level,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.network(
                          cubit.recipes[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
