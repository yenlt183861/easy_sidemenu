import 'package:flutter/foundation.dart';

/// Controls the currently selected index in a [SideMenu].
///
/// Create one instance, pass it to [SideMenu.controller], and call
/// [goTo] to change the selection programmatically.  Listen for
/// changes with the standard [ChangeNotifier] API:
///
/// ```dart
/// final controller = SideMenuController();
///
/// @override
/// void initState() {
///   super.initState();
///   controller.addListener(() {
///     pageController.jumpToPage(controller.currentIndex);
///   });
/// }
/// ```
class SideMenuController extends ChangeNotifier {
  SideMenuController({int initialIndex = 0}) : _currentIndex = initialIndex;

  int _currentIndex;

  /// The index of the currently selected [SideMenuItem].
  int get currentIndex => _currentIndex;

  /// Selects the item at [index] and notifies listeners.
  ///
  /// No-op when [index] already equals [currentIndex].
  void goTo(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
