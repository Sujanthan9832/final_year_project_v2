import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // To receive the selected index
  final Function(int) onItemSelected; // To receive the selected item callback

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 65,
      elevation: 8.0,
      shadowColor: Colors.black.withOpacity(1),
      notchMargin: 5.0,
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomIconButton(
            icon: Icons.contacts,
            label: "Massages",
            index: 0,
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          const Flexible(
            child: SizedBox(
              width: 20.0,
            ),
          ),
          CustomIconButton(
            icon: Icons.settings,
            label: "Settings",
            index: 2,
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Color.fromARGB(255, 255, 255, 255)
                : Color.fromARGB(255, 0, 0, 0),
          ),
          Text(
            label,
            style: TextStyle(
              // color: isSelected ? colors.brandRed : colors.commonGra,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
