/// Product model for the sleep marketplace.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final bool inStock;
  final List<String> features;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.rating = 0,
    this.reviewCount = 0,
    required this.category,
    this.inStock = true,
    this.features = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['image_url'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['review_count'] as int? ?? 0,
        category: json['category'] as String,
        inStock: json['in_stock'] as bool? ?? true,
        features: (json['features'] as List?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'rating': rating,
        'review_count': reviewCount,
        'category': category,
        'in_stock': inStock,
        'features': features,
      };

  static List<Product> demoProducts() => const [
        Product(id: 'prod-1', name: 'Memory Foam Pillow', description: 'Ergonomic memory foam pillow for optimal neck support.', price: 225000, rating: 4.7, reviewCount: 234, category: 'Pillows', features: ['Cooling gel', 'Hypoallergenic', 'Washable cover']),
        Product(id: 'prod-2', name: 'Weighted Sleep Blanket', description: 'Premium 15lb weighted blanket with breathable bamboo fabric.', price: 340000, rating: 4.8, reviewCount: 187, category: 'Bedding', features: ['15lb weight', 'Bamboo fabric', 'Machine washable']),
        Product(id: 'prod-3', name: 'White Noise Machine', description: 'Compact sound machine with 20 soothing sounds.', price: 135000, rating: 4.5, reviewCount: 312, category: 'Electronics', features: ['20 sounds', 'Timer', 'USB-C charging']),
        Product(id: 'prod-4', name: 'Lavender Sleep Spray', description: 'Calming pillow spray with natural lavender essential oil.', price: 75000, rating: 4.3, reviewCount: 156, category: 'Aromatherapy', features: ['Natural', '100ml', 'Non-staining']),
        Product(id: 'prod-5', name: 'Silk Sleep Mask', description: 'Ultra-soft mulberry silk sleep mask, fully light-blocking.', price: 95000, rating: 4.6, reviewCount: 289, category: 'Accessories', features: ['100% silk', 'Adjustable strap', 'Travel pouch']),
        Product(id: 'prod-6', name: 'Blackout Curtains', description: 'Thermal insulated curtains that block 99% of light.', price: 190000, rating: 4.4, reviewCount: 198, category: 'Bedding', features: ['99% blackout', 'Thermal insulation', 'Multiple sizes']),
        Product(id: 'prod-7', name: 'Melatonin Gummies', description: 'Natural melatonin sleep supplement, berry flavored.', price: 55000, rating: 4.2, reviewCount: 445, category: 'Supplements', features: ['3mg melatonin', '60 gummies', 'Vitamin B6']),
        Product(id: 'prod-8', name: 'Smart Sunrise Alarm', description: 'Wake up naturally with simulated sunrise light.', price: 305000, rating: 4.7, reviewCount: 167, category: 'Electronics', features: ['Sunrise sim', 'Sunset mode', 'FM radio']),
        Product(id: 'prod-9', name: 'Bamboo Sheet Set', description: 'Luxuriously soft bamboo sheets, temperature regulating.', price: 265000, rating: 4.8, reviewCount: 321, category: 'Bedding', features: ['Bamboo fiber', 'Antimicrobial', 'Queen/King']),
        Product(id: 'prod-10', name: 'Sleep Tracker Ring', description: 'Lightweight titanium ring tracking sleep stages and heart rate.', price: 760000, rating: 4.6, reviewCount: 89, category: 'Electronics', features: ['Sleep tracking', 'Heart rate', '7-day battery']),
      ];
}

/// Represents an item in the shopping cart.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}

/// Represents a completed order.
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String shippingAddress;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });
}
