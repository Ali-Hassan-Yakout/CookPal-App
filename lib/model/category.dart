class Category {
  String categoryId;
  String name;
  String image;

  Category({
    required this.categoryId,
    required this.name,
    required this.image,
  });

  Category.fromMap(Map<String, dynamic> map)
      : categoryId = map['categoryId'],
        name = map['name'],
        image = map['image'];
}
