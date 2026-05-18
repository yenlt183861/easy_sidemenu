import 'package:flutter/widgets.dart';

/// Sealed base for items that can appear in a [SideMenu].
///
/// Only [SideMenuItem] and [SideMenuExpansionItem] extend this class.
abstract class SideMenuItemBase extends StatefulWidget {
  const SideMenuItemBase({super.key});
}
