import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_strucuture/core/exports.dart';
import 'package:new_strucuture/features/main_screen/cubit/cubit.dart';
import 'package:new_strucuture/features/main_screen/cubit/state.dart';
import 'package:new_strucuture/config/themes/theme_cubit.dart';
import 'package:new_strucuture/core/utils/restart_app_class.dart';
import '../data/model/product_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing",
  ];

  @override
  void initState() {
    super.initState();
    // Fetch products on load
    context.read<MainCubit>().getProductsList();
  }

  String categoryKey(String cat) {
    if (cat.toLowerCase() == 'all') return 'all';
    return cat.toLowerCase().replaceAll("'", "").replaceAll(" ", "_");
  }

  void _showProductDetails(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomSheetBg = isDark ? const Color(0xFF1B2639) : Colors.white;
    final detailsBg = isDark ? const Color(0xFF151F30) : AppColors.secondary;
    final textColor = isDark ? Colors.white : AppColors.black;
    final subtitleColor = isDark ? Colors.white70 : AppColors.text;
    final borderColor = isDark ? const Color(0xFF223048) : AppColors.greye8;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: bottomSheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slide Bar Indicator
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF223048) : AppColors.greye8,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: bottomSheetBg,
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image_outlined,
                            size: 80,
                            color: AppColors.greya8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categoryKey(product.category).tr(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: isDark ? const Color(0xFF223048) : Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(Icons.close, color: isDark ? Colors.white : AppColors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Container(
              decoration: BoxDecoration(
                color: detailsBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: borderColor, width: 1),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rating Row
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.rate.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${product.rating.count} ${'reviews'.tr()})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.hint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'about_item'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.title} ${'added_to_cart'.tr()}',
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'add_to_cart'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width > 800
        ? 64.0
        : 16.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.secondary,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                ImageAssets.logoImage,
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'app_name'.tr(),
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          // Language Switcher Toggle
          TextButton(
            onPressed: () async {
              if (context.locale.languageCode == 'ar') {
                await context.setLocale(const Locale('en', ''));
              } else {
                await context.setLocale(const Locale('ar', ''));
              }
              if (context.mounted) {
                HotRestartController.performHotRestart(context);
              }
            },
            child: Text(
              context.locale.languageCode == 'ar' ? 'EN' : 'عربي',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Theme Switcher Toggle Icon
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme(context);
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.greye8, height: 1),
        ),
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state is MainLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MainError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'load_failed'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<MainCubit>().getProductsList(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text('try_again'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MainLoaded) {
            final allProducts = state.products;

            // Apply local category filter
            final filteredProducts = _selectedCategory == 'All'
                ? allProducts
                : allProducts
                      .where(
                        (p) =>
                            p.category.toLowerCase() ==
                            _selectedCategory.toLowerCase(),
                      )
                      .toList();

            // Trending products (for horizontal view - take first 5 from the selected list)
            final trendingProducts = filteredProducts.take(5).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter Chips
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected =
                            _selectedCategory.toLowerCase() ==
                            cat.toLowerCase();
                        return GestureDetector(
                           onTap: () {
                             setState(() {
                               _selectedCategory = cat;
                             });
                           },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? const Color(0xFF1B2639) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? const Color(0xFF223048) : AppColors.greye8),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat.toLowerCase() == 'all'
                                    ? 'all'.tr()
                                    : categoryKey(cat).tr(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : AppColors.text),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 1. HORIZONTAL LIST (Trending Deals)
                  if (trendingProducts.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'trending_deals'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.black,
                            ),
                          ),
                          Text(
                            'see_all'.tr(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        itemCount: trendingProducts.length,
                        itemBuilder: (context, index) {
                          final product = trendingProducts[index];
                          return _buildHorizontalCard(context, product);
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // 2. VERTICAL STAGGERED LIST (All Products Catalog using SliverStairedGridDelegate)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text(
                      'exclusive_catalog'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  filteredProducts.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'no_products'.tr(),
                              style: const TextStyle(
                                color: AppColors.hint,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return _buildStaggeredCard(context, product, index);
                            },
                          ),
                        ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Horizontal Card Builder
  Widget _buildHorizontalCard(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1B2639) : Colors.white;
    final cardDetailsBg = isDark ? const Color(0xFF151F30) : AppColors.secondary;
    final textColor = isDark ? Colors.white : AppColors.black;
    final borderColor = isDark ? const Color(0xFF223048) : AppColors.greye8;

    return GestureDetector(
      onTap: () => _showProductDetails(context, product),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Container
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 1.5),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: AppColors.greya8,
                    ),
                  ),
                ),
              ),
            ),
            // Product Details Block
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardDetailsBg,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border(
                    top: BorderSide(color: borderColor, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.rate.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaggeredCard(BuildContext context, ProductModel product, int index) {
    // Dynamic image height to ensure premium and visually-appealing staggered masonry layout
    final double imageHeight = 100.0 + (index % 3) * 30.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1B2639) : Colors.white;
    final cardDetailsBg = isDark ? const Color(0xFF151F30) : AppColors.secondary;
    final textColor = isDark ? Colors.white : AppColors.black;
    final borderColor = isDark ? const Color(0xFF223048) : AppColors.greye8;

    return GestureDetector(
      onTap: () => _showProductDetails(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  height: imageHeight,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image_outlined,
                    size: 28,
                    color: AppColors.greya8,
                  ),
                ),
              ),
            ),
            // Product Details Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: cardDetailsBg,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryKey(product.category).tr(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.rate.toString(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
