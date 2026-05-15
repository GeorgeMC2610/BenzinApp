import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageChanged;

  const Pagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildArrow(Icons.chevron_left, currentPage > 1 ? () => onPageChanged(currentPage - 1) : null, false),
            const SizedBox(width: 8),
            ..._buildPages(),
            const SizedBox(width: 8),
            _buildArrow(Icons.chevron_right, currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null, true),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(IconData icon, VoidCallback? onTap, bool isRight) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isRight ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: onTap == null ? Colors.grey[300] : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    List<Widget> widgets = [];
    List<dynamic> pages = [];
    
    if (totalPages <= 7) {
      pages = List.generate(totalPages, (i) => i + 1);
    } else {
      if (currentPage <= 4) {
        pages = [1, 2, 3, 4, 5, '...', totalPages];
      } else if (currentPage >= totalPages - 3) {
        pages = [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
      } else {
        pages = [1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages];
      }
    }

    for (var page in pages) {
      if (page is int) {
        widgets.add(_buildPageItem(page));
      } else {
        widgets.add(_buildEllipsis());
      }
    }
    
    return widgets;
  }

  Widget _buildPageItem(int page) {
    bool isSelected = page == currentPage;
    return InkWell(
      onTap: () => onPageChanged(page),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[500],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
