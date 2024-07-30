import '../entities/entities.dart';

class Category {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  // A static empty instance of Category for initialization or default values.
  static final empty = Category(
    categoryId: '',
    name: '',
    totalExpenses: 0,
    icon: '',
    color: 0,
  );

  // Converts a Category object to a CategoryEntity object.
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
    );
  }

  // Creates a Category object from a CategoryEntity object.
  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
    );
  }
}
