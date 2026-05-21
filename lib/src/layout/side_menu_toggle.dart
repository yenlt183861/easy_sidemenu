import 'package:flutter/material.dart';

import '../enums/display_mode.dart';
import '../side_menu_scope.dart';

/// Animated chevron button that toggles between open and compact display modes.
class SideMenuToggle extends StatelessWidget {
  const SideMenuToggle({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scope = SideMenuScope.of(context);
    final theme = scope.theme.resolve(context);

    return ValueListenableBuilder(
      valueListenable: scope.displayModeNotifier,
      builder: (context, mode, _) {
        final isOpen = mode == SideMenuDisplayMode.open;
        return Padding(
          padding: EdgeInsets.only(
            top: isOpen ? 4 : 0,
            right: isOpen ? 0 : 2,
          ),
          child: IconButton(
            color: theme.toggleColor,
            onPressed: onTap,
            icon: AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.navigate_next, size: 30),
            ),
          ),
        );
      },
    );
  }
}
