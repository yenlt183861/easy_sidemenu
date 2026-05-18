import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../enums/display_mode.dart';

/// Visual configuration for a [SideMenu].
///
/// Add to your [ThemeData] so every [SideMenu] in the app inherits the
/// same look without repeating parameters:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       SideMenuThemeData(
///         selectedColor: Colors.blue,
///       ),
///     ],
///   ),
/// )
/// ```
///
/// Or pass directly to [SideMenu.theme] to override for a single menu.
///
/// All color/text-style fields default to `null`, which tells the menu
/// to derive values from the ambient [ColorScheme] / [TextTheme].
@immutable
class SideMenuThemeData extends ThemeExtension<SideMenuThemeData> {
  const SideMenuThemeData({
    this.displayMode = SideMenuDisplayMode.auto,
    this.openWidth = 300,
    this.compactWidth = 70,
    this.collapseWidth = 600,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor,
    this.selectedHoverColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.iconSize = 24,
    this.selectedTitleStyle,
    this.unselectedTitleStyle,
    this.itemHeight = 50,
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.itemOuterPadding =
        const EdgeInsets.symmetric(horizontal: 5),
    this.itemInnerSpacing = 8,
    this.showTooltip = true,
    this.showHamburger = false,
    this.toggleColor,
    this.expansionArrowColor,
    this.expansionArrowOpenColor,
  });

  // ── Layout ───────────────────────────────────────────────────────────
  final SideMenuDisplayMode displayMode;

  /// Width in [SideMenuDisplayMode.open].
  final double openWidth;

  /// Width in [SideMenuDisplayMode.compact].
  final double compactWidth;

  /// Screen width (px) at which [SideMenuDisplayMode.auto] switches from
  /// open → compact.
  final double collapseWidth;

  // ── Colors ───────────────────────────────────────────────────────────
  /// Menu background. Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Selected-item highlight. Defaults to [ColorScheme.primaryContainer].
  final Color? selectedColor;

  /// Hover color. Defaults to [ColorScheme.onSurface] at 8 % opacity.
  final Color? hoverColor;

  /// Hover color when item is also selected.
  final Color? selectedHoverColor;

  /// Icon color when selected. Defaults to [ColorScheme.onPrimaryContainer].
  final Color? selectedIconColor;

  /// Icon color when unselected. Defaults to [ColorScheme.onSurfaceVariant].
  final Color? unselectedIconColor;

  final double iconSize;

  // ── Typography ───────────────────────────────────────────────────────
  /// Defaults to [TextTheme.labelLarge] with [ColorScheme.onPrimaryContainer].
  final TextStyle? selectedTitleStyle;

  /// Defaults to [TextTheme.labelLarge] with [ColorScheme.onSurfaceVariant].
  final TextStyle? unselectedTitleStyle;

  // ── Item sizing / spacing ────────────────────────────────────────────
  final double itemHeight;
  final BorderRadius itemBorderRadius;
  final EdgeInsetsGeometry itemOuterPadding;
  final double itemInnerSpacing;

  // ── Misc ─────────────────────────────────────────────────────────────
  final bool showTooltip;
  final bool showHamburger;

  /// Toggle-button icon color. Defaults to [ColorScheme.onSurfaceVariant].
  final Color? toggleColor;

  /// Arrow color for expansion items in collapsed state.
  final Color? expansionArrowColor;

  /// Arrow color for expansion items in open state.
  final Color? expansionArrowOpenColor;

  // ── ThemeExtension ───────────────────────────────────────────────────
  @override
  SideMenuThemeData copyWith({
    SideMenuDisplayMode? displayMode,
    double? openWidth,
    double? compactWidth,
    double? collapseWidth,
    Color? backgroundColor,
    Color? selectedColor,
    Color? hoverColor,
    Color? selectedHoverColor,
    Color? selectedIconColor,
    Color? unselectedIconColor,
    double? iconSize,
    TextStyle? selectedTitleStyle,
    TextStyle? unselectedTitleStyle,
    double? itemHeight,
    BorderRadius? itemBorderRadius,
    EdgeInsetsGeometry? itemOuterPadding,
    double? itemInnerSpacing,
    bool? showTooltip,
    bool? showHamburger,
    Color? toggleColor,
    Color? expansionArrowColor,
    Color? expansionArrowOpenColor,
  }) {
    return SideMenuThemeData(
      displayMode: displayMode ?? this.displayMode,
      openWidth: openWidth ?? this.openWidth,
      compactWidth: compactWidth ?? this.compactWidth,
      collapseWidth: collapseWidth ?? this.collapseWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedColor: selectedColor ?? this.selectedColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedHoverColor: selectedHoverColor ?? this.selectedHoverColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      unselectedIconColor: unselectedIconColor ?? this.unselectedIconColor,
      iconSize: iconSize ?? this.iconSize,
      selectedTitleStyle: selectedTitleStyle ?? this.selectedTitleStyle,
      unselectedTitleStyle:
          unselectedTitleStyle ?? this.unselectedTitleStyle,
      itemHeight: itemHeight ?? this.itemHeight,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemOuterPadding: itemOuterPadding ?? this.itemOuterPadding,
      itemInnerSpacing: itemInnerSpacing ?? this.itemInnerSpacing,
      showTooltip: showTooltip ?? this.showTooltip,
      showHamburger: showHamburger ?? this.showHamburger,
      toggleColor: toggleColor ?? this.toggleColor,
      expansionArrowColor: expansionArrowColor ?? this.expansionArrowColor,
      expansionArrowOpenColor:
          expansionArrowOpenColor ?? this.expansionArrowOpenColor,
    );
  }

