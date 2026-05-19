## [1.0.0]

This is a full rewrite. See [MIGRATION.md](MIGRATION.md) for a step-by-step upgrade guide.

### Breaking changes
- **Minimum SDK**: Dart `>=3.4.0`, Flutter `>=3.22.0`
- **`provider` removed**: no longer a transitive dependency
- **`SideMenuStyle` removed**: replaced by `SideMenuThemeData` (a `ThemeExtension`)
- **`SideMenuController`**: now extends `ChangeNotifier`; `changePage(i)` → `goTo(i)`, `currentPage` → `currentIndex`, stream-based listener removed
- **`SideMenuItemType`** interface renamed to `SideMenuItemBase`
- `SideMenuExpansionItem.initialExpanded` renamed to `initiallyExpanded`
- `SideMenuItem.badgeContent` renamed to `badge`; `badgeColor` removed (style the badge widget directly)
- Internal types `SideMenuItemWithGlobal`, `Global`, `DisplayModeNotifier` removed from public exports

### New features
- **`SideMenuThemeData`** is a full `ThemeExtension` — register once in `ThemeData.extensions` for app-wide defaults, or pass to `SideMenu.theme` per-widget
- **`menuDecoration: BoxDecoration?`** — full decoration control (gradient, shadow, border) for the menu container
- **`backdropSigma: double?`** — enables glassmorphism via `BackdropFilter`; wrap the menu in a transparent `menuDecoration` to see through to the background
- **`selectedItemDecoration: BoxDecoration?`** — full decoration for the selected item (gradient pill, left-border indicator, glow)
- **`SideMenuThemeData.resolve(context)`** — fills `null` fields from the ambient `ColorScheme`/`TextTheme` (Material 3)
- `SideMenu.height` now stretches to available space (`double.infinity`) so the widget works correctly inside a `Padding` wrapper
- Timers are properly cancelled on `dispose()` — no more widget-test timer leaks

### Bug fixes
- Compact width no longer resets after navigating away and returning (#46)
- All `SideMenuExpansionItem` children receive correct stable flat indices via `SideMenuItemIndex` `InheritedWidget`

### Other
- `provider` dependency dropped entirely
- Architecture rewritten: `SideMenuScope` (`InheritedNotifier`) replaces `provider` globals
- 25 unit + widget tests added; GitHub Actions CI pipeline added
- `MIGRATION.md` documents every breaking change with before/after examples

---

## [0.7.1]
* Fix: Preserve menu state on hot reload [#89](https://github.com/Jamalianpour/easy_sidemenu/pull/89)
* Fix: export side_menu_item_type [#90](https://github.com/Jamalianpour/easy_sidemenu/pull/90)
* Fix some typo in example

## [0.7.0]
* Refactored the `Global` class to extend `ChangeNotifier`.
* Optimized Width Calculation
* Removed `itemsUpdate` Mechanism
* `SideMenuItemType` as a base interface for `SideMenuItem` and `SideMenuExpansionItem`.

## [0.6.1]
* **New Features**
  * add onTap event -> `SideMenuExpansionItem` [#85](https://github.com/Jamalianpour/easy_sidemenu/pull/85)

* Removed `Badge` dependencies and use Flutter builtin `Badge`
* Fix RTL issues

## [0.6.0]
* **New Features** 
  * Add expansion item -> `SideMenuExpansionItem`
  * Add Hamburger Icon [#77](https://github.com/Jamalianpour/easy_sidemenu/pull/77)

* Fix: width not being returned on 2nd load [#61](https://github.com/Jamalianpour/easy_sidemenu/pull/61)
* Refactor codes

## [0.5.0]
* **Braking**: priority has been removed from `SideMenuItem`
* builder has been changed and now can use any widget as `SideMenuItem`
* Fix some performance issue

## [0.4.2]
* Fix issue [#46](https://github.com/Jamalianpour/easy_sidemenu/issues/46): the width is not properly calculated when the widget is drawn a second time - [#58](https://github.com/Jamalianpour/easy_sidemenu/pull/58)
* Fix error on builder - [#39](https://github.com/Jamalianpour/easy_sidemenu/issues/39)
* Update readme

## [0.4.1+1]
* Fix Badge error on flutter 3.7.0

## [0.4.1]
* Custom builder available for `SideMenuItem`
* Fix SideMenu dispose - [#29](https://github.com/Jamalianpour/easy_sidemenu/issues/29)

## [0.4.0]
* Custom collapse breakpoint feature  - [#17](https://github.com/Jamalianpour/easy_sidemenu/pull/17)
* Add tooltip to `SideMenuItem` - [#20](https://github.com/Jamalianpour/easy_sidemenu/pull/20)
* Change `SideMenuItem` title to optional - [#24](https://github.com/Jamalianpour/easy_sidemenu/pull/24)
* Fix issue SideMenu doesn't show when navigation back and forth - [#27](https://github.com/Jamalianpour/easy_sidemenu/pull/27)
* Add trailing widget to `SideMenuItem`

## [0.3.2]
* Fix delete menu from widget tree - [#15](https://github.com/Jamalianpour/easy_sidemenu/pull/15)
* Add alwaysShowFooter

## [0.3.1]
* Fix null exception on `onDisplayModeChanged`
* Fix `WidgetsBinding.instance` null checker in flutter 3

## [0.3.0]
* Add listener to `SideMenuDisplayMode` changed
* Add toggle button to open and compact sidemenu
* Refactor code by [myConsciousness](https://github.com/myConsciousness) - [#8](https://github.com/Jamalianpour/easy_sidemenu/pull/8)

## [0.2.1]
* Support RTL languages
* Add `decoration` to `SideMenuStyle`
* Fix initialPage bug

## [0.2.0]
* Add badge support to the sidemenu
* Change IconData to Icon for more flexibility

## [0.1.1+1]
* Add demo to readme

## [0.1.1]
* Add readme to package

## [0.1.0] 
* First release