import 'package:flutter/material.dart';
import 'package:glassmorphic_ui/glassmorphic_ui.dart';

void main() {
  runApp(const LiquidGlassDemoApp());
}

class LiquidGlassDemoApp extends StatefulWidget {
  const LiquidGlassDemoApp({super.key});

  @override
  State<LiquidGlassDemoApp> createState() => _LiquidGlassDemoAppState();
}

class _LiquidGlassDemoAppState extends State<LiquidGlassDemoApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() => setState(() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  });

  @override
  Widget build(BuildContext context) {
    const glassTheme = LiquidGlassTheme();

    return MaterialApp(
      title: 'Liquid Glass UI',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF667eea)),
        useMaterial3: true,
        extensions: const [glassTheme],
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667eea),
          brightness: Brightness.dark,
        ),
        extensions: const [glassTheme],
      ),
      home: HomePage(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _filterA = true;
  bool _filterB = false;
  bool _filterC = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const List<Color> _gradients = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF11998e),
    Color(0xFF38ef7d),
  ];

  Widget get _currentPage {
    switch (_navIndex) {
      case 0:
        return _WidgetsShowcase(
          filterA: _filterA,
          filterB: _filterB,
          filterC: _filterC,
          onFilterA: (v) => setState(() => _filterA = v),
          onFilterB: (v) => setState(() => _filterB = v),
          onFilterC: (v) => setState(() => _filterC = v),
          searchController: _searchController,
        );
      case 1:
        return const _CardsPage();
      case 2:
        return const _DialogsPage();
      default:
        return const _AboutPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;
    final gradientColors =
        isDark
            ? [
              const Color(0xFF0f0c29),
              const Color(0xFF302b63),
              const Color(0xFF24243e),
            ]
            : [const Color(0xFF667eea), const Color(0xFF764ba2)];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
          ),
          // Decorative blobs
          Positioned(
            top: -80,
            right: -60,
            child: _Blob(
              color: _gradients[0].withValues(alpha: 0.4),
              size: 250,
            ),
          ),
          Positioned(
            bottom: 100,
            left: -40,
            child: _Blob(
              color: _gradients[2].withValues(alpha: 0.3),
              size: 200,
            ),
          ),
          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _GlassTopBar(
                  isDark: isDark,
                  onToggleTheme: widget.onToggleTheme,
                  navIndex: _navIndex,
                  titles: const ['Widgets', 'Cards', 'Dialogs', 'About'],
                ),
                Expanded(child: _currentPage),
              ],
            ),
          ),
          // Floating bottom nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassBottomNavigationBar(
              floating: true,
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
              items: const [
                GlassBottomNavItem(
                  icon: Icons.widgets_outlined,
                  activeIcon: Icons.widgets,
                  label: 'Widgets',
                ),
                GlassBottomNavItem(
                  icon: Icons.style_outlined,
                  activeIcon: Icons.style,
                  label: 'Cards',
                  badge: '3',
                ),
                GlassBottomNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Dialogs',
                ),
                GlassBottomNavItem(
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  label: 'About',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTopBar extends StatelessWidget {
  const _GlassTopBar({
    required this.isDark,
    required this.onToggleTheme,
    required this.navIndex,
    required this.titles,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final int navIndex;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Row(
        children: [
          const FlutterLogo(size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Liquid Glass — ${titles[navIndex]}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
    );
  }
}

class _WidgetsShowcase extends StatelessWidget {
  const _WidgetsShowcase({
    required this.filterA,
    required this.filterB,
    required this.filterC,
    required this.onFilterA,
    required this.onFilterB,
    required this.onFilterC,
    required this.searchController,
  });

  final bool filterA;
  final bool filterB;
  final bool filterC;
  final ValueChanged<bool> onFilterA;
  final ValueChanged<bool> onFilterB;
  final ValueChanged<bool> onFilterC;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
      children: [
        _SectionLabel('Search field'),
        GlassTextField(
          controller: searchController,
          hintText: 'Search anything...',
          prefixIcon: Icons.search,
        ),
        _SectionLabel('Filter chips'),
        Wrap(
          spacing: 8,
          children: [
            GlassChip.filter(
              label: 'Design',
              selected: filterA,
              onChanged: onFilterA,
              icon: Icons.palette,
            ),
            GlassChip.filter(
              label: 'Flutter',
              selected: filterB,
              onChanged: onFilterB,
              icon: Icons.flutter_dash,
            ),
            GlassChip.filter(
              label: 'iOS 26',
              selected: filterC,
              onChanged: onFilterC,
              icon: Icons.phone_iphone,
            ),
            GlassChip(label: 'Label', onDeleted: () {}),
          ],
        ),
        _SectionLabel('Buttons'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            GlassButton(onPressed: () {}, child: const Text('Primary')),
            GlassButton(
              onPressed: () {},
              tintColor: Colors.teal,
              tintOpacity: 0.35,
              child: const Text('Tinted'),
            ),
            GlassButton(onPressed: null, child: const Text('Disabled')),
            GlassButton(
              onPressed: () {},
              blurSigma: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.star, size: 16),
                  SizedBox(width: 6),
                  Text('With icon'),
                ],
              ),
            ),
          ],
        ),
        _SectionLabel('Glass container'),
        GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liquid Glass Container',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'A foundational glass surface with real-time backdrop blur, '
                'specular border highlights, and customizable tint overlays.',
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Nested glass containers
        GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          tintOpacity: 0.1,
          child: Row(
            children: [
              GlassContainer(
                width: 60,
                height: 60,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                tintColor: Colors.purple,
                tintOpacity: 0.3,
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nested Glass',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Glass inside glass!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardsPage extends StatelessWidget {
  const _CardsPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
      children: [
        GlassCard(
          header: Row(
            children: [
              const Icon(Icons.wb_sunny, size: 20),
              const SizedBox(width: 8),
              Text(
                'Weather Today',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _WeatherItem(icon: Icons.water_drop, label: '65%'),
              _WeatherItem(icon: Icons.air, label: '12 mph'),
              _WeatherItem(icon: Icons.visibility, label: '10 mi'),
              _WeatherItem(icon: Icons.thermostat, label: 'Feels 68°'),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('San Francisco, CA', style: TextStyle(fontSize: 13)),
              SizedBox(height: 8),
              Text(
                '72°F',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              ),
              Text('Partly cloudy'),
            ],
          ),
        ),
        GlassCard(
          header: Text(
            'Media Player',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.skip_previous), onPressed: () {}),
            GlassButton(
              onPressed: () {},
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(50),
              child: const Icon(Icons.play_arrow),
            ),
            IconButton(icon: const Icon(Icons.skip_next), onPressed: () {}),
          ],
          child: Column(
            children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Neon Horizons',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Text('Synthwave Artist', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        GlassCard(
          tintColor: Colors.blue,
          tintOpacity: 0.2,
          header: Text(
            'Notification',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          actions: [
            TextButton(onPressed: () {}, child: const Text('Dismiss')),
            GlassButton(
              onPressed: () {},
              tintColor: Colors.blue,
              tintOpacity: 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text('Upgrade'),
            ),
          ],
          child: const Text(
            'Your subscription renews in 3 days. Upgrade for unlimited access.',
          ),
        ),
        GlassCard(
          header: Text(
            'Stats Overview',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatItem(value: '12.4K', label: 'Downloads'),
              _StatItem(value: '4.8★', label: 'Rating'),
              _StatItem(value: '98%', label: 'Satisfied'),
            ],
          ),
        ),
      ],
    );
  }
}

class _DialogsPage extends StatelessWidget {
  const _DialogsPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
      children: [
        _SectionLabel('Bottom Sheet'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Tap to open a glass bottom sheet:'),
              const SizedBox(height: 12),
              GlassButton(
                onPressed:
                    () => GlassSheet.show(
                      context: context,
                      isScrollControlled: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Share',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _ShareOption(
                                icon: Icons.message,
                                label: 'Messages',
                              ),
                              _ShareOption(icon: Icons.mail, label: 'Mail'),
                              _ShareOption(
                                icon: Icons.link,
                                label: 'Copy Link',
                              ),
                              _ShareOption(
                                icon: Icons.more_horiz,
                                label: 'More',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                child: const Text('Open Sheet'),
              ),
            ],
          ),
        ),
        _SectionLabel('Alert Dialog'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Tap to open a glass alert dialog:'),
              const SizedBox(height: 12),
              GlassButton(
                onPressed:
                    () => GlassDialog.show<void>(
                      context: context,
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 36,
                        color: Colors.red,
                      ),
                      title: const Text('Delete Item?'),
                      content: const Text(
                        'This action cannot be undone. The item will be permanently removed.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        GlassButton(
                          onPressed: () => Navigator.of(context).pop(),
                          tintColor: Colors.red,
                          tintOpacity: 0.3,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                child: const Text('Open Dialog'),
              ),
            ],
          ),
        ),
        _SectionLabel('Success Dialog'),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('A success confirmation dialog:'),
              const SizedBox(height: 12),
              GlassButton(
                onPressed:
                    () => GlassDialog.show<void>(
                      context: context,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 36,
                        color: Colors.green,
                      ),
                      title: const Text('Success!'),
                      content: const Text(
                        'Your changes have been saved successfully.',
                      ),
                      actions: [
                        GlassButton(
                          onPressed: () => Navigator.of(context).pop(),
                          tintColor: Colors.green,
                          tintOpacity: 0.3,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Text('Great'),
                        ),
                      ],
                    ),
                tintColor: Colors.green,
                tintOpacity: 0.2,
                child: const Text('Open Success Dialog'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Column(
            children: [
              const FlutterLogo(size: 64),
              const SizedBox(height: 16),
              Text(
                'glassmorphic_ui',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'v0.1.0',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'iOS 26-inspired Liquid Glass design system for Flutter. '
                'Beautiful glassmorphism widgets with real-time backdrop blur.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white60
                          : Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _AboutItem(
          icon: Icons.widgets,
          title: '10 Widgets',
          subtitle:
              'Container, Card, Button, AppBar, BottomNav, Sheet, Dialog, TextField, Chip, Scaffold',
        ),
        _AboutItem(
          icon: Icons.palette,
          title: 'Theme System',
          subtitle:
              'ThemeExtension for global defaults — blur, tint, border, elevation',
        ),
        _AboutItem(
          icon: Icons.animation,
          title: 'Animated',
          subtitle:
              'Implicit animations on blur, tint, elevation; spring-based button feedback',
        ),
        _AboutItem(
          icon: Icons.brightness_4,
          title: 'Dark & Light Mode',
          subtitle: 'Automatic adaptation to system brightness',
        ),
        _AboutItem(
          icon: Icons.check_circle,
          title: '33 Tests',
          subtitle: 'Widget and unit tests for all components',
        ),
        const SizedBox(height: 16),
        GlassButton(
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_new, size: 16),
              SizedBox(width: 8),
              Text('pub.dev/packages/glassmorphic_ui'),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Helper widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black45,
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _WeatherItem extends StatelessWidget {
  const _WeatherItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
          width: 56,
          height: 56,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _AboutItem extends StatelessWidget {
  const _AboutItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          GlassContainer(
            width: 44,
            height: 44,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            tintColor: Theme.of(context).colorScheme.primary,
            tintOpacity: 0.3,
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
