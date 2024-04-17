import 'package:cookpal/ui/recipe/screen/recipe_screen.dart';
import 'package:cookpal/ui/search/manager/search_cubit.dart';
import 'package:cookpal/ui/search/manager/search_state.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:cookpal/utils/determine_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  final cubit = SearchCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
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
            "Search",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'playFairDisplay',
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchFailure) {
              displayToast(state.errorMessage);
            }
          },
          buildWhen: (previous, current) => current is SearchSuccess,
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: determineMargin() ? 300.w : 15.w,
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                TextFormField(
                  cursorColor: secondaryColor,
                  style: const TextStyle(color: secondaryColor),
                  onChanged: (value) {
                    cubit.search(value);
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.search,
                      color: secondaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                recipeItemBuilder(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget recipeItemBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
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
                    vertical: 14.h,
                    horizontal: 14.w,
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
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: primaryIconColor,
                                  size: 18.r,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  cubit.recipes[index].time,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.kitchenSet,
                                  color: primaryIconColor,
                                  size: 18.r,
                                ),
                                SizedBox(width: 10.w),
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
