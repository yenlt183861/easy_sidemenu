import 'dart:async' show Timer;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'controller/side_menu_controller.dart';
import 'enums/display_mode.dart';
import 'enums/hamburger_mode.dart';
import 'items/side_menu_expansion_item.dart';
import 'items/side_menu_item_base.dart';
import 'layout/side_menu_toggle.dart';
import 'side_menu_scope.dart';
import 'theme/side_menu_theme.dart';

/// A side navigation menu for Flutter.
///
/// Place [SideMenu] at the start of a [Row] alongside the content it controls:
///
/// ```dart
/// Row(
///   children: [
///     SideMenu(
///       controller: _controller,
///       items: [
///         SideMenuItem(
///           icon: Icon(Icons.home),
///           title: 'Home',
///           onTap: (i, c) => c.goTo(i),
///         ),
///       ],
///     ),
///     Expanded(child: _pages[_currentIndex]),
///   ],
/// )
/// ```
///
/// ### Theming
///
/// Register [SideMenuThemeData] in [ThemeData.extensions] to style all menus
/// in the app, or pass [theme] directly to override a single instance.
class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.controller,
    required this.items,
    this.title,
    this.footer,
    this.theme,
    this.showToggle = false,
    this.alwaysShowFooter = false,
    this.collapseWidth = 600,
    this.displayModeToggleDuration = const Duration(milliseconds: 350),
    this.onDisplayModeChanged,
  });

  /// Controls the selected item index.
  final SideMenuController controller;

  /// Ordered list of items. Mix [SideMenuItem] and [SideMenuExpansionItem].
  final List<SideMenuItemBase> items;

  /// Widget shown above the items (logo, app name, etc.).
  final Widget? title;

  /// Widget pinned to the bottom. Hidden in compact mode unless
  /// [alwaysShowFooter] is true.
  final Widget? footer;

  /// Per-menu theme override. Falls back to [SideMenuThemeData.of] from the
  /// ambient [ThemeData].
  final SideMenuThemeData? theme;

  /// Show a collapse/expand toggle button (only in non-auto display mode).
  final bool showToggle;

  /// Keep [footer] visible even in compact mode.
  final bool alwaysShowFooter;

  /// Width (logical pixels) below which auto mode collapses to compact.
  final double collapseWidth;

  /// Duration of the open ↔ compact animation.
  final Duration displayModeToggleDuration;

  /// Called whenever the resolved [SideMenuDisplayMode] changes.
  final ValueChanged<SideMenuDisplayMode>? onDisplayModeChanged;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late SideMenuScopeData _scope;
  SideMenuHamburgerMode _hamburger = SideMenuHamburgerMode.open;
  bool _animating = false;
  Timer? _showTrailingTimer;
  Timer? _animatingTimer;

  @override
  void initState() {
    super.initState();
    // Theme resolved after first frame when context is available.
    _scope = SideMenuScopeData(
      controller: widget.controller,
      initialDisplayMode: widget.theme?.displayMode ?? SideMenuDisplayMode.auto,
      theme: widget.theme ?? const SideMenuThemeData(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope.theme = widget.theme ?? SideMenuThemeData.of(context);
    _recalcMode();
  }

  @override
  void didUpdateWidget(SideMenu old) {
    super.didUpdateWidget(old);
    if (widget.theme != old.theme) {
      _scope.theme = widget.theme ?? SideMenuThemeData.of(context);
      _recalcMode();
    }
  }

  // ── Width / display-mode ──────────────────────────────────────────────

  void _recalcMode() {
    final configured = _scope.theme.displayMode;
    if (configured == SideMenuDisplayMode.auto) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      _applyMode(screenWidth > widget.collapseWidth
          ? SideMenuDisplayMode.open
          : SideMenuDisplayMode.compact);
    } else {
      _applyMode(configured);
    }
  }

  void _applyMode(SideMenuDisplayMode mode) {
    if (_scope.displayMode == mode) return;
    _scope.displayMode = mode;
    _showTrailingTimer?.cancel();
    if (mode == SideMenuDisplayMode.open) {
      _showTrailingTimer = Timer(widget.displayModeToggleDuration, () {
        if (mounted) _scope.showTrailing = true;
      });
    } else {
      _scope.showTrailing = false;
    }
    widget.onDisplayModeChanged?.call(mode);
  }

  double get _menuWidth => switch (_scope.displayMode) {
        SideMenuDisplayMode.open => _scope.theme.openWidth,
        SideMenuDisplayMode.compact => _scope.theme.compactWidth,
        SideMenuDisplayMode.auto => _scope.theme.openWidth,
      };

  // ── Toggle ────────────────────────────────────────────────────────────

  void _onToggleTap() {
    if (_animating) return;
    final next = _scope.displayMode == SideMenuDisplayMode.open
        ? SideMenuDisplayMode.compact
        : SideMenuDisplayMode.open;
    setState(() => _animating = true);
    _animatingTimer?.cancel();
    _animatingTimer = Timer(widget.displayModeToggleDuration,
        () => setState(() => _animating = false));
    _scope.theme = _scope.theme.copyWith(displayMode: next);
    _applyMode(next);
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    _recalcMode();

    final theme = _scope.theme;
    final isCompact = _scope.displayMode == SideMenuDisplayMode.compact;

    final hamburgerButton = IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => setState(() {
        _hamburger = _hamburger == SideMenuHamburgerMode.open
            ? SideMenuHamburgerMode.close
            : SideMenuHamburgerMode.open;
      }),
    );

    if (theme.showHamburger && _hamburger == SideMenuHamburgerMode.close) {
      return Align(
        alignment: AlignmentDirectional.topStart,
        child: hamburgerButton,
      );
    }

    final menuContent = AnimatedContainer(
      duration: widget.displayModeToggleDuration,
      width: _menuWidth,
      height: double.infinity,
      decoration: theme.menuDecoration ??
          BoxDecoration(
            color: theme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
          ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (theme.showHamburger) hamburgerButton,
                if (isCompact && widget.showToggle)
                  const SizedBox(height: 42),
                if (widget.title != null) widget.title!,
                ..._buildItems(),
              ],
            ),
          ),
          if (widget.footer != null &&
              (!isCompact || widget.alwaysShowFooter))
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.footer!,
            ),
          if (theme.displayMode != SideMenuDisplayMode.auto &&
              widget.showToggle)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: SideMenuToggle(onTap: _onToggleTap),
            ),
        ],
      ),
    );

    final sigma = theme.backdropSigma;
    final menu = sigma != null
        ? ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: menuContent,
            ),
          )
        : menuContent;

    return SideMenuScope(notifier: _scope, child: menu);
  }

  /// Wraps each item with its flat selectable index.
  List<Widget> _buildItems() {
    final result = <Widget>[];
    var flatIndex = 0;
    for (final item in widget.items) {
      result.add(SideMenuItemIndex(index: flatIndex, child: item));
      flatIndex += _itemSize(item);
    }
    return result;
  }

  /// How many selectable slots an item occupies in the flat index space.
  int _itemSize(SideMenuItemBase item) {
    if (item is SideMenuExpansionItem) return 1 + item.children.length;
    return 1;
  }

  @override
  void dispose() {
    _showTrailingTimer?.cancel();
    _animatingTimer?.cancel();
    _scope.dispose();
    super.dispose();
  }
}
