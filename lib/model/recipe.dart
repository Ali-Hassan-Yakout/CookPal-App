class Recipe {
  String recipeId;
  String name;
  String description;
  String time;
  String level;
  String image;
  bool discover;
  String categoryId;
  List<dynamic> ingredientsId;
  String instructions;

  Recipe({
    required this.recipeId,
    required this.name,
    required this.description,
    required this.time,
    required this.level,
    required this.image,
    required this.discover,
    required this.categoryId,
    required this.ingredientsId,
    required this.instructions,
  });

  Recipe.fromMap(Map<String, dynamic> map)
      : recipeId = map['recipeId'],
        name = map['name'],
        description = map['description'],
        time = map['time'],
        level = map['level'],
        image = map['image'],
        discover = map['discover'],
        categoryId = map['categoryId'],
        ingredientsId = map['ingredientsId'],
        instructions = map['instructions'];
}
