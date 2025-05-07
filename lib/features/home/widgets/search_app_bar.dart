import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final VoidCallback onCartPressed;
  final int cartItemCount;
  final String userName;

  const SearchAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onToggleSearch,
    required this.onCartPressed,
    required this.cartItemCount,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      iconTheme: theme.appBarTheme.iconTheme,
      titleTextStyle: theme.appBarTheme.titleTextStyle,
      title: isSearching
          ? TextField(
        controller: searchController,
        autofocus: true,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: 'Поиск...',
          hintStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Добро пожаловать,',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          Text(
            userName,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: theme.appBarTheme.iconTheme?.color,
          ),
          onPressed: onToggleSearch,
        ),
        if (!isSearching)
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: theme.appBarTheme.iconTheme?.color,
                ),
                onPressed: onCartPressed,
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}