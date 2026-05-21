/// How a [SideMenu] is displayed.
enum SideMenuDisplayMode {
  /// Switches between [open] and [compact] automatically based on
  /// available width (configurable via [SideMenu.collapseWidth]).
  auto,

  /// Fully expanded: icons and labels visible.
  open,

  /// Collapsed to icon-only.
  compact,
}
