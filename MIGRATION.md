# Migration Guide — v0.7 → v1.0

v1.0 is a full rewrite. The public API has changed in several intentional
breaking ways. This guide covers every change with before/after examples.

---

## 1. Minimum SDK

| | Before | After |
|---|---|---|
| Dart SDK | `>=2.14.0` | `>=3.4.0` |
| Flutter | `>=1.17.0` | `>=3.22.0` |

---

## 2. `provider` dependency removed

`provider` is no longer a transitive dependency. If you were relying on it
indirectly, add it explicitly to your own `pubspec.yaml`.

---

## 3. `SideMenuController`

| Before | After |
|---|---|
| `SideMenuController()` | `SideMenuController()` ✓ same |
| `controller.currentPage` | `controller.currentIndex` |
| `controller.changePage(i)` | `controller.goTo(i)` |
| `controller.addListener((index) { ... })` | `controller.addListener(() { use controller.currentIndex })` |
| `controller.stream` | removed — use `addListener` |
| `controller.dispose()` | `controller.dispose()` ✓ same |

`SideMenuController` now extends `ChangeNotifier`, so standard Flutter
listener patterns apply:

```dart
// Before
sideMenu.addListener((index) {
  pageController.jumpToPage(index);
});

// After
controller.addListener(() {
  pageController.jumpToPage(controller.currentIndex);
});
```

---

## 4. `SideMenuStyle` → `SideMenuThemeData`

`SideMenuStyle` is removed. Replace it with `SideMenuThemeData`, which is
a `ThemeExtension` and integrates with Material 3.

### Option A — per-menu (direct replacement)

```dart
// Before
SideMenu(
  style: SideMenuStyle(
    displayMode: SideMenuDisplayMode.auto,
    openSideMenuWidth: 250,
    compactSideMenuWidth: 65,
    selectedColor: Colors.blue,
    hoverColor: Colors.blue.shade50,
    selectedIconColor: Colors.white,
    unselectedIconColor: Colors.black54,
    selectedTitleTextStyle: TextStyle(color: Colors.white),
    showHamburger: true,
  ),
  ...
)

// After
SideMenu(
  theme: SideMenuThemeData(
    displayMode: SideMenuDisplayMode.auto,
    openWidth: 250,
    compactWidth: 65,
    selectedColor: Colors.blue,
    hoverColor: Colors.blue.shade50,
    selectedIconColor: Colors.white,
    unselectedIconColor: Colors.black54,
    selectedTitleStyle: TextStyle(color: Colors.white),
    showHamburger: true,
  ),
  ...
)
```

### Option B — app-wide via `ThemeData` (recommended)

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    extensions: const [
      SideMenuThemeData(
        selectedColor: Colors.blue,
        selectedIconColor: Colors.white,
      ),
    ],
  ),
)
```

### Property rename table

| `SideMenuStyle` | `SideMenuThemeData` |
|---|---|
| `openSideMenuWidth` | `openWidth` |
| `compactSideMenuWidth` | `compactWidth` |
| `selectedTitleTextStyle` | `selectedTitleStyle` |
| `unselectedTitleTextStyle` | `unselectedTitleStyle` |
| `arrowCollapse` | `expansionArrowColor` |
| `arrowOpen` | `expansionArrowOpenColor` |
| `selectedTitleTextStyleExpandable` | removed — inherits `selectedTitleStyle` |
| `unselectedTitleTextStyleExpandable` | removed — inherits `unselectedTitleStyle` |
| `selectedIconColorExpandable` | removed — inherits `selectedIconColor` |
| `unselectedIconColorExpandable` | removed — inherits `unselectedIconColor` |
| `iconSizeExpandable` | removed — inherits `iconSize` |

---

## 5. `SideMenuItem`

```dart
// Before
SideMenuItem(
  title: 'Dashboard',
  icon: Icon(Icons.home),
  badgeContent: Text('3', style: TextStyle(color: Colors.white)),
  badgeColor: Colors.red,
  onTap: (index, _) { sideMenu.changePage(index); },
)

// After
SideMenuItem(
  title: 'Dashboard',
  icon: Icon(Icons.home),
  badge: Text('3', style: TextStyle(color: Colors.white)),
  // badgeColor removed — set background on the Text's parent or use a
  // Badge widget directly inside `badge:`
  onTap: (index, controller) { controller.goTo(index); },
)
```

| Before | After |
|---|---|
| `badgeContent` | `badge` |
| `badgeColor` | removed (style the badge widget yourself) |

---

## 6. `SideMenuExpansionItem`

```dart
// Before
SideMenuExpansionItem(
  title: 'Group',
  icon: Icon(Icons.folder),
  initialExpanded: true,
  children: [...],
)

// After
SideMenuExpansionItem(
  title: 'Group',
  icon: Icon(Icons.folder),
  initiallyExpanded: true,   // renamed
  children: [...],
)
```

---

## 7. `SideMenuItemType` removed

The marker interface `SideMenuItemType` is replaced by `SideMenuItemBase`.
Update your item list type annotation:

```dart
// Before
List<SideMenuItemType> items = [...];

// After
List<SideMenuItemBase> items = [...];
// or just use the inferred type — no annotation needed
```

---

## 8. `SideMenu` — renamed / removed props

| Before | After |
|---|---|
| `style:` | `theme:` |
| `collapseWidth` on `SideMenuStyle` | `collapseWidth` on `SideMenu` directly |

`collapseWidth` is now a first-class parameter on `SideMenu` (not buried
inside the style object), because it controls layout behaviour, not visuals:

```dart
// Before
SideMenu(
  style: SideMenuStyle(displayMode: SideMenuDisplayMode.auto),
  collapseWidth: 700,
  ...
)

// After
SideMenu(
  theme: SideMenuThemeData(displayMode: SideMenuDisplayMode.auto),
  collapseWidth: 700,
  ...
)
```

---

## 9. Internal types removed

These were never part of the public API surface but were accidentally
importable in older versions. They no longer exist:

- `SideMenuItemWithGlobal`
- `SideMenuExpansionItemWithGlobal`
- `SideMenuItemWithGlobalBase`
- `SideMenuItemList`
- `Global` / `DisplayModeNotifier`
- `SideMenuHamburgerMode` (internal enum, no longer exported)
