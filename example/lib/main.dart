import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ── Theme presets ─────────────────────────────────────────────────────────────

class _Preset {
  const _Preset(this.label, this.theme, {this.background, this.outerPadding});
  final String label;
  final SideMenuThemeData theme;

  /// Optional background decoration displayed behind the whole scaffold Row
  /// (used by glass/frozen themes to show through the blurred menu).
  final BoxDecoration? background;

  /// When set, the SideMenu is wrapped in [Padding] with this value — used
  /// for the floating Card style where the menu hovers above the background.
  final EdgeInsets? outerPadding;
}

final _presets = [
  const _Preset('Ocean', _ocean),
  const _Preset('Midnight', _midnight),
  const _Preset('Aurora', _aurora),
  const _Preset('Minimal', _minimal),
  _glassPreset,
  _frozenPreset,
  _cardPreset,
];

// Non-const presets that use runtime Color.withValues / LinearGradient
final _glassPreset = _Preset(
  'Glass',
  SideMenuThemeData(
    displayMode: SideMenuDisplayMode.auto,
    openWidth: 240,
    compactWidth: 68,
    backdropSigma: 18,
    menuDecoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.18),
      border: Border(
        right:
            BorderSide(color: Colors.white.withValues(alpha: 0.30), width: 1),
      ),
    ),
    selectedColor: Colors.white.withValues(alpha: 0.30),
    selectedIconColor: Colors.white,
    selectedTitleStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    unselectedIconColor: Colors.white70,
    unselectedTitleStyle: const TextStyle(color: Colors.white70, fontSize: 15),
    hoverColor: Colors.white.withValues(alpha: 0.12),
    itemBorderRadius: const BorderRadius.all(Radius.circular(10)),
    itemOuterPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    toggleColor: Colors.white70,
    expansionArrowColor: Colors.white70,
    expansionArrowOpenColor: Colors.white,
  ),
  background: const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 24, 24, 39),
        Color(0xFF16213E),
        Color.fromARGB(255, 19, 69, 129)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
    ),
  ),
);

final _frozenPreset = _Preset(
  'Frozen',
  SideMenuThemeData(
    displayMode: SideMenuDisplayMode.auto,
    openWidth: 240,
    compactWidth: 68,
    backdropSigma: 24,
    menuDecoration: BoxDecoration(
      color: const Color(0xFFE8F4FD).withValues(alpha: 0.22),
      border: Border(
        right: BorderSide(
            color: const Color(0xFFB3D9F2).withValues(alpha: 0.50), width: 1),
      ),
    ),
    selectedColor: const Color(0xFF2196F3).withValues(alpha: 0.25),
    selectedItemDecoration: BoxDecoration(
      color: const Color(0xFF2196F3).withValues(alpha: 0.20),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(
          color: const Color(0xFF2196F3).withValues(alpha: 0.50), width: 1),
    ),
    selectedIconColor: const Color(0xFF0D47A1),
    selectedTitleStyle: const TextStyle(
      color: Color(0xFF0D47A1),
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    unselectedIconColor: const Color(0xFF546E7A),
    unselectedTitleStyle:
        const TextStyle(color: Color(0xFF546E7A), fontSize: 15),
    hoverColor: const Color(0xFF90CAF9).withValues(alpha: 0.20),
    itemBorderRadius: const BorderRadius.all(Radius.circular(10)),
    itemOuterPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    toggleColor: const Color(0xFF546E7A),
    expansionArrowColor: const Color(0xFF546E7A),
    expansionArrowOpenColor: const Color(0xFF1565C0),
  ),
  background: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
);

// 5 ── Card: floating rounded panel, shadow, border — modern sidebar
final _cardPreset = _Preset(
  'Card',
  SideMenuThemeData(
    displayMode: SideMenuDisplayMode.auto,
    openWidth: 240,
    compactWidth: 68,
    menuDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(4, 0),
        ),
      ],
    ),
    selectedItemDecoration: const BoxDecoration(
      color: Color(0xFFEFF6FF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.fromBorderSide(BorderSide(color: Color(0xFFBFDBFE))),
    ),
    selectedIconColor: const Color(0xFF2563EB),
    selectedTitleStyle: const TextStyle(
      color: Color(0xFF1D4ED8),
      fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    unselectedIconColor: const Color(0xFF64748B),
    unselectedTitleStyle:
        const TextStyle(color: Color(0xFF64748B), fontSize: 15),
    hoverColor: const Color(0xFFF8FAFC),
    itemBorderRadius: const BorderRadius.all(Radius.circular(10)),
    itemOuterPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    toggleColor: const Color(0xFF94A3B8),
    expansionArrowColor: const Color(0xFF94A3B8),
    expansionArrowOpenColor: const Color(0xFF2563EB),
  ),
  outerPadding: const EdgeInsets.all(8),
);

