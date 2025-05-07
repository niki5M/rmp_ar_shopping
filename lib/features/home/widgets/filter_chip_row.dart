import 'package:flutter/material.dart';

class FilterChipRow extends StatefulWidget {
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterChanged;

  const FilterChipRow({
    super.key,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: widget.filters.map((filter) {
          return GestureDetector(
            onTap: () => widget.onFilterChanged(filter),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.selectedFilter == filter
                    ? Colors.black
                    : Colors.transparent,
                border: Border.all(
                  color: widget.selectedFilter == filter
                      ? Colors.black
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: widget.selectedFilter == filter
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}