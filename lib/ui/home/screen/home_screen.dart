import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookpal/database/shared_preferences.dart';
import 'package:cookpal/ui/category/screen/category_screen.dart';
import 'package:cookpal/ui/favorite/screen/favorite_screen.dart';
import 'package:cookpal/ui/home/manager/home_cubit.dart';
import 'package:cookpal/ui/home/manager/home_state.dart';
import 'package:cookpal/ui/internet_alert/internet_alert.dart';
import 'package:cookpal/ui/login/screen/login_screen.dart';
import 'package:cookpal/ui/recipe/screen/recipe_screen.dart';
import 'package:cookpal/ui/search/screen/search_screen.dart';
import 'package:cookpal/utils/app_toast.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:cookpal/utils/determine_margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? subscription;
  final pageController = PageController();
  final cubit = HomeCubit();

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const InternetAlert(),
          ),
          (route) => false,
        );
      }
    });
    cubit.getUser();
    cubit.getHome();
  }

  @override
  void dispose() {
    super.dispose();
    subscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is LogOutSuccess) {
            onLogOutSuccess();
          } else if (state is LogOutFailure) {
            displayToast(state.errorMessage);
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) =>
              current is GetHomeSuccess || current is GetUserSuccess,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.grey[400],
                  size: 22.r,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(
                      Icons.search,
                    ),
                  ),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                      ),
                      child: UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                        ),
                        accountName: Text(
                          cubit.user.userName,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17.sp,
                          ),
                        ),
                        accountEmail: Text(
                          cubit.user.email,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) => current is ThemeChange,
                      builder: (context, state) {
                        return ListTile(
                          leading: Icon(
                            PreferenceUtils.getBool(PrefKeys.theme)
                                ? Icons.sunny
                                : Icons.nightlight_outlined,
                            color: secondaryColor,
                            size: 22.r,
                          ),
                          title: Text(
                            ' Change theme ',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 17.sp,
                            ),
                          ),
                          onTap: () {
                            changeTheme();
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.favorite_border_outlined,
                        color: secondaryColor,
                        size: 22.r,
                      ),
                      title: Text(
                        ' Favorite ',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 17.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoriteScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: secondaryColor,
                        size: 22.r,
                      ),
                      title: Text(
                        'LogOut',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 17.sp,
                        ),
                      ),
                      onTap: () {
                        cubit.logOut();
                      },
                    ),
                  ],
                ),
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: determineMargin() ? 300.w : 15.w,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'playFairDisplay',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: cubit.discover.length,
                          itemBuilder: (context, position) {
                            return discoverItemBuilder(position);
                          },
                        ),
                        Positioned(
                          bottom: 20.h,
                          right: 20.w,
                          child: SmoothPageIndicator(
                            controller: pageController,
                            // PageController
                            count: cubit.discover.length,
                            effect: SlideEffect(
                              activeDotColor: primaryIconColor,
                              dotColor: secondaryIconColor,
                              dotHeight: 12.h,
                              dotWidth: 12.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Categories",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'playFairDisplay',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  categoriesItemBuilder(),
                  SizedBox(height: 20.h),
                  Text(
                    "Recipes",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'playFairDisplay',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  recipeItemBuilder(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget discoverItemBuilder(int position) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeScreen(recipe: cubit.discover[position]),
          ),
        );
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
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
                          cubit.discover[position].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'playFairDisplay',
                          ),
                        ),
                        Text(
                          cubit.discover[position].description,
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
                              cubit.discover[position].time,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.kitchenSet,
                              color: primaryIconColor,
                              size: 18.r,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              cubit.discover[position].level,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image.network(
                      cubit.discover[position].image,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoriesItemBuilder() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cubit.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryScreen(category: cubit.categories[index]),
                ),
              );
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
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
                  Image.network(
                    cubit.categories[index].image,
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
                        cubit.categories[index].name,
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
            ),
          );
        },
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
                                height: 1.2.h,
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
                            SizedBox(height: 10.w),
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

  void onLogOutSuccess() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void changeTheme() {
    if (PreferenceUtils.getBool(PrefKeys.theme)) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
    PreferenceUtils.setBool(
      PrefKeys.theme,
      !PreferenceUtils.getBool(PrefKeys.theme),
    );
    cubit.onThemeChange();
  }
}
