class ProductModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String currencyCode;
  final double rawPrice;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.rawPrice,
  });

  @override
  String toString() => 'ProductModel(id: $id, title: $title, price: $price)';
}
