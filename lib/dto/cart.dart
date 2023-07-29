class ProductCartDTO {
  int id;
  int quantity;
  int price;
  String? name;
  String? image;
  ProductCartDTO(
      {required this.id,
      required this.quantity,
      required this.price,
      this.name,
      this.image});

  factory ProductCartDTO.fromJson(Map<String, dynamic> json) => ProductCartDTO(
        id: json['id'],
        quantity: json['quantity'],
        price: json['price'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'price': price,
        // 'name': name,
        // 'image': image,
      };
}

class CartDTO {
  String address;
  List<ProductCartDTO> items;
  int totalPrice;
  String? status;
  int? shippingPrice;
  CartDTO(
      {required this.address,
      required this.totalPrice,
      required this.items,
      this.status,
      this.shippingPrice});

  factory CartDTO.fromJson(Map<String, dynamic> json) => CartDTO(
        address: json['address'],
        items: json['items'],
        status: 'PENDING',
        totalPrice: json['total_price'],
        shippingPrice: 0,
      );

  Map<String, dynamic> toJson() => {
        'address': address,
        'items': items.map((e) => e.toJson()).toList(),
        'status': status,
        'total_price': totalPrice,
        'shipping_price': shippingPrice,
      };
}
