import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import 'marketplace_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;

  Future<void> _processOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    CartState.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const _OrderConfirmScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final totalUgx = CartState.total.toInt();

    return Scaffold(
      backgroundColor: context.pageBg,
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shipping Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.onSurface)),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.home_outlined)),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                )),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                )),
              ]),
              const SizedBox(height: 28),
              Text('Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.onSurface)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Row(children: [
                  const Icon(Icons.credit_card, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Payment', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: context.onSurface)),
                      Text('Visa, Mastercard, etc.', style: TextStyle(color: context.hintText, fontSize: 12)),
                    ],
                  )),
                  const Icon(Icons.radio_button_checked, color: AppColors.primary),
                ]),
              ),
              const SizedBox(height: 12),
              // Mobile Money option
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.divider),
                ),
                child: Row(children: [
                  Icon(Icons.phone_android, color: context.subText),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile Money', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: context.onSurface)),
                      Text('MTN, Airtel Money', style: TextStyle(color: context.hintText, fontSize: 12)),
                    ],
                  )),
                  Icon(Icons.radio_button_unchecked, color: context.hintText),
                ]),
              ),
              const SizedBox(height: 24),
              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.mutedFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Subtotal', style: TextStyle(color: context.subText)),
                      Text('UGX $totalUgx', style: TextStyle(color: context.onSurface)),
                    ]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Shipping', style: TextStyle(color: context.subText)),
                      Text('Free', style: TextStyle(color: context.subText)),
                    ]),
                    Divider(height: 16, color: context.divider),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.onSurface)),
                      Text('UGX $totalUgx',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _processing ? null : _processOrder,
              child: _processing
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Place Order'),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderConfirmScreen extends StatelessWidget {
  const _OrderConfirmScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 48, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              Text('Order Confirmed! 🎉',
                  style: TextStyle(color: context.onSurface, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Your order has been placed successfully.\nYou will receive a confirmation email shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.subText, fontSize: 14, height: 1.5)),
              const SizedBox(height: 12),
              Text('Order #ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  style: const TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
