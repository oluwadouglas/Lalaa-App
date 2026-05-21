import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/article.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String? _selectedCategory; // null means 'All'

  @override
  Widget build(BuildContext context) {
    final allArticles = Article.demoArticles();
    final categories = allArticles.map((a) => a.category).toSet().toList();
    
    // Filter articles based on selection
    final displayedArticles = _selectedCategory == null
        ? allArticles
        : allArticles.where((a) => a.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Learn')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), // added bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = null);
                  },
                ),
                ...categories.map((cat) => ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = selected ? cat : null);
                  },
                )),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Articles',
              style: AppTextStyles.h3.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            if (displayedArticles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No articles found for this category.'),
              )
            else
              ...displayedArticles.map((article) => _ArticleCard(
                article: article,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _ArticleDetailScreen(article: article)),
                ),
              )),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.article_outlined, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title, 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface, 
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${article.readTimeMinutes} min read • ${article.category}',
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textTertiary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).dividerColor),
          ],
        ),
      ),
    );
  }
}

class _ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const _ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(article.category)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title, 
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, 
                fontSize: 24, 
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 8),
            Text(
              '${article.readTimeMinutes} min read',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textTertiary, fontSize: 13)
            ),
            const Divider(height: 32),
            Text(
              article.content, 
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary, 
                fontSize: 15, 
                height: 1.7,
              )
            ),
          ],
        ),
      ),
    );
  }
}
