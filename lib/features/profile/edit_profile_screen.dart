import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  String _sleepType = 'Bear'; // Example from quiz
  bool _saving = false;

  final List<Map<String, String>> _sleepTypes = [
    {'type': 'Bear', 'emoji': '🐻', 'desc': 'Sleeps with the sun'},
    {'type': 'Wolf', 'emoji': '🐺', 'desc': 'Night owl'},
    {'type': 'Lion', 'emoji': '🦁', 'desc': 'Early riser'},
    {'type': 'Dolphin', 'emoji': '🐬', 'desc': 'Light sleeper'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.success),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _handleSave,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: context.mutedFill,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.divider, width: 2),
                    ),
                    child: Icon(Icons.person, size: 50, color: context.hintText),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Personal Info
            Text('Personal Info', style: TextStyle(color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: context.cardBg,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: context.cardBg,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Sleep Type
            Text('Your Sleep Type', style: TextStyle(color: context.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Based on your sleep quiz results', style: TextStyle(color: context.subText, fontSize: 13)),
            const SizedBox(height: 16),
            ..._sleepTypes.map((type) => RadioListTile<String>(
              value: type['type']!,
              groupValue: _sleepType,
              onChanged: (val) => setState(() => _sleepType = val!),
              title: Text('${type['emoji']} ${type['type']}'),
              subtitle: Text(type['desc']!, style: TextStyle(color: context.subText)),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            )),
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retaking quiz...')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Retake Sleep Quiz', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
