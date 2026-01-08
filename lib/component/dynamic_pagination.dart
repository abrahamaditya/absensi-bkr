import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const DynamicPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();

    final Color effectiveActiveColor = activeColor ?? purple;
    final Color effectiveInactiveColor = inactiveColor ?? lightGrey;

    final List<dynamic> pages = _generatePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavButton(
          icon: Icons.keyboard_arrow_left,
          isEnabled: currentPage > 1,
          onTap: () => onPageChanged(currentPage - 1),
          color: effectiveActiveColor,
          disabledColor: effectiveInactiveColor,
        ),
        ...pages.map((page) {
          if (page == "...") {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "...",
                style: TextStyle(
                    color: effectiveInactiveColor, fontWeight: FontWeight.bold),
              ),
            );
          }

          final bool isSelected = page == currentPage;

          // MENGGUNAKAN MOUSEREGION AGAR KURSOR BERUBAH
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onPageChanged(page),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? effectiveActiveColor : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? effectiveActiveColor
                        : effectiveInactiveColor,
                  ),
                ),
                child: Text(
                  "$page",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
        _buildNavButton(
          icon: Icons.keyboard_arrow_right,
          isEnabled: currentPage < totalPages,
          onTap: () => onPageChanged(currentPage + 1),
          color: effectiveActiveColor,
          disabledColor: effectiveInactiveColor,
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
    required Color color,
    required Color disabledColor,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: isEnabled ? color : disabledColor,
      onPressed: isEnabled ? onTap : null,
      // Menambahkan kursor click secara eksplisit untuk IconButton
      mouseCursor:
          isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  List<dynamic> _generatePages() {
    List<dynamic> pages = [];
    if (totalPages <= 5) {
      return List.generate(totalPages, (index) => index + 1);
    }

    pages.add(1);
    if (currentPage > 3) pages.add("...");

    int start = currentPage - 1;
    int end = currentPage + 1;

    if (currentPage <= 3) {
      start = 2;
      end = 4;
    } else if (currentPage >= totalPages - 2) {
      start = totalPages - 3;
      end = totalPages - 1;
    }

    for (int i = start; i <= end; i++) {
      if (i > 1 && i < totalPages) pages.add(i);
    }

    if (currentPage < totalPages - 2) pages.add("...");

    pages.add(totalPages);
    return pages;
  }
}
