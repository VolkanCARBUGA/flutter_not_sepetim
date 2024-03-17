class Category {
  int? categoryId;
  String? categoryName;

  Category({this.categoryId,this.categoryName});
  Category.withId({this.categoryId, this.categoryName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'categoryName': categoryName,
    };
    if (categoryId != null) {
      map['categoryId'] = categoryId;
      map['categoryName'] = categoryName;
    }
    return map;
  }
  
  Category.fromMap(Map<String, dynamic> map) {
    categoryId = map['categoryId'];
    categoryName = map['categoryName'];
  }

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, categoryName: $categoryName}';
  }
  
}