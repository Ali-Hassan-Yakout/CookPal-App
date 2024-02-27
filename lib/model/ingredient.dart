class Ingredient {
  String ingredientId;
  String name;
  String image;

  Ingredient({
    required this.ingredientId,
    required this.name,
    required this.image,
  });

  Ingredient.fromMap(Map<String, dynamic> map)
      : ingredientId = map['ingredientId'],
        name = map['name'],
        image = map['image'];
}
