import 'package:flutter/material.dart';

import '../controller/side_menu_controller.dart';
import '../enums/display_mode.dart';
import '../side_menu_scope.dart';
import '../theme/side_menu_theme.dart';
import 'side_menu_item.dart';
import 'side_menu_item_base.dart';

/// An expandable group item in a [SideMenu].
///
/// ```dart
/// SideMenuExpansionItem(
///   icon: Icon(Icons.settings),
///   title: 'Settings',
///   children: [
///     SideMenuItem(title: 'Profile', onTap: (i, c) => c.goTo(i)),
///     SideMenuItem(title: 'Security', onTap: (i, c) => c.goTo(i)),
///   ],
/// )
/// ```
class SideMenuExpansionItem extends SideMenuItemBase {
  const SideMenuExpansionItem({
    super.key,
    this.title,
    this.icon,
    this.iconWidget,
    this.onTap,
    this.initiallyExpanded = false,
    required this.children,
  }) : assert(
          title != null || icon != null || iconWidget != null,
          'Provide at least one of title, icon, or iconWidget.',
        );

  final String? title;
  final Icon? icon;
  final Widget? iconWidget;

  /// Called when the tile is expanded or collapsed.
  final void Function(
    int index,
    SideMenuController controller,
    bool isExpanded,
  )? onTap;

  final bool initiallyExpanded;
  final List<SideMenuItem> children;

  @override
  State<SideMenuExpansionItem> createState() => _SideMenuExpansionItemState();
}

class _SideMenuExpansionItemState extends State<SideMenuExpansionItem> {
  late bool _expanded = widget.initiallyExpanded;

  Widget _buildIcon(SideMenuThemeData theme) {
    if (widget.icon == null) return widget.iconWidget ?? const SizedBox.shrink();
    final color = _expanded
        ? theme.selectedIconColor ?? Colors.black
        : theme.unselectedIconColor ?? Colors.black54;
    return Icon(widget.icon!.icon, color: color, size: theme.iconSize);
  }

  @override
  Widget build(BuildContext context) {
    final scope = SideMenuScope.of(context);
    final index = SideMenuItemIndex.of(context);
    final theme = scope.theme.resolve(context);

    return ValueListenableBuilder(
      valueListenable: scope.displayModeNotifier,
      builder: (context, mode, _) {
        return ListTileTheme(
          contentPadding: EdgeInsets.symmetric(
            horizontal: mode == SideMenuDisplayMode.compact
                ? theme.itemInnerSpacing
                : theme.itemInnerSpacing + 5,
          ),
          horizontalTitleGap: 0,
          child: ExpansionTile(
            leading: SizedBox(
              width: 40,
              child: _buildIcon(theme),
            ),
            title: mode == SideMenuDisplayMode.open
                ? Text(
                    widget.title ?? '',
                    style: _expanded
                        ? const TextStyle(fontSize: 17, color: Colors.black)
                            .merge(theme.selectedTitleStyle)
                        : const TextStyle(fontSize: 17, color: Colors.black54)
                            .merge(theme.unselectedTitleStyle),
                  )
                : const SizedBox.shrink(),
            trailing: Icon(
              _expanded
                  ? Icons.arrow_drop_down_circle
                  : Icons.arrow_drop_down,
              color: _expanded
                  ? theme.expansionArrowOpenColor
                  : theme.expansionArrowColor,
            ),
            initiallyExpanded: widget.initiallyExpanded,
            maintainState: true,
            onExpansionChanged: (expanded) {
              setState(() => _expanded = expanded);
              widget.onTap?.call(index, scope.controller, expanded);
            },
            children: _buildChildren(index),
          ),
        );
      },
    );
  }

  /// Assigns a flat index to each child, continuing from the parent [index].
  List<Widget> _buildChildren(int parentIndex) {
    return [
      for (var i = 0; i < widget.children.length; i++)
        SideMenuItemIndex(
          index: parentIndex + 1 + i,
          child: widget.children[i],
        ),
    ];
  }
}
