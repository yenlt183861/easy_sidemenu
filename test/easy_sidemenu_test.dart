import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

SideMenu _menu({
  required SideMenuController controller,
  List<SideMenuItemBase>? items,
  SideMenuThemeData? theme,
}) {
  return SideMenu(
    controller: controller,
    theme: theme,
    items: items ??
        [
          SideMenuItem(
            icon: const Icon(Icons.home),
            title: 'Home',
            onTap: (i, c) => c.goTo(i),
          ),
          SideMenuItem(
            icon: const Icon(Icons.settings),
            title: 'Settings',
            onTap: (i, c) => c.goTo(i),
          ),
        ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ── SideMenuController ──────────────────────────────────────────────────────

  group('SideMenuController', () {
    test('initialIndex defaults to 0', () {
      expect(SideMenuController().currentIndex, 0);
    });

    test('initialIndex is respected', () {
      expect(SideMenuController(initialIndex: 3).currentIndex, 3);
    });

    test('goTo updates currentIndex', () {
      final c = SideMenuController();
      c.goTo(2);
      expect(c.currentIndex, 2);
    });

    test('goTo notifies listeners', () {
      final c = SideMenuController();
      int notified = 0;
      c.addListener(() => notified++);
      c.goTo(1);
      expect(notified, 1);
    });

    test('goTo with same index does not notify', () {
      final c = SideMenuController(initialIndex: 1);
      int notified = 0;
      c.addListener(() => notified++);
      c.goTo(1);
      expect(notified, 0);
    });

    test('removeListener stops notifications', () {
      final c = SideMenuController();
      int notified = 0;
      void listener() => notified++;
      c.addListener(listener);
      c.goTo(1);
      c.removeListener(listener);
      c.goTo(2);
      expect(notified, 1);
    });
  });

  // ── SideMenuThemeData ───────────────────────────────────────────────────────

  group('SideMenuThemeData', () {
    test('copyWith preserves unchanged fields', () {
      const base = SideMenuThemeData(openWidth: 250);
      final copy = base.copyWith(compactWidth: 60);
      expect(copy.openWidth, 250);
      expect(copy.compactWidth, 60);
    });

    test('equality is value-based', () {
      const a = SideMenuThemeData(openWidth: 300);
      const b = SideMenuThemeData(openWidth: 300);
      expect(a, equals(b));
    });

    test('lerp at t=0 returns this values', () {
      const a = SideMenuThemeData(openWidth: 200);
      const b = SideMenuThemeData(openWidth: 400);
      expect(a.lerp(b, 0).openWidth, 200);
    });

    test('lerp at t=1 returns other values', () {
      const a = SideMenuThemeData(openWidth: 200);
      const b = SideMenuThemeData(openWidth: 400);
      expect(a.lerp(b, 1).openWidth, 400);
    });

    test('lerp at t=0.5 interpolates widths', () {
      const a = SideMenuThemeData(openWidth: 200);
      const b = SideMenuThemeData(openWidth: 400);
      expect(a.lerp(b, 0.5).openWidth, 300);
    });

    testWidgets('resolve fills in ColorScheme defaults', (tester) async {
      late BuildContext capturedCtx;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          capturedCtx = ctx;
          return const SizedBox();
        }),
      ));
      const theme = SideMenuThemeData();
      final resolved = theme.resolve(capturedCtx);
      expect(resolved.backgroundColor, isNotNull);
      expect(resolved.selectedColor, isNotNull);
    });
  });

  // ── SideMenu widget ─────────────────────────────────────────────────────────

  group('SideMenu', () {
    testWidgets('renders in compact mode at compactWidth', (tester) async {
      const compactWidth = 64.0;
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(_menu(
        controller: controller,
        theme: const SideMenuThemeData(
          displayMode: SideMenuDisplayMode.compact,
          compactWidth: compactWidth,
        ),
      )));
      await tester.pumpAndSettle();
      // .first = the outermost AnimatedContainer (the menu itself); inner ones
      // belong to SideMenuItem hover decorations.
      final width =
          tester.getSize(find.byType(AnimatedContainer).first).width;
      expect(width, compactWidth);
    });

    testWidgets('renders in open mode at openWidth', (tester) async {
      const openWidth = 250.0;
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(_menu(
        controller: controller,
        theme: const SideMenuThemeData(
          displayMode: SideMenuDisplayMode.open,
          openWidth: openWidth,
        ),
      )));
      await tester.pumpAndSettle();
      final width =
          tester.getSize(find.byType(AnimatedContainer).first).width;
      expect(width, openWidth);
    });

    // Regression: https://github.com/Jamalianpour/easy_sidemenu/issues/46
    testWidgets('compact width is preserved after navigation and return',
        (tester) async {
      const compactWidth = 64.0;
      final controller = SideMenuController();

      await tester.pumpWidget(MaterialApp(
        home: _FirstPage(controller: controller, compactWidth: compactWidth),
        routes: {_SecondPage.route: (_) => const _SecondPage()},
      ));
      await tester.pumpAndSettle();

      final w1 =
          tester.getSize(find.byType(AnimatedContainer).first).width;
      expect(w1, compactWidth);

      await tester.tap(find.byType(SideMenuItem).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final w2 =
          tester.getSize(find.byType(AnimatedContainer).first).width;
      expect(w2, compactWidth);

      await tester.pumpWidget(const Placeholder());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tapping item calls onTap with correct index', (tester) async {
      final controller = SideMenuController();
      int? tappedIndex;
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        theme: const SideMenuThemeData(displayMode: SideMenuDisplayMode.open),
        items: [
          SideMenuItem(
            icon: const Icon(Icons.home),
            title: 'Home',
            onTap: (i, c) => tappedIndex = i,
          ),
          SideMenuItem(
            icon: const Icon(Icons.settings),
            title: 'Settings',
            onTap: (i, c) => tappedIndex = i,
          ),
        ],
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      expect(tappedIndex, 1);
    });

    testWidgets('title widget is rendered', (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        title: const Text('My App'),
        items: const [SideMenuItem(icon: Icon(Icons.home), title: 'Home')],
      )));
      expect(find.text('My App'), findsOneWidget);
    });

    testWidgets('footer is visible in open mode', (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        footer: const Text('Footer'),
        theme: const SideMenuThemeData(displayMode: SideMenuDisplayMode.open),
        items: const [SideMenuItem(icon: Icon(Icons.home), title: 'Home')],
      )));
      await tester.pumpAndSettle();
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('footer is hidden in compact mode', (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        footer: const Text('Footer'),
        theme:
            const SideMenuThemeData(displayMode: SideMenuDisplayMode.compact),
        items: const [SideMenuItem(icon: Icon(Icons.home), title: 'Home')],
      )));
      await tester.pumpAndSettle();
      expect(find.text('Footer'), findsNothing);
    });

    testWidgets('alwaysShowFooter shows footer in compact mode',
        (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        footer: const Text('Footer'),
        alwaysShowFooter: true,
        theme:
            const SideMenuThemeData(displayMode: SideMenuDisplayMode.compact),
        items: const [SideMenuItem(icon: Icon(Icons.home), title: 'Home')],
      )));
      await tester.pumpAndSettle();
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('onDisplayModeChanged fires on auto open', (tester) async {
      final modes = <SideMenuDisplayMode>[];
      final controller = SideMenuController();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: SideMenu(
              controller: controller,
              onDisplayModeChanged: modes.add,
              theme: const SideMenuThemeData(
                displayMode: SideMenuDisplayMode.auto,
                collapseWidth: 600,
              ),
              items: const [
                SideMenuItem(icon: Icon(Icons.home), title: 'Home'),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // Drain the showTrailing Future.delayed(350ms) so no timer leaks.
      await tester.pump(const Duration(milliseconds: 400));
      expect(modes, contains(SideMenuDisplayMode.open));
    });
  });

  // ── SideMenuExpansionItem ───────────────────────────────────────────────────

  group('SideMenuExpansionItem', () {
    testWidgets('children are shown after expanding', (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        theme: const SideMenuThemeData(displayMode: SideMenuDisplayMode.open),
        items: const [
          SideMenuExpansionItem(
            icon: Icon(Icons.folder),
            title: 'Group',
            children: [
              SideMenuItem(
                  icon: Icon(Icons.file_copy), title: 'Child 1'),
              SideMenuItem(
                  icon: Icon(Icons.file_copy), title: 'Child 2'),
            ],
          ),
        ],
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Group'));
      await tester.pumpAndSettle();
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('initiallyExpanded shows children immediately',
        (tester) async {
      final controller = SideMenuController();
      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        theme: const SideMenuThemeData(displayMode: SideMenuDisplayMode.open),
        items: const [
          SideMenuExpansionItem(
            icon: Icon(Icons.folder),
            title: 'Group',
            initiallyExpanded: true,
            children: [
              SideMenuItem(icon: Icon(Icons.home), title: 'Child'),
            ],
          ),
        ],
      )));
      await tester.pumpAndSettle();
      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('children receive sequential flat indices', (tester) async {
      final controller = SideMenuController();
      final tappedIndices = <int>[];

      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        theme: const SideMenuThemeData(displayMode: SideMenuDisplayMode.open),
        items: [
          SideMenuItem(
            icon: const Icon(Icons.home),
            title: 'Home',
            onTap: (i, _) => tappedIndices.add(i),
          ),
          SideMenuExpansionItem(
            icon: const Icon(Icons.folder),
            title: 'Group',
            initiallyExpanded: true,
            children: [
              SideMenuItem(
                icon: const Icon(Icons.file_copy),
                title: 'Child 1',
                onTap: (i, _) => tappedIndices.add(i),
              ),
              SideMenuItem(
                icon: const Icon(Icons.file_copy),
                title: 'Child 2',
                onTap: (i, _) => tappedIndices.add(i),
              ),
            ],
          ),
        ],
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.tap(find.text('Child 1'));
      await tester.tap(find.text('Child 2'));

      // Home=0, expansion header=1 (not selectable), Child1=2, Child2=3
      expect(tappedIndices, [0, 2, 3]);
    });
  });

  // ── SideMenuItem builder ────────────────────────────────────────────────────

  group('SideMenuItem builder', () {
    testWidgets('custom builder receives current display mode',
        (tester) async {
      final controller = SideMenuController();
      SideMenuDisplayMode? receivedMode;

      await tester.pumpWidget(_wrap(SideMenu(
        controller: controller,
        theme:
            const SideMenuThemeData(displayMode: SideMenuDisplayMode.compact),
        items: [
          SideMenuItem(
            builder: (ctx, mode) {
              receivedMode = mode;
              return const SizedBox(
                  key: Key('custom'), width: 10, height: 10);
            },
          ),
        ],
      )));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom')), findsOneWidget);
      expect(receivedMode, SideMenuDisplayMode.compact);
    });
  });
}

// ── Navigation helpers for regression test ────────────────────────────────────

class _FirstPage extends StatelessWidget {
  const _FirstPage({required this.controller, required this.compactWidth});

  final SideMenuController controller;
  final double compactWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            controller: controller,
            theme: SideMenuThemeData(
              displayMode: SideMenuDisplayMode.compact,
              compactWidth: compactWidth,
            ),
            items: [
              SideMenuItem(
                icon: const Icon(Icons.send),
                onTap: (_, __) =>
                    Navigator.of(context).pushNamed(_SecondPage.route),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();
  static const route = '/second';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Go Back'),
      ),
    );
  }
}
