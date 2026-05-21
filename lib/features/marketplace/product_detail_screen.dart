import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../shared/models/product.dart';
import 'marketplace_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pillows': return Icons.airline_seat_individual_suite;
      case 'bedding': return Icons.bed;
      case 'electronics': return Icons.speaker;
      case 'aromatherapy': return Icons.spa;
      case 'accessories': return Icons.visibility_off;
      case 'supplements': return Icons.medication;
      default: return Icons.local_mall;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(product.category)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, height: 240,
              color: context.mutedFill,
              child: Icon(_getCategoryIcon(product.category), size: 80, color: context.hintText),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(
                      color: context.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star, size: 18, color: AppColors.warning),
                    Text(' ${product.rating}', style: TextStyle(fontWeight: FontWeight.w600, color: context.onSurface)),
                    Text(' (${product.reviewCount} reviews)', style: TextStyle(color: context.subText, fontSize: 13)),
                  ]),
                  const SizedBox(height: 12),
                  Text('UGX ${product.price.toInt()}',
                      style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(product.description, style: TextStyle(
                      color: context.subText, fontSize: 15, height: 1.6)),
                  if (product.features.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.onSurface)),
                    const SizedBox(height: 8),
                    ...product.features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Text(f, style: TextStyle(color: context.subText, fontSize: 14)),
                      ]),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                CartState.add(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${product.name} added to cart!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
            ),
          ),
        ),
      ),
    );
  }
}
