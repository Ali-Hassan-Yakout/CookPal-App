import 'package:cookpal/ui/recipe/screen/recipe_screen.dart';
import 'package:cookpal/ui/search/manager/search_cubit.dart';
import 'package:cookpal/ui/search/manager/search_state.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
              size: 22.sp,
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
              padding: EdgeInsets.all(15.sp),
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
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.sp),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
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
                  padding: EdgeInsets.all(14.sp),
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
