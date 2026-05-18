import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_sidemenu Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        // Register SideMenuThemeData so every SideMenu in the app
        // inherits the same look without passing `theme:` each time.
        extensions: const [
          SideMenuThemeData(
            displayMode: SideMenuDisplayMode.auto,
            showHamburger: true,
            selectedColor: Colors.lightBlue,
            selectedIconColor: Colors.white,
            selectedTitleStyle: TextStyle(color: Colors.white),
          ),
        ],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SideMenuController();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Mirror page changes to the PageView.
    _controller.addListener(() {
      _pageController.jumpToPage(_controller.currentIndex);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            controller: _controller,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'easy_sidemenu',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(indent: 8, endIndent: 8),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: const Text('v1.0', style: TextStyle(fontSize: 13)),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                icon: const Icon(Icons.home),
                badge: const Text('3',
                    style: TextStyle(color: Colors.white, fontSize: 11)),
                tooltipContent: 'Dashboard',
                onTap: (i, c) => c.goTo(i),
              ),
              SideMenuItem(
                title: 'Users',
                icon: const Icon(Icons.supervisor_account),
                onTap: (i, c) => c.goTo(i),
              ),
              SideMenuExpansionItem(
                title: 'Expansion',
                icon: const Icon(Icons.kitchen),
                onTap: (i, c, expanded) =>
                    debugPrint('expansion $i expanded=$expanded'),
                children: [
                  SideMenuItem(
                    title: 'Sub-item 1',
                    icon: const Icon(Icons.home),
                    onTap: (i, c) => c.goTo(i),
                  ),
                  SideMenuItem(
                    title: 'Sub-item 2',
                    icon: const Icon(Icons.supervisor_account),
                    onTap: (i, c) => c.goTo(i),
                  ),
                ],
              ),
              SideMenuItem(
                title: 'Files',
                icon: const Icon(Icons.file_copy_rounded),
                trailing: Container(
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  child: const Text('New',
                      style: TextStyle(fontSize: 11)),
                ),
                onTap: (i, c) => c.goTo(i),
              ),
              SideMenuItem(
                title: 'Download',
                icon: const Icon(Icons.download),
                onTap: (i, c) => c.goTo(i),
              ),
              // Divider via custom builder — does not occupy a selectable slot.
              const SideMenuItem(
                builder: _dividerBuilder,
              ),
              SideMenuItem(
                title: 'Settings',
                icon: const Icon(Icons.settings),
                onTap: (i, c) => c.goTo(i),
              ),
              const SideMenuItem(
                title: 'Exit',
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _Page('Dashboard'),
                _Page('Users'),
                _Page('Sub-item 1'),
                _Page('Sub-item 2'),
                _Page('Files'),
                _Page('Download'),
                SizedBox.shrink(), // divider slot
                _Page('Settings'),
                _Page('Exit'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _dividerBuilder(BuildContext context, SideMenuDisplayMode mode) =>
    const Divider(indent: 8, endIndent: 8);

class _Page extends StatelessWidget {
  const _Page(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: const TextStyle(fontSize: 35)),
    );
  }
}