  @override
  SideMenuThemeData lerp(SideMenuThemeData? other, double t) {
    if (other == null) return this;
    return SideMenuThemeData(
      displayMode: t < 0.5 ? displayMode : other.displayMode,
      openWidth: lerpDouble(openWidth, other.openWidth, t)!,
      compactWidth: lerpDouble(compactWidth, other.compactWidth, t)!,
      collapseWidth: lerpDouble(collapseWidth, other.collapseWidth, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t),
      selectedHoverColor:
          Color.lerp(selectedHoverColor, other.selectedHoverColor, t),
      selectedIconColor:
          Color.lerp(selectedIconColor, other.selectedIconColor, t),
      unselectedIconColor:
          Color.lerp(unselectedIconColor, other.unselectedIconColor, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      selectedTitleStyle:
          TextStyle.lerp(selectedTitleStyle, other.selectedTitleStyle, t),
      unselectedTitleStyle: TextStyle.lerp(
          unselectedTitleStyle, other.unselectedTitleStyle, t),
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t)!,
      itemBorderRadius:
          BorderRadius.lerp(itemBorderRadius, other.itemBorderRadius, t)!,
      itemOuterPadding:
          EdgeInsetsGeometry.lerp(itemOuterPadding, other.itemOuterPadding, t)!,
      itemInnerSpacing:
          lerpDouble(itemInnerSpacing, other.itemInnerSpacing, t)!,
      showTooltip: t < 0.5 ? showTooltip : other.showTooltip,
      showHamburger: t < 0.5 ? showHamburger : other.showHamburger,
      toggleColor: Color.lerp(toggleColor, other.toggleColor, t),
      expansionArrowColor:
          Color.lerp(expansionArrowColor, other.expansionArrowColor, t),
      expansionArrowOpenColor: Color.lerp(
          expansionArrowOpenColor, other.expansionArrowOpenColor, t),
    );
  }

  /// Resolves this theme against the ambient [ColorScheme] / [TextTheme],
  /// filling in `null` fields with Material 3 defaults.
  SideMenuThemeData resolve(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return copyWith(
      backgroundColor: backgroundColor ?? cs.surface,
      selectedColor: selectedColor ?? cs.primaryContainer,
      hoverColor: hoverColor ?? cs.onSurface.withValues(alpha: 0.08),
      selectedHoverColor:
          selectedHoverColor ?? cs.primaryContainer.withValues(alpha: 0.8),
      selectedIconColor: selectedIconColor ?? cs.onPrimaryContainer,
      unselectedIconColor: unselectedIconColor ?? cs.onSurfaceVariant,
      selectedTitleStyle: selectedTitleStyle ??
          tt.labelLarge?.copyWith(color: cs.onPrimaryContainer),
      unselectedTitleStyle: unselectedTitleStyle ??
          tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
      toggleColor: toggleColor ?? cs.onSurfaceVariant,
      expansionArrowColor: expansionArrowColor ?? cs.onSurfaceVariant,
      expansionArrowOpenColor: expansionArrowOpenColor ?? cs.primary,
    );
  }

  /// Returns the [SideMenuThemeData] from the nearest [Theme] extension,
  /// or a default instance if none is registered.
  static SideMenuThemeData of(BuildContext context) {
    return Theme.of(context).extension<SideMenuThemeData>() ??
        const SideMenuThemeData();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SideMenuThemeData &&
          runtimeType == other.runtimeType &&
          displayMode == other.displayMode &&
          openWidth == other.openWidth &&
          compactWidth == other.compactWidth &&
          collapseWidth == other.collapseWidth &&
          backgroundColor == other.backgroundColor &&
          selectedColor == other.selectedColor &&
          hoverColor == other.hoverColor &&
          selectedHoverColor == other.selectedHoverColor &&
          selectedIconColor == other.selectedIconColor &&
          unselectedIconColor == other.unselectedIconColor &&
          iconSize == other.iconSize &&
          selectedTitleStyle == other.selectedTitleStyle &&
          unselectedTitleStyle == other.unselectedTitleStyle &&
          itemHeight == other.itemHeight &&
          itemBorderRadius == other.itemBorderRadius &&
          itemOuterPadding == other.itemOuterPadding &&
          itemInnerSpacing == other.itemInnerSpacing &&
          showTooltip == other.showTooltip &&
          showHamburger == other.showHamburger &&
          toggleColor == other.toggleColor &&
          expansionArrowColor == other.expansionArrowColor &&
          expansionArrowOpenColor == other.expansionArrowOpenColor;

  @override
  int get hashCode => Object.hashAll([
        displayMode,
        openWidth,
        compactWidth,
        collapseWidth,
        backgroundColor,
        selectedColor,
        hoverColor,
        selectedHoverColor,
        selectedIconColor,
        unselectedIconColor,
        iconSize,
        selectedTitleStyle,
        unselectedTitleStyle,
        itemHeight,
        itemBorderRadius,
        itemOuterPadding,
        itemInnerSpacing,
        showTooltip,
        showHamburger,
        toggleColor,
        expansionArrowColor,
        expansionArrowOpenColor,
      ]);
}
