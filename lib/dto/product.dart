class ProductDTO {
  String productId;
  String name;
  String price;
  String? description;
  String? tags;
  String? thumbnail;
  List<Map<String, dynamic>>? galleries;
  ProductDTO(
      {required this.productId,
      required this.name,
      required this.price,
      this.description,
      this.tags,
      this.thumbnail,
      this.galleries});

  factory ProductDTO.fromJson(Map<String, dynamic> json) => ProductDTO(
        productId: json['id'],
        name: json['name'],
        price: json['email'],
        description: json['description'],
        tags: json['tags'],
        galleries: json['galleries'],
        thumbnail: json['galleries'][0]['url'],
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'price': price,
        'name': name,
        'description': description ?? '',
        'tags': tags ?? '',
        'galleries': galleries ?? [],
        'thumbnail': galleries!.isNotEmpty ? galleries![0]['url'] : '',
      };
}
