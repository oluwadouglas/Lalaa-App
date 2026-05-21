import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import 'marketplace_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = CartState.items;

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(title: const Text('Cart')),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 48, color: context.hintText),
                  const SizedBox(height: 12),
                  Text('Your cart is empty', style: TextStyle(color: context.subText)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.divider),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: context.mutedFill,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.image, color: context.hintText, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600, color: context.onSurface)),
                            Text('UGX ${item.product.price.toInt()}',
                                style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, size: 20, color: context.onSurface),
                            onPressed: () => setState(() =>
                                CartState.updateQty(item.product.id, item.quantity - 1)),
                          ),
                          Text('${item.quantity}', style: TextStyle(fontWeight: FontWeight.bold, color: context.onSurface)),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, size: 20, color: context.onSurface),
                            onPressed: () => setState(() =>
                                CartState.updateQty(item.product.id, item.quantity + 1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.onSurface)),
                        Text('UGX ${CartState.total.toInt()}',
                            style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
