import 'package:cookpal/model/category.dart';
import 'package:cookpal/ui/category/manager/category_cubit.dart';
import 'package:cookpal/ui/category/manager/category_state.dart';
import 'package:cookpal/ui/recipe/screen/recipe_screen.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:cookpal/utils/determine_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final cubit = CategoryCubit();

  @override
  initState() {
    super.initState();
    cubit.getCategory(categoryId: widget.category.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen: (previous, current) => current is GetCategorySuccess,
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
                  size: 22.r,
                ),
              ),
              title: Text(
                widget.category.name,
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
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: determineMargin(context) ? 300.w : 15.w,
      ),
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
            );
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            height: 250.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
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
                    vertical: 15.h,
                    horizontal: 15.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              maxLines: 5,
                              style: TextStyle(
                                height: 1.4.h,
                                color: Colors.white38,
                                fontSize: 16.sp,
                                overflow: TextOverflow.clip,
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
                              ],
                            ),
                            SizedBox(width: 10.sp),
                            Row(
                              children: [
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
