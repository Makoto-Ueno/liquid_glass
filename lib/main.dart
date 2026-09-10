import 'package:flutter/material.dart';
import 'package:ios_liquid_glass/ios_liquid_glass.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassNativeTabShell.instance.initialize();
  runApp(const LiquidGlassExampleApp());
}

class LiquidGlassExampleApp extends StatelessWidget {
  const LiquidGlassExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Kit',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF015488),
        useMaterial3: true,
      ),
      // LiquidGlassTabScaffold listens to this automatically: the native
      // tab bar hides on any pushed route (e.g. DetailsPage below) without
      // extra wiring, because ModalRoute.isCurrent is checked post-frame.
      navigatorObservers: [LiquidGlassNavigatorObserver.instance],
      debugShowCheckedModeBanner: false,
      home: const RootTabs(),
    );
  }
}

const List<_TabSpec> _tabs = [
  _TabSpec(
    title: 'Home',
    systemImage: 'house',
    selectedSystemImage: 'house.fill',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  _TabSpec(
    title: 'Search',
    systemImage: 'magnifyingglass',
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
  ),
  _TabSpec(
    title: 'Favorites',
    systemImage: 'heart',
    selectedSystemImage: 'heart.fill',
    icon: Icons.favorite_outline,
    selectedIcon: Icons.favorite,
  ),
  _TabSpec(
    title: 'Profile',
    systemImage: 'person.circle',
    selectedSystemImage: 'person.circle.fill',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
];

class _TabSpec {
  const _TabSpec({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    this.systemImage,
    this.selectedSystemImage,
  });

  final String title;
  final String? systemImage;
  final String? selectedSystemImage;
  final IconData icon;
  final IconData selectedIcon;
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _currentIndex = 0;
  bool _barVisible = true;
  bool _favoritesBadgeOn = true;

  bool get _usesNativeTabBar => LiquidGlassPlatform.supportsNativeTabShell;

  List<LiquidGlassTabDestination> get _destinations => [
    LiquidGlassTabDestination(
      title: _tabs[0].title,
      systemImage: _tabs[0].systemImage,
      selectedSystemImage: _tabs[0].selectedSystemImage,
      icon: Icon(_tabs[0].icon),
      selectedIcon: Icon(_tabs[0].selectedIcon),
      page: _HomeTab(
        barVisible: _barVisible,
        onToggleBar: () => setState(() => _barVisible = !_barVisible),
      ),
    ),
    LiquidGlassTabDestination(
      title: _tabs[1].title,
      systemImage: _tabs[1].systemImage,
      selectedSystemImage: _tabs[1].selectedSystemImage,
      icon: Icon(_tabs[1].icon),
      selectedIcon: Icon(_tabs[1].selectedIcon),
      page: const _SearchTab(),
    ),
    LiquidGlassTabDestination(
      title: _tabs[2].title,
      systemImage: _tabs[2].systemImage,
      selectedSystemImage: _tabs[2].selectedSystemImage,
      icon: Icon(_tabs[2].icon),
      selectedIcon: Icon(_tabs[2].selectedIcon),
      badge: _favoritesBadgeOn ? '3' : null,
      page: _FavoritesTab(
        badgeOn: _favoritesBadgeOn,
        onToggleBadge:
            () => setState(() => _favoritesBadgeOn = !_favoritesBadgeOn),
      ),
    ),
    LiquidGlassTabDestination(
      title: _tabs[3].title,
      systemImage: _tabs[3].systemImage,
      selectedSystemImage: _tabs[3].selectedSystemImage,
      icon: Icon(_tabs[3].icon),
      selectedIcon: Icon(_tabs[3].selectedIcon),
      page: const _ProfileTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Liquid Glass · ${_tabs[_currentIndex].title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
        ),
      ),
      body: LiquidGlassTabScaffold(
        destinations: _destinations,
        currentIndex: _currentIndex,
        onIndexChanged: (index) => setState(() => _currentIndex = index),
        barVisible: _barVisible,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A84FF),
        foregroundColor: Colors.white,
        onPressed: () => _showSnack(context, 'FAB tapped'),
        child: const Icon(Icons.edit),
      ),
      floatingActionButtonLocation:
          _usesNativeTabBar
              ? const LiquidGlassNativeTabShellFabLocation()
              : FloatingActionButtonLocation.endFloat,
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

/// Vivid gradient + soft orbs behind every tab — glass is transparent and
/// only reads as "glass" over detailed content.
class _GlassBackdrop extends StatelessWidget {
  const _GlassBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3A0CA3),
            Color(0xFF7209B7),
            Color(0xFFB5179E),
            Color(0xFF4CC9F0),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: Stack(children: [const _BackdropShapes(), child]),
    );
  }
}

