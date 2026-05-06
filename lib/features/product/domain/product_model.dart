class Product {
  final String title;
  final double price;
  final String? image;

  const Product({
    required this.title,
    required this.price,
    this.image,
  });

  // Tambahkan copyWith untuk manipulasi data NIM nanti
  Product copyWith({String? title, double? price, String? image}) {
    return Product(
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
    );
  }
}