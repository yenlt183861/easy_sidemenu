import 'package:flutter/material.dart';

import '../controller/side_menu_controller.dart';
import '../enums/display_mode.dart';
import '../side_menu_scope.dart';
import '../theme/side_menu_theme.dart';
import 'side_menu_item_base.dart';

/// A single tappable item in a [SideMenu].
///
/// Provide at least one of [title], [icon] / [iconWidget], or [builder].
///
/// ```dart
/// SideMenuItem(
///   icon: Icon(Icons.home),
///   title: 'Home',
///   onTap: (index, controller) => controller.goTo(index),
/// )
/// ```
class SideMenuItem extends SideMenuItemBase {
  const SideMenuItem({
    super.key,
    this.title,
    this.icon,
    this.iconWidget,
    this.onTap,
    this.badge,
    this.trailing,
    this.tooltipContent,
    this.builder,
  }) : assert(
          title != null ||
              icon != null ||
              iconWidget != null ||
              builder != null,
          'Provide at least one of title, icon, iconWidget, or builder.',
        );

  /// Label shown in [SideMenuDisplayMode.open].
  final String? title;

  /// Leading icon. Mutually optional with [iconWidget].
  final Icon? icon;

  /// Custom leading widget used when [icon] is null.
  final Widget? iconWidget;

  /// Called when the item is tapped.
  ///
  /// [index] is this item's position in the flat list of selectable items.
  final void Function(int index, SideMenuController controller)? onTap;

  /// Optional badge overlaid on the icon (count, dot, or any widget).
  final Widget? badge;

  /// Widget shown at the trailing edge in [SideMenuDisplayMode.open].
  final Widget? trailing;

  /// Tooltip shown in [SideMenuDisplayMode.compact] when
  /// [SideMenuThemeData.showTooltip] is true. Falls back to [title].
  final String? tooltipContent;

  /// Replaces the default item layout entirely.
  final Widget Function(BuildContext, SideMenuDisplayMode)? builder;

  @override
  State<SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  bool _hovered = false;

  BoxDecoration _itemDecoration(SideMenuThemeData theme, bool selected) {
    if (selected && theme.selectedItemDecoration != null) {
      return theme.selectedItemDecoration!;
    }
    final color = switch ((selected, _hovered)) {
      (true, true) =>
        theme.selectedHoverColor ?? theme.selectedColor ?? Colors.transparent,
      (true, false) => theme.selectedColor ?? Colors.transparent,
      (false, true) => theme.hoverColor ?? Colors.transparent,
      _ => Colors.transparent,
    };
    return BoxDecoration(color: color, borderRadius: theme.itemBorderRadius);
  }

  Widget _buildIcon(SideMenuThemeData theme, bool selected) {
    final color = selected
        ? theme.selectedIconColor ?? Colors.black
        : theme.unselectedIconColor ?? Colors.black54;

    Widget result = widget.icon != null
        ? Icon(widget.icon!.icon, color: color, size: theme.iconSize)
        : widget.iconWidget ?? const SizedBox.shrink();

    if (widget.badge != null) {
      result = Badge(
        label: widget.badge,
        backgroundColor: Colors.red,
        offset: const Offset(-13, -7),
        alignment: Alignment.topRight,
        child: result,
      );
    }
    return result;
  }

  TextStyle _titleStyle(SideMenuThemeData theme, bool selected) {
    const base = TextStyle(fontSize: 17);
    return selected
        ? base.merge(theme.selectedTitleStyle)
        : base.merge(theme.unselectedTitleStyle);
  }

  @override
  Widget build(BuildContext context) {
    final scope = SideMenuScope.of(context);
    final index = SideMenuItemIndex.of(context);

    if (widget.builder != null) {
      return ValueListenableBuilder(
        valueListenable: scope.displayModeNotifier,
        builder: (context, mode, _) => widget.builder!(context, mode),
      );
    }

    final theme = scope.theme.resolve(context);

    return ListenableBuilder(
      listenable: scope.controller,
      builder: (context, _) {
        final selected = scope.controller.currentIndex == index;
        return ValueListenableBuilder(
          valueListenable: scope.displayModeNotifier,
          builder: (context, mode, _) {
            return InkWell(
              onTap: () => widget.onTap?.call(index, scope.controller),
              onHover: (v) => setState(() => _hovered = v),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Padding(
                padding: theme.itemOuterPadding,
                child: Tooltip(
                  message:
                      (mode == SideMenuDisplayMode.compact && theme.showTooltip)
                          ? widget.tooltipContent ?? widget.title ?? ''
                          : '',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: theme.itemHeight,
                    width: double.infinity,
                    decoration: _itemDecoration(theme, selected),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: theme.itemInnerSpacing),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: theme.itemInnerSpacing * 2),
                          _buildIcon(theme, selected),
                          SizedBox(width: theme.itemInnerSpacing),
                          if (mode == SideMenuDisplayMode.open) ...[
                            Expanded(
                              child: Text(
                                widget.title ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: _titleStyle(theme, selected),
                              ),
                            ),
                            if (widget.trailing != null && scope.showTrailing)
                              widget.trailing!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