// 1 ── Ocean: light background, blue pill, rounded items
const _ocean = SideMenuThemeData(
  displayMode: SideMenuDisplayMode.auto,
  openWidth: 240,
  compactWidth: 68,
  selectedColor: Color(0xFF2563EB),
  selectedIconColor: Colors.white,
  selectedTitleStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ),
  unselectedIconColor: Color(0xFF64748B),
  unselectedTitleStyle: TextStyle(color: Color(0xFF64748B), fontSize: 15),
  itemBorderRadius: BorderRadius.all(Radius.circular(12)),
  itemOuterPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
  hoverColor: Color(0xFFEFF6FF),
);

// 2 ── Midnight: dark sidebar with indigo accent
const _midnight = SideMenuThemeData(
  displayMode: SideMenuDisplayMode.auto,
  openWidth: 240,
  compactWidth: 68,
  menuDecoration: BoxDecoration(color: Color(0xFF0F172A)),
  selectedItemDecoration: BoxDecoration(
    color: Color(0xFF1E293B),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  selectedIconColor: Color(0xFF818CF8),
  selectedTitleStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ),
  unselectedIconColor: Color(0xFF475569),
  unselectedTitleStyle: TextStyle(color: Color(0xFF475569), fontSize: 15),
  hoverColor: Color(0xFF1E293B),
  itemOuterPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
  toggleColor: Color(0xFF94A3B8),
  expansionArrowColor: Color(0xFF475569),
  expansionArrowOpenColor: Color(0xFF818CF8),
);

// 3 ── Aurora: purple-to-indigo gradient sidebar
const _aurora = SideMenuThemeData(
  displayMode: SideMenuDisplayMode.auto,
  openWidth: 240,
  compactWidth: 68,
  menuDecoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
  selectedColor: Color(0x33FFFFFF),
  selectedIconColor: Colors.white,
  selectedTitleStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ),
  unselectedIconColor: Color(0xCCFFFFFF),
  unselectedTitleStyle: TextStyle(color: Color(0xCCFFFFFF), fontSize: 15),
  hoverColor: Color(0x1AFFFFFF),
  itemBorderRadius: BorderRadius.all(Radius.circular(10)),
  itemOuterPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
  toggleColor: Colors.white70,
  expansionArrowColor: Color(0xCCFFFFFF),
  expansionArrowOpenColor: Colors.white,
);

// 4 ── Minimal: white background, left-border active indicator, no radius
const _minimal = SideMenuThemeData(
  displayMode: SideMenuDisplayMode.auto,
  openWidth: 240,
  compactWidth: 68,
  backgroundColor: Color(0xFFF8FAFC),
  selectedItemDecoration: BoxDecoration(
    color: Color(0xFFEFF6FF),
    border: Border(
      left: BorderSide(color: Color(0xFF2563EB), width: 3),
    ),
  ),
  selectedIconColor: Color(0xFF2563EB),
  selectedTitleStyle: TextStyle(
    color: Color(0xFF1E40AF),
    fontWeight: FontWeight.w600,
    fontSize: 15,
  ),
  unselectedIconColor: Color(0xFF94A3B8),
  unselectedTitleStyle: TextStyle(color: Color(0xFF64748B), fontSize: 15),
  hoverColor: Color(0xFFF1F5F9),
  itemBorderRadius: BorderRadius.zero,
  itemOuterPadding: EdgeInsets.zero,
);

