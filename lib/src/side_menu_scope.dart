import 'package:flutter/widgets.dart';

import 'controller/side_menu_controller.dart';
import 'enums/display_mode.dart';
import 'theme/side_menu_theme.dart';

/// Shared state for every widget inside a [SideMenu].
///
/// Exposed to descendants through [SideMenuScope]. Widgets that only
/// care about display-mode changes should listen to [displayModeNotifier]
/// directly rather than this notifier, to avoid unnecessary rebuilds.
class SideMenuScopeData extends ChangeNotifier {
  SideMenuScopeData({
    required this.controller,
    required SideMenuDisplayMode initialDisplayMode,
    required SideMenuThemeData theme,
  })  : _displayMode = initialDisplayMode,
        _theme = theme;

  final SideMenuController controller;

  // ── Display mode ────────────────────────────────────────────────────
  SideMenuDisplayMode _displayMode;
  SideMenuDisplayMode get displayMode => _displayMode;

  /// Notifier for display-mode changes only.
  ///
  /// Item widgets listen to this instead of the full [SideMenuScopeData]
  /// so that a theme change does not force items to rebuild.
  late final ValueNotifier<SideMenuDisplayMode> displayModeNotifier =
      ValueNotifier(_displayMode);

  set displayMode(SideMenuDisplayMode value) {
    if (_displayMode == value) return;
    _displayMode = value;
    displayModeNotifier.value = value;
    notifyListeners();
  }

  // ── Theme ────────────────────────────────────────────────────────────
  SideMenuThemeData _theme;
  SideMenuThemeData get theme => _theme;
  set theme(SideMenuThemeData value) {
    if (_theme == value) return;
    _theme = value;
    notifyListeners();
  }

  // ── Trailing visibility ──────────────────────────────────────────────
  /// Whether trailing widgets on items should be shown.
  ///
  /// Hidden during the collapse animation so the text/trailing doesn't
  /// overflow before the menu has finished narrowing.
  bool _showTrailing = true;
  bool get showTrailing => _showTrailing;
  set showTrailing(bool value) {
    if (_showTrailing == value) return;
    _showTrailing = value;
    notifyListeners();
  }

  @override
  void dispose() {
    displayModeNotifier.dispose();
    super.dispose();
  }
}

/// Carries the flat selectable index of an item through the widget tree.
///
/// [SideMenu] wraps each [SideMenuItemBase] with this widget before
/// rendering, so items never have to scan a list to find their own index.
class SideMenuItemIndex extends InheritedWidget {
  const SideMenuItemIndex({
    super.key,
    required this.index,
    required super.child,
  });

  final int index;

  static int of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<SideMenuItemIndex>();
    assert(widget != null,
        'SideMenuItemIndex not found. Is this item inside a SideMenu?');
    return widget!.index;
  }

  @override
  bool updateShouldNotify(SideMenuItemIndex old) => index != old.index;
}

/// Makes [SideMenuScopeData] available to all descendants of a [SideMenu].
///
/// Use [SideMenuScope.of] inside item widgets to read the controller and
/// current display mode without a `provider` dependency.
class SideMenuScope extends InheritedNotifier<SideMenuScopeData> {
  const SideMenuScope({
    super.key,
    required SideMenuScopeData super.notifier,
    required super.child,
  });

  static SideMenuScopeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SideMenuScope>();
    assert(scope != null,
        'SideMenuScope.of() called outside a SideMenu widget tree.');
    return scope!.notifier!;
  }
}
