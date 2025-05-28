import 'package:flutter/material.dart';

class AnimatedSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _AnimatedSearchAppBarState createState() => _AnimatedSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedSearchAppBarState extends State<AnimatedSearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'iCar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        // Animated Search Field
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isSearching ? 150 : 0, // Only expands a bit
          curve: Curves.easeInOut,
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _isSearching
              ? Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              : null,
        ),
        // Search Icon
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchController.clear();
            });
          },
        ),
        // Notification Icon
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            // Handle notification tap
          },
        ),
      ],
    );
  }
}