// ── App ───────────────────────────────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_sidemenu Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
  int _presetIndex = 0;

  @override
  void initState() {
    super.initState();
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
    final preset = _presets[_presetIndex];
    final isDark = preset.label == 'Midnight' ||
        preset.label == 'Aurora' ||
        preset.label == 'Glass';
    final isCard = preset.label == 'Card';

    Widget sideMenuWidget = SideMenu(
      controller: _controller,
      theme: preset.theme,
      alwaysShowFooter: isCard,
      title: _SideMenuHeader(
        presetLabel: preset.label,
        isDark: isDark,
        onNext: () =>
            setState(() => _presetIndex = (_presetIndex + 1) % _presets.length),
      ),
      footer: isCard ? const _CardFooter() : _SideMenuFooter(isDark: isDark),
      items: [
        SideMenuItem(
          title: 'Dashboard',
          icon: const Icon(Icons.dashboard_rounded),
          badge: const Text('3',
              style: TextStyle(color: Colors.white, fontSize: 10)),
          tooltipContent: 'Dashboard',
          onTap: (i, c) => c.goTo(i),
        ),
        SideMenuItem(
          title: 'Users',
          icon: const Icon(Icons.people_rounded),
          onTap: (i, c) => c.goTo(i),
        ),
        SideMenuExpansionItem(
          title: 'Projects',
          icon: const Icon(Icons.folder_rounded),
          children: [
            SideMenuItem(
              title: 'Active',
              icon: const Icon(Icons.circle, size: 10),
              onTap: (i, c) => c.goTo(i),
            ),
            SideMenuItem(
              title: 'Archived',
              icon: const Icon(Icons.circle_outlined, size: 10),
              onTap: (i, c) => c.goTo(i),
            ),
          ],
        ),
        SideMenuItem(
          title: 'Files',
          icon: const Icon(Icons.folder_copy_rounded),
          trailing: Container(
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: const Text('New',
                style: TextStyle(fontSize: 10, color: Colors.white)),
          ),
          onTap: (i, c) => c.goTo(i),
        ),
        SideMenuItem(
          title: 'Analytics',
          icon: const Icon(Icons.bar_chart_rounded),
          onTap: (i, c) => c.goTo(i),
        ),
        const SideMenuItem(builder: _dividerBuilder),
        SideMenuItem(
          title: 'Settings',
          icon: const Icon(Icons.settings_rounded),
          onTap: (i, c) => c.goTo(i),
        ),
        const SideMenuItem(
          title: 'Sign out',
          icon: Icon(Icons.logout_rounded),
        ),
      ],
    );

    if (preset.outerPadding != null) {
      sideMenuWidget =
          Padding(padding: preset.outerPadding!, child: sideMenuWidget);
    }

    final body = Row(
      children: [
        sideMenuWidget,
        if (!isCard) const VerticalDivider(width: 0),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _Page('Dashboard', Icons.dashboard_rounded),
              _Page('Users', Icons.people_rounded),
              SizedBox.shrink(),
              _Page('Active projects', Icons.circle),
              _Page('Archived projects', Icons.circle_outlined),
              _Page('Files', Icons.folder_copy_rounded),
              _Page('Analytics', Icons.bar_chart_rounded),
              SizedBox.shrink(),
              _Page('Settings', Icons.settings_rounded),
              _Page('Sign out', Icons.logout_rounded),
            ],
          ),
        ),
      ],
    );

    final bg = preset.background;
    return Scaffold(
      backgroundColor: isCard ? const Color(0xFFF1F5F9) : null,
      body: bg != null ? Container(decoration: bg, child: body) : body,
    );
  }
}

Widget _dividerBuilder(BuildContext context, SideMenuDisplayMode mode) =>
    const Divider(indent: 8, endIndent: 8, height: 24);

// ── Side menu header ──────────────────────────────────────────────────────────

class _SideMenuHeader extends StatelessWidget {
  const _SideMenuHeader({
    required this.presetLabel,
    required this.isDark,
    required this.onNext,
  });

  final String presetLabel;
  final bool isDark;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white70 : Colors.black87;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 8, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'easy_sidemenu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.palette_outlined, size: 18, color: textColor),
            tooltip: 'Switch theme ($presetLabel)',
            onPressed: onNext,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

// ── Side menu footer ──────────────────────────────────────────────────────────

class _SideMenuFooter extends StatelessWidget {
  const _SideMenuFooter({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF2563EB),
            child: Text('M',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mohammad 🇮🇷',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87),
                    overflow: TextOverflow.ellipsis),
                Text('Admin',
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card footer (floating preset) ────────────────────────────────────────────

class _CardFooter extends StatelessWidget {
  const _CardFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 16, color: Color(0xFFE2E8F0)),
          const _CardAction(
              icon: Icons.add_circle_outline_rounded,
              label: 'New Project',
              color: Color(0xFF2563EB)),
          // const _CardAction(
          //     icon: Icons.search_rounded,
          //     label: 'Search',
          //     color: Color(0xFF64748B)),
          // const _CardAction(
          //     icon: Icons.people_outline_rounded,
          //     label: 'Invite teammate',
          //     color: Color(0xFF64748B)),
          // const _CardAction(
          //     icon: Icons.keyboard_rounded,
          //     label: 'Shortcuts',
          //     color: Color(0xFF94A3B8)
          // ),
          const SizedBox(height: 6),
          const SizedBox(height: 2),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF2563EB),
                  child: Text('M',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mohammad',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B)),
                          overflow: TextOverflow.ellipsis),
                      Text('Pro Plan',
                          style: TextStyle(
                              fontSize: 10, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Icon(Icons.unfold_more_rounded,
                    size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction(
      {required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
          ],
        ),
      ),
    );
  }
}

// ── Page ──────────────────────────────────────────────────────────────────────

class _Page extends StatelessWidget {
  const _Page(this.label, this.icon);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(label,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
