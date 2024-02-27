class AppUser {
  String email;
  List<dynamic> favoriteRecipesId;
  String userId;
  String userName;

  AppUser({
    required this.email,
    required this.favoriteRecipesId,
    required this.userId,
    required this.userName,
  });

  AppUser.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        favoriteRecipesId = map['favoriteRecipesId'],
        userId = map['userId'],
        userName = map['userName'];
}