Text _sectionTitle(String text) => Text(
  text.toUpperCase(),
  style: const TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w700,
    fontSize: 13,
    letterSpacing: 1.4,
    shadows: [Shadow(color: Colors.black26, blurRadius: 6)],
  ),
);

const TextStyle _buttonLabel = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  shadows: [Shadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 1))],
);

const LiquidGlassStyle _clearStyle = LiquidGlassStyle(
  nativeVariant: NativeGlassVariant.clear,
);

const LiquidGlassStyle _tintedStyle = LiquidGlassStyle(
  nativeTintColor: Color(0xFF0A84FF),
  plainColor: Color(0xFF0A84FF),
);

const LiquidGlassStyle _darkStyle = LiquidGlassStyle(
  nativeTintColor: Colors.black,
  plainColor: Color(0xFF1C1C1E),
);

EdgeInsets _tabPadding(BuildContext context) => EdgeInsets.fromLTRB(
  24,
  MediaQuery.paddingOf(context).top + 72,
  24,
  LiquidGlassTabScaffold.contentBottomClearance(context) + 16,
);

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.barVisible, required this.onToggleBar});

  final bool barVisible;
  final VoidCallback onToggleBar;

  @override
  Widget build(BuildContext context) {
    return _GlassBackdrop(
      child: ListView(
        padding: _tabPadding(context),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: LiquidGlassContainer(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          LiquidGlassPlatform.supportsNativeGlass
                              ? const Color(0xFF30D158)
                              : Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LiquidGlassPlatform.supportsNativeGlass
                        ? 'Native glass · iOS ${LiquidGlassPlatform.osMajorVersion}'
                        : 'Plain fallback',
                    style: _buttonLabel.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _sectionTitle('Buttons'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              LiquidGlassButton(
                onPressed: () => _showSnack(context, 'Regular tapped'),
                child: const Text('Regular', style: _buttonLabel),
              ),
              LiquidGlassButton(
                style: _clearStyle,
                onPressed: () => _showSnack(context, 'Clear tapped'),
                child: const Text('Clear', style: _buttonLabel),
              ),
              LiquidGlassButton(
                style: _tintedStyle,
                onPressed: () => _showSnack(context, 'Tinted tapped'),
                child: const Text('Tinted', style: _buttonLabel),
              ),
              LiquidGlassButton(
                style: _darkStyle,
                onPressed: () => _showSnack(context, 'Dark tapped'),
                child: const Text('Dark', style: _buttonLabel),
              ),
              const LiquidGlassButton(
                onPressed: null,
                child: Text('Disabled', style: _buttonLabel),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _sectionTitle('Icon buttons'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              LiquidGlassIconButton(
                icon: const Icon(Icons.favorite),
                iconColor: Colors.white,
                onPressed: () => _showSnack(context, 'Favorite tapped'),
              ),
              LiquidGlassIconButton(
                icon: const Icon(Icons.share),
                iconColor: Colors.white,
                style: _clearStyle,
                onPressed: () => _showSnack(context, 'Share tapped'),
              ),
              LiquidGlassIconButton(
                icon: const Icon(Icons.add),
                iconColor: Colors.white,
                style: _tintedStyle,
                size: 60,
                iconSize: 28,
                onPressed: () => _showSnack(context, 'Add tapped'),
              ),
              LiquidGlassIconButton(
                icon: const Icon(Icons.settings),
                iconColor: Colors.white,
                style: _darkStyle,
                onPressed: () => _showSnack(context, 'Settings tapped'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _sectionTitle('Navigation'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              LiquidGlassButton(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                style: _darkStyle,
                onPressed:
                    () => Navigator.of(context).push<void>(
                      MaterialPageRoute(builder: (_) => const DetailsPage()),
                    ),
                child: const Text(
                  'Push details page',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              LiquidGlassButton(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                style: _darkStyle,
                onPressed: onToggleBar,
                child: Text(
                  barVisible ? 'Hide bar' : 'Show bar',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              LiquidGlassButton(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                style: _tintedStyle,
                onPressed:
                    () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => const DropletNavDemoPage(),
                      ),
                    ),
                child: const Text(
                  'Liquid droplet nav',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pushed on top of [RootTabs]. LiquidGlassTabScaffold checks
/// `ModalRoute.of(context).isCurrent` on every navigator notification, so
/// the native tab bar hides for as long as this page is on top — no
/// per-route bookkeeping required in the host app.
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _GlassBackdrop(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: LiquidGlassContainer(
              borderRadius: 24,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The native tab bar hid the moment this route pushed, '
                    'and will reappear on pop — driven entirely by '
                    'LiquidGlassNavigatorObserver.',
                    textAlign: TextAlign.center,
                    style: _buttonLabel,
                  ),
                  const SizedBox(height: 20),
                  LiquidGlassButton(
                    style: _tintedStyle,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close', style: _buttonLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchTab extends StatelessWidget {
  const _SearchTab();

  @override
  Widget build(BuildContext context) {
    const results = [
      'Liquid Glass',
      'UIGlassEffect',
      'UITabBarController',
      'Impeller',
    ];
    return _GlassBackdrop(
      child: ListView(
        padding: _tabPadding(context),
        children: [
          LiquidGlassContainer(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white70),
                SizedBox(width: 10),
                Text('Search', style: _buttonLabel),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Results'),
          const SizedBox(height: 12),
          for (final r in results) ...[
            LiquidGlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(r, style: _buttonLabel),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab({required this.badgeOn, required this.onToggleBadge});

  final bool badgeOn;
  final VoidCallback onToggleBadge;

  @override
  Widget build(BuildContext context) {
    const favorites = ['Frosted card', 'Droplet nav', 'Adaptive theme'];
    return _GlassBackdrop(
      child: ListView(
        padding: _tabPadding(context),
        children: [
          LiquidGlassButton(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            style: _darkStyle,
            onPressed: onToggleBadge,
            child: Text(
              badgeOn ? 'Clear badge' : 'Set badge',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('Favorites'),
          const SizedBox(height: 12),
          for (final f in favorites) ...[
            LiquidGlassContainer(
              borderRadius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text(f, style: _buttonLabel),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return _GlassBackdrop(
      child: ListView(
        padding: _tabPadding(context),
        children: [
          Center(
            child: LiquidGlassContainer(
              borderRadius: 28,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Liquid Glass Kit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LiquidGlassPlatform.supportsNativeGlass
                        ? 'iOS ${LiquidGlassPlatform.osMajorVersion} · native tier'
                        : 'plain tier',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft glowing orbs plus a couple of crisp accents behind the glass — the
/// material needs detail to refract, but the shapes stay out of the
/// content's way and blend with the gradient instead of fighting it.
class _BackdropShapes extends StatelessWidget {
  const _BackdropShapes();

  @override
  Widget build(BuildContext context) {
    Widget orb(double size, Color color, {double opacity = 0.55}) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
          stops: const [0.15, 1.0],
        ),
      ),
    );

    Widget ring(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.8), width: 10),
      ),
    );

    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -80,
            child: orb(320, Colors.white, opacity: 0.7),
          ),
          Positioned(
            top: 260,
            right: -120,
            child: orb(320, const Color(0xFF4CC9F0), opacity: 0.9),
          ),
          Positioned(
            top: 560,
            left: -100,
            child: orb(300, const Color(0xFFFF8FAB), opacity: 0.7),
          ),
          Positioned(
            top: 820,
            right: -60,
            child: orb(260, const Color(0xFFFFD166), opacity: 0.6),
          ),
          Positioned(top: 130, right: -30, child: ring(90, Colors.white)),
          Positioned(
            top: 420,
            right: -40,
            child: ring(70, const Color(0xFFFFD166)),
          ),
          Positioned(
            bottom: 90,
            left: -40,
            child: ring(80, const Color(0xFF80FFDB)),
          ),
        ],
      ),
    );
  }
}

/// Pushed from Home. The system tab bar hides itself (observer), and this
/// page stacks [LiquidGlassBottomNav.liquid] over dense, colorful content —
/// the Impeller droplet refracts the album art beneath it (rainbow rim,
/// jelly morph between tabs).
class DropletNavDemoPage extends StatefulWidget {
  const DropletNavDemoPage({super.key});

  @override
  State<DropletNavDemoPage> createState() => _DropletNavDemoPageState();
}

class _AlbumSpec {
  const _AlbumSpec(this.title, this.artist, this.icon, this.colors);

  final String title;
  final String artist;
  final IconData icon;
  final List<Color> colors;
}

const List<_AlbumSpec> _albums = [
  _AlbumSpec('Neon Drift', 'Cassette Club', Icons.graphic_eq, [
    Color(0xFFFF5E7E),
    Color(0xFF8E2DE2),
  ]),
  _AlbumSpec('Ultraviolet', 'Signal Moon', Icons.waves, [
    Color(0xFF4CC9F0),
    Color(0xFF3A0CA3),
  ]),
  _AlbumSpec('Golden Hour', 'Field Notes', Icons.wb_sunny_outlined, [
    Color(0xFFFFB347),
    Color(0xFFFF416C),
  ]),
  _AlbumSpec('Deep End', 'Marlowe', Icons.water_drop_outlined, [
    Color(0xFF00F5A0),
    Color(0xFF00A2C2),
  ]),
  _AlbumSpec('Afterglow', 'Vera Lux', Icons.auto_awesome, [
    Color(0xFFF72585),
    Color(0xFF7209B7),
  ]),
  _AlbumSpec('Night Swim', 'Cobalt', Icons.nightlight_outlined, [
    Color(0xFF5D5FEF),
    Color(0xFF101C4A),
  ]),
];

class _DropletNavDemoPageState extends State<DropletNavDemoPage> {
  int _index = 0;

  // White glyphs over the vivid backdrop; the default theme's dark-blue
  // active color is tuned for light apps.
  static final LiquidGlassTheme _dropletTheme = LiquidGlassTheme(
    activeColor: Colors.white,
    inactiveColor: Colors.white.withValues(alpha: 0.62),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Droplet lens'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _GlassBackdrop(
            child: ListView(
              // Deliberately small bottom padding: the last tiles flow
              // beneath the floating capsule so the lens has pixels to
              // refract. Use contentBottomClearance for regular pages.
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.paddingOf(context).top + 64,
                24,
                12,
              ),
              children: [
                const Text(
                  'Your library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'The droplet below refracts these tiles.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.92,
                  children: [for (final a in _albums) _AlbumTile(spec: a)],
                ),
              ],
            ),
          ),
          // Dark brightness selects the bar's clear-glass appearance
          // (near-transparent capsule + bright droplet) instead of the
          // frosted-white light look — the backdrop here is vivid.
          Theme(
            data: ThemeData(brightness: Brightness.dark, useMaterial3: true),
            child: LiquidGlassBottomNav.liquid(
              currentIndex: _index,
              onIndexChanged: (i) => setState(() => _index = i),
              theme: _dropletTheme,
              chromaticAberration: 0.06,
              items: const [
                LiquidGlassNavItem(
                  label: '',
                  icon: Icon(Icons.play_circle_outline),
                  activeIcon: Icon(Icons.play_circle),
                ),
                LiquidGlassNavItem(label: '', icon: Icon(Icons.search)),
                LiquidGlassNavItem(
                  label: '',
                  icon: Icon(Icons.favorite_outline),
                  activeIcon: Icon(Icons.favorite),
                ),
                LiquidGlassNavItem(
                  label: '',
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.spec});

  final _AlbumSpec spec;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: spec.colors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(spec.icon, color: Colors.white, size: 34),
            const Spacer(),
            Text(
              spec.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              spec.artist,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
