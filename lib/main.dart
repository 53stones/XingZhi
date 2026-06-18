import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const XingZhiApp());
}

class XingZhiApp extends StatelessWidget {
  const XingZhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '行智',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFF080808),
      ),
      home: const XingZhiHome(),
    );
  }
}

enum AppTab {
  home('首页', Icons.home_rounded),
  messages('消息', Icons.chat_bubble_rounded),
  aid('求助', Icons.medical_services_rounded),
  agent('智能', Icons.psychology_alt_rounded),
  profile('我的', Icons.person_rounded);

  const AppTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

class AppColors {
  static const green = Color(0xFFFFD36A);
  static const blue = Color(0xFFFFA12B);
  static const orange = Color(0xFFFF3F1F);
  static const card = Color(0xE8171717);
  static const line = Color(0x5CE0E0E0);
  static const soft = Color(0xE8F2F2F2);
}

class XingZhiHome extends StatefulWidget {
  const XingZhiHome({super.key});

  @override
  State<XingZhiHome> createState() => _XingZhiHomeState();
}

class _XingZhiHomeState extends State<XingZhiHome> {
  AppTab _selectedTab = AppTab.home;
  bool _isDayMode = false;
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showPhonePreview = constraints.maxWidth >= 700;

          if (showPhonePreview) {
            return DesktopPhonePreview(
              isDayMode: _isDayMode,
          child: _AppSurface(
            isDayMode: _isDayMode,
            page: _buildPage(),
            selectedTab: _selectedTab,
            onChanged: (tab) => setState(() => _selectedTab = tab),
          ),
            );
          }

          return _AppSurface(
            isDayMode: _isDayMode,
          page: _buildPage(),
          selectedTab: _selectedTab,
          onChanged: (tab) => setState(() => _selectedTab = tab),
        );
        },
      ),
    );
  }

  Widget _buildPage() {
    return switch (_selectedTab) {
      AppTab.home => HomePage(
          key: const ValueKey('home'),
          isDayMode: _isDayMode,
          onThemeToggle: () => setState(() => _isDayMode = !_isDayMode),
        ),
      AppTab.aid => MutualAidPage(key: const ValueKey('aid'), isDayMode: _isDayMode),
      AppTab.agent => AgentPage(key: const ValueKey('agent'), isDayMode: _isDayMode),
      AppTab.messages => MessagesPage(
          key: const ValueKey('messages'),
          isDayMode: _isDayMode,
        ),
      AppTab.profile => ProfilePage(
          key: const ValueKey('profile'),
          isDayMode: _isDayMode,
          isLoggedIn: _isLoggedIn,
          onLoginToggle: () => setState(() => _isLoggedIn = !_isLoggedIn),
        ),
    };
  }
}

class DesktopPhonePreview extends StatelessWidget {
  const DesktopPhonePreview({
    required this.child,
    required this.isDayMode,
    super.key,
  });

  final Widget child;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: MountainBackground(isDayMode: isDayMode)),
        Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = math.min(390.0, constraints.maxWidth - 48);
              final maxHeight = constraints.maxHeight - 48;
              final width = math.min(maxWidth, maxHeight * 390 / 844);
              final height = width * 844 / 390;

              return Container(
                width: width,
                height: height,
                padding: EdgeInsets.all(width * 0.031),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.128),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDayMode ? const Color(0xFFE9E1D6) : const Color(0xFF1C1C1C),
                      isDayMode ? const Color(0xFF9D9388) : const Color(0xFF7A7A7A),
                      isDayMode ? const Color(0xFF5C554E) : const Color(0xFF030303),
                      isDayMode ? const Color(0xFFFFFFFF) : const Color(0xFFB8B8B8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.55),
                      blurRadius: 70,
                      offset: const Offset(0, 34),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(width * 0.103),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            padding: EdgeInsets.only(top: width * 0.12),
                          ),
                          child: child,
                        ),
                      ),
                      Positioned(
                        top: width * 0.031,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: width * 0.287,
                            height: width * 0.077,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(width * 0.046),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AppSurface extends StatelessWidget {
  const _AppSurface({
    required this.page,
    required this.selectedTab,
    required this.onChanged,
    required this.isDayMode,
  });

  final Widget page;
  final AppTab selectedTab;
  final ValueChanged<AppTab> onChanged;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: MountainBackground(isDayMode: isDayMode)),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: page,
                ),
              ),
              BottomNavigation(
                selectedTab: selectedTab,
                onChanged: onChanged,
                isDayMode: isDayMode,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.isDayMode,
    required this.onThemeToggle,
    super.key,
  });

  final bool isDayMode;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tight = constraints.maxHeight < 680;

        return Padding(
          padding: EdgeInsets.fromLTRB(18, tight ? 8 : 12, 18, tight ? 10 : 14),
          child: Column(
            children: [
              HeaderView(isDayMode: isDayMode, onThemeToggle: onThemeToggle),
              SizedBox(height: tight ? 14 : 20),
              HomeStatusStrip(isDayMode: isDayMode),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: 300,
                      child: SosButton(compact: tight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HeaderView extends StatelessWidget {
  const HeaderView({
    required this.isDayMode,
    required this.onThemeToggle,
    super.key,
  });

  final bool isDayMode;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '行智',
              style: TextStyle(
                color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '户外安全助手',
              style: TextStyle(
                color: isDayMode ? const Color(0xCC1A120D) : AppColors.soft,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        ThemeToggleButton(isDayMode: isDayMode, onThemeToggle: onThemeToggle),
      ],
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    required this.isDayMode,
    required this.onThemeToggle,
    super.key,
  });

  final bool isDayMode;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDayMode ? '当前：白天模式' : '当前：黑夜模式',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onThemeToggle,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDayMode ? const Color(0xFFFFF8EA) : const Color(0xFF1F1F1F),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDayMode ? const Color(0xFFE2C58F) : AppColors.line,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDayMode
                      ? const Color(0xFFFFC15C).withOpacity(0.22)
                      : Colors.black.withOpacity(0.26),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Icon(
              isDayMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDayMode ? const Color(0xFF9A5600) : Colors.white,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI守护户外每一步',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '实时环境感知 · 智能风险预判',
                    style: TextStyle(
                      color: AppColors.soft,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 96,
              height: 38,
              child: CustomPaint(painter: MiniMountainPainter()),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeStatusStrip extends StatelessWidget {
  const HomeStatusStrip({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    final primaryText = isDayMode ? const Color(0xFF1D140C) : Colors.white;
    final secondaryText = isDayMode ? const Color(0xB21D140C) : AppColors.soft;
    final divider = isDayMode ? const Color(0x40A45D09) : AppColors.line;

    return GlassPanel(
      radius: 18,
      isDayMode: isDayMode,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.location_on_rounded, color: AppColors.blue, size: 22),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '四川省阿坝藏族羌族自治州 四姑娘山镇 · 海拔 3,250 米',
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 13,
                          height: 1.22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '31.0621°N, 102.8858°E',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SignalTag(isDayMode: isDayMode),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: divider),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InlineMetric(
                    icon: Icons.wb_sunny_rounded,
                    title: '12°C',
                    subtitle: '多云转晴',
                    color: AppColors.blue,
                    isDayMode: isDayMode,
                  ),
                ),
                Container(width: 1, height: 32, color: divider),
                Expanded(
                  child: _InlineMetric(
                    icon: Icons.warning_rounded,
                    title: '中等风险',
                    subtitle: '风险提醒',
                    color: AppColors.orange,
                    isDayMode: isDayMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDayMode,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 27),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.soft,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ).copyWith(color: isDayMode ? const Color(0xA61D140C) : AppColors.soft),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on_rounded, color: AppColors.green, size: 30),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '当前位置',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Spacer(),
                      SignalTag(),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '四川省阿坝藏族羌族自治州\n四姑娘山镇 · 海拔 3,250 米\n31.0621°N, 102.8858°E',
                    style: TextStyle(
                      color: AppColors.soft,
                      height: 1.55,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const SizedBox(width: 54, height: 54, child: RadarBadge()),
          ],
        ),
      ),
    );
  }
}

class SignalTag extends StatelessWidget {
  const SignalTag({this.isDayMode = false, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xFFFFE8B0) : AppColors.green.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDayMode ? const Color(0xFFFFB33D) : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          '信号良好',
          style: TextStyle(
            color: isDayMode ? const Color(0xFF7A4300) : AppColors.green,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class WeatherRiskCard extends StatelessWidget {
  const WeatherRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.wb_cloudy_rounded, color: Colors.white, size: 34),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('12°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                Text('多云转晴', style: TextStyle(color: AppColors.soft, fontSize: 12)),
              ],
            ),
            Container(
              width: 1,
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: Colors.white.withOpacity(0.18),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('风险提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                  Text(
                    '中等风险',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.priority_high_rounded, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class SosButton extends StatelessWidget {
  const SosButton({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final outerSize = compact ? 232.0 : 264.0;
    final buttonSize = compact ? 136.0 : 152.0;
    final ringBase = compact ? 136.0 : 152.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: outerSize,
                height: outerSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xB8FFB14A),
                      Color(0x52FF3F1F),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              for (var index = 0; index < 3; index++)
                Container(
                  width: ringBase + index * (compact ? 32 : 38),
                  height: ringBase + index * (compact ? 32 : 38),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.orange.withOpacity(0.28 - index * 0.06),
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFC15C), Color(0xFFFF3F1F), Color(0xFF8F0E04)],
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withOpacity(0.7),
                          blurRadius: 34,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SOS', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900)),
                        SizedBox(height: 6),
                        Text('一键求助', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Text(
          '遇到危险，立即获得帮助',
          style: TextStyle(color: AppColors.soft, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 34),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.soft, fontSize: 12, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompactFeatureTile extends StatelessWidget {
  const CompactFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.55)),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.soft,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MutualAidPage extends StatelessWidget {
  const MutualAidPage({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    final requests = [
      HelpRequest('轻微扭伤', '需要弹力绷带', '890m', AppColors.orange),
      HelpRequest('迷路确认', '需要确认下撤路线', '1.2km', AppColors.blue),
      HelpRequest('补给不足', '需要饮用水', '1.6km', AppColors.green),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 14),
      children: [
        Row(
          children: [
            Text(
              '附近互助',
              style: TextStyle(
                color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            SignalTag(isDayMode: isDayMode),
          ],
        ),
        const SizedBox(height: 8),
        GlassPanel(
          radius: 16,
          isDayMode: isDayMode,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _NeedChip(
                        icon: Icons.medical_services_rounded,
                        label: '急救',
                        color: AppColors.orange,
                        isDayMode: isDayMode,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _NeedChip(
                        icon: Icons.route_rounded,
                        label: '路线',
                        color: AppColors.blue,
                        isDayMode: isDayMode,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _NeedChip(
                        icon: Icons.water_drop_rounded,
                        label: '补给',
                        color: AppColors.green,
                        isDayMode: isDayMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    color: isDayMode ? Colors.white.withOpacity(0.64) : Colors.black.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '描述你需要的帮助',
                    style: TextStyle(
                      color: isDayMode ? const Color(0x991A120D) : AppColors.soft,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.add_alert_rounded),
                    label: const Text(
                      '发布需求',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GlassPanel(
          radius: 16,
          isDayMode: isDayMode,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('附近需求', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                for (final request in requests)
                  HelpRequestRow(request: request, isDayMode: isDayMode),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PartnerRow extends StatelessWidget {
  const PartnerRow({
    required this.status,
    required this.distance,
    required this.isDayMode,
    super.key,
  });

  final String status;
  final String distance;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xFFFFEED1) : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle_rounded, color: AppColors.green, size: 24),
          const SizedBox(width: 10),
          Text(status, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(
            distance,
            style: TextStyle(
              color: isDayMode ? const Color(0xB21A120D) : AppColors.soft,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.green),
        ],
      ),
    );
  }
}

class HelpRequest {
  const HelpRequest(this.title, this.detail, this.distance, this.color);

  final String title;
  final String detail;
  final String distance;
  final Color color;
}

class _NeedChip extends StatelessWidget {
  const _NeedChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDayMode,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDayMode ? color.withOpacity(0.16) : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.42)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class HelpRequestRow extends StatelessWidget {
  const HelpRequestRow({required this.request, required this.isDayMode, super.key});

  final HelpRequest request;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xFFFFEED1) : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: request.color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: request.color.withOpacity(0.42)),
            ),
            child: Icon(Icons.sos_rounded, color: request.color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  '${request.detail} · ${request.distance}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDayMode ? const Color(0xB21A120D) : AppColors.soft,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 28,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: const Color(0xFF1A120D),
                padding: const EdgeInsets.symmetric(horizontal: 9),
              ),
              onPressed: () {},
              child: const Text(
                '响应',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DifyWorkflowConfig {
  const DifyWorkflowConfig._();

  // Dify API 服务器地址。你截图里显示的是 https://api.dify.ai/v1
  static const String apiBaseUrl = 'https://api.dify.ai/v1';

  // TODO: 在这里填写你的 Dify App API Key，格式通常以 app- 开头。
  static const String apiKey = 'xxx';

  // 如果开始节点后面新增 latitude / longitude 等输入字段，就写在这里。
  // 你现在的开始节点只有 userinput.query 和 userinput.files，所以 inputs 先保持空。
  static Map<String, dynamic> buildInputs(String question) {
    return {};
  }
}

class DifyWorkflowService {
  const DifyWorkflowService();

  bool get isConfigured =>
      DifyWorkflowConfig.apiBaseUrl.isNotEmpty && DifyWorkflowConfig.apiKey.isNotEmpty;

  Future<String> run(String question) async {
    if (!isConfigured) {
      return 'Dify 接口还没有配置。请在代码里的 DifyWorkflowConfig 填写 apiKey。';
    }

    final response = await http.post(
      Uri.parse('${DifyWorkflowConfig.apiBaseUrl}/chat-messages'),
      headers: {
        'Authorization': 'Bearer ${DifyWorkflowConfig.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'inputs': DifyWorkflowConfig.buildInputs(question),
        'query': question,
        'response_mode': 'blocking',
        'conversation_id': '',
        'user': 'xingzhi-preview-user',
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return 'Dify 请求失败：${response.statusCode}';
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final directAnswer = data['answer'];
    if (directAnswer != null && directAnswer.toString().trim().isNotEmpty) {
      return directAnswer.toString();
    }

    final runData = data['data'];
    if (runData is Map<String, dynamic>) {
      final error = runData['error'];
      if (error != null && error.toString().isNotEmpty) {
        return 'Dify 工作流返回错误：$error';
      }

      final outputs = runData['outputs'];
      final answer = _pickAnswer(outputs);
      if (answer.isNotEmpty) {
        return answer;
      }
    }

    return 'Dify 已返回结果，但没有找到可展示的回答字段。请检查工作流最后的输出变量。';
  }

  String _pickAnswer(dynamic outputs) {
    if (outputs is String) {
      return outputs;
    }
    if (outputs is Map<String, dynamic>) {
      for (final key in const ['answer', 'text', 'result', 'output', 'reply']) {
        final value = outputs[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return const JsonEncoder.withIndent('  ').convert(outputs);
    }
    return '';
  }
}

class _AgentChatEntry {
  const _AgentChatEntry({
    required this.fromAgent,
    required this.text,
    this.tool = false,
  });

  final bool fromAgent;
  final String text;
  final bool tool;
}

class AgentPage extends StatefulWidget {
  const AgentPage({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DifyWorkflowService _workflowService = const DifyWorkflowService();
  final List<_AgentChatEntry> _messages = [
    const _AgentChatEntry(fromAgent: true, text: '您好，行智Agent很高兴为您服务！'),
  ];
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _send([String? preset]) async {
    final question = (preset ?? _controller.text).trim();
    if (question.isEmpty || _isSending) {
      return;
    }

    _controller.clear();
    setState(() {
      _isSending = true;
      _messages.add(_AgentChatEntry(fromAgent: false, text: question));
      _messages.add(const _AgentChatEntry(fromAgent: true, text: '正在调用行智工作流分析...'));
    });
    _scrollToBottom();

    String answer;
    try {
      answer = await _workflowService.run(question);
    } catch (error) {
      answer = 'Dify 工作流调用异常：$error';
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _isSending = false;
      _messages.removeLast();
      _messages.add(_AgentChatEntry(fromAgent: true, text: answer));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Column(
        children: [
          AgentHeader(isDayMode: widget.isDayMode),
          const SizedBox(height: 8),
          Expanded(
            child: GlassPanel(
              radius: 16,
              isDayMode: widget.isDayMode,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 9, 9, 8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 2),
                        children: [
                          for (final message in _messages)
                            if (message.tool)
                              AgentToolCard(isDayMode: widget.isDayMode)
                            else
                              AgentMessageBubble(
                                isDayMode: widget.isDayMode,
                                fromAgent: message.fromAgent,
                                text: message.text,
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    AgentInputBar(
                      isDayMode: widget.isDayMode,
                      controller: _controller,
                      enabled: !_isSending,
                      onSend: () => _send(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentHeader extends StatelessWidget {
  const AgentHeader({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AgentAvatar(size: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '行智 Agent',
                style: TextStyle(
                  color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '在线 · 正在守护',
                style: TextStyle(
                  color: isDayMode ? const Color(0xB21A120D) : AppColors.soft,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.green.withOpacity(0.42)),
          ),
          child: const Text(
            '已连接',
            style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class AgentMessageBubble extends StatelessWidget {
  const AgentMessageBubble({
    required this.isDayMode,
    required this.fromAgent,
    required this.text,
    super.key,
  });

  final bool isDayMode;
  final bool fromAgent;
  final String text;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = fromAgent
        ? (isDayMode ? const Color(0xFFFFEED1) : Colors.white.withOpacity(0.07))
        : AppColors.orange;
    final textColor = fromAgent
        ? (isDayMode ? const Color(0xFF1A120D) : Colors.white)
        : Colors.white;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(fromAgent ? 4 : 14),
          bottomRight: Radius.circular(fromAgent ? 14 : 4),
        ),
        border: fromAgent
            ? Border.all(color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.1))
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 12, height: 1.34, fontWeight: FontWeight.w700),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        mainAxisAlignment: fromAgent ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fromAgent
            ? [
                const AgentAvatar(size: 26),
                const SizedBox(width: 7),
                Flexible(child: bubble),
              ]
            : [
                Flexible(child: bubble),
                const SizedBox(width: 7),
                UserChatAvatar(isDayMode: isDayMode),
              ],
      ),
    );
  }
}

class UserChatAvatar extends StatelessWidget {
  const UserChatAvatar({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xFFFFE7B8) : Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.12),
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        color: isDayMode ? const Color(0xFF8A4A00) : AppColors.green,
        size: 16,
      ),
    );
  }
}

class AgentToolCard extends StatelessWidget {
  const AgentToolCard({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xFFFFF6E8) : Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.route_rounded, color: AppColors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '已调用路线、天气、海拔工具',
              style: TextStyle(
                color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 18),
        ],
      ),
    );
  }
}

class AgentQuickActions extends StatelessWidget {
  const AgentQuickActions({required this.isDayMode, required this.onAction, super.key});

  final bool isDayMode;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AgentQuickChip(
            icon: Icons.shield_rounded,
            label: '评估风险',
            isDayMode: isDayMode,
            onTap: () => onAction('评估当前风险'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _AgentQuickChip(
            icon: Icons.medical_services_rounded,
            label: '急救建议',
            isDayMode: isDayMode,
            onTap: () => onAction('给我急救建议'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _AgentQuickChip(
            icon: Icons.map_rounded,
            label: '路线建议',
            isDayMode: isDayMode,
            onTap: () => onAction('推荐安全路线'),
          ),
        ),
      ],
    );
  }
}

class _AgentQuickChip extends StatelessWidget {
  const _AgentQuickChip({
    required this.icon,
    required this.label,
    required this.isDayMode,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDayMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: isDayMode ? const Color(0xFFFFE7B8) : AppColors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isDayMode ? const Color(0xFF8A4A00) : AppColors.green, size: 15),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  color: isDayMode ? const Color(0xFF8A4A00) : AppColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgentInputBar extends StatelessWidget {
  const AgentInputBar({
    required this.isDayMode,
    required this.controller,
    required this.enabled,
    required this.onSend,
    super.key,
  });

  final bool isDayMode;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 12, right: 5),
      decoration: BoxDecoration(
        color: isDayMode ? Colors.white.withOpacity(0.72) : Colors.black.withOpacity(0.22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDayMode ? const Color(0x66D9A966) : Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              maxLines: 1,
              onSubmitted: (_) => onSend(),
              cursorColor: AppColors.orange,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: '问问行智 Agent...',
                hintStyle: TextStyle(
                  color: isDayMode ? const Color(0x991A120D) : AppColors.soft,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: enabled ? onSend : null,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                enabled ? Icons.arrow_upward_rounded : Icons.hourglass_top_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentAction {
  const AgentAction(this.title, this.subtitle, this.icon, this.color);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class AgentActionRow extends StatelessWidget {
  const AgentActionRow({required this.action, required this.isDayMode, super.key});

  final AgentAction action;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 15,
      isDayMode: isDayMode,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(action.icon, color: action.color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(
                    action.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.soft, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.soft),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.isDayMode,
    required this.isLoggedIn,
    required this.onLoginToggle,
    super.key,
  });

  final bool isDayMode;
  final bool isLoggedIn;
  final VoidCallback onLoginToggle;

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 30, 18, 18),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: _LoginPanel(isDayMode: isDayMode, onLogin: onLoginToggle),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 700;
        final gap = compact ? 5.0 : 14.0;

        final content = Column(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              _SignedInProfile(isDayMode: isDayMode, expanded: !compact),
              SizedBox(height: gap),
              _ProfileSection(
                isDayMode: isDayMode,
                expanded: !compact,
                children: const [
                  ProfileActionRow(
                    icon: Icons.contact_emergency_rounded,
                    title: '紧急联系人',
                    color: AppColors.orange,
                  ),
                  ProfileActionRow(
                    icon: Icons.medical_information_rounded,
                    title: '健康档案',
                    color: AppColors.green,
                  ),
                  ProfileActionRow(
                    icon: Icons.offline_bolt_rounded,
                    title: '离线安全包',
                    color: AppColors.blue,
                  ),
                ],
              ),
              SizedBox(height: gap),
              _ProfileSection(
                isDayMode: isDayMode,
                expanded: !compact,
                children: const [
                  ProfileActionRow(
                    icon: Icons.notifications_active_rounded,
                    title: '通知与提醒',
                    color: AppColors.green,
                  ),
                  ProfileActionRow(
                    icon: Icons.privacy_tip_rounded,
                    title: '隐私与权限',
                    color: AppColors.orange,
                  ),
                ],
              ),
              if (compact) const SizedBox(height: 12) else const Spacer(),
              LogoutButton(onPressed: onLoginToggle, expanded: !compact),
            ],
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(18, compact ? 24 : 24, 18, compact ? 6 : 14),
          child: compact
              ? SingleChildScrollView(child: content)
              : content,
        );
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({required this.onPressed, this.expanded = false, super.key});

  final VoidCallback onPressed;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: expanded ? 44 : 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.orange.withOpacity(0.76), width: 1.2),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.orange, size: 18),
              SizedBox(width: 7),
              Text(
                '退出登录',
                style: TextStyle(
                  color: AppColors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({required this.isDayMode, required this.onLogin});

  final bool isDayMode;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      isDayMode: isDayMode,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(size: 44, isLoggedIn: false, isDayMode: isDayMode),
            const SizedBox(height: 6),
            const Text(
              '未登录',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: FilledButton.icon(
                onPressed: onLogin,
                icon: const Icon(Icons.login_rounded),
                label: const Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedInProfile extends StatelessWidget {
  const _SignedInProfile({required this.isDayMode, this.expanded = false});

  final bool isDayMode;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      isDayMode: isDayMode,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, expanded ? 24 : 18, 14, expanded ? 24 : 18),
            child: Row(
              children: [
                _Avatar(size: expanded ? 72 : 64, isLoggedIn: true, isDayMode: isDayMode),
                SizedBox(width: expanded ? 16 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '山野行者',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDayMode ? Colors.black : Colors.white,
                          fontSize: expanded ? 21 : 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: expanded ? 7 : 5),
                      Text(
                        '138****8621',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDayMode ? const Color(0xB21A120D) : AppColors.soft,
                          fontSize: expanded ? 14 : 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDayMode ? const Color(0x991A120D) : AppColors.soft,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.size,
    required this.isLoggedIn,
    required this.isDayMode,
  });

  final double size;
  final bool isLoggedIn;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLoggedIn
                  ? (isDayMode
                      ? const [Color(0xFFFFE3A6), Color(0xFFFF8A2A)]
                      : const [Color(0xFFFFC15C), Color(0xFFFF3F1F)])
                  : (isDayMode
                      ? const [Color(0xFFFFF8EA), Color(0xFFE6C78E)]
                      : const [Color(0xFF3A3A3A), Color(0xFF111111)]),
            ),
            border: Border.all(
              color: isDayMode ? const Color(0xFFD9A966) : AppColors.line,
              width: 2,
            ),
          ),
          child: Icon(
            isLoggedIn ? Icons.hiking_rounded : Icons.person_rounded,
            size: size * 0.48,
            color: isDayMode ? const Color(0xFF6E3D00) : Colors.white,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDayMode ? const Color(0xFFFFF8EA) : const Color(0xFF171717),
                width: 2,
              ),
            ),
            child: Icon(Icons.edit_rounded, size: size * 0.15, color: const Color(0xFF1A120D)),
          ),
        ),
      ],
    );
  }
}

class _AccountBadge extends StatelessWidget {
  const _AccountBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.green.withOpacity(0.45)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          '安全档案已启用',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.soft,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.isDayMode,
    required this.children,
    this.expanded = false,
  });

  final bool isDayMode;
  final List<Widget> children;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      isDayMode: isDayMode,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, expanded ? 10 : 7, 10, expanded ? 6 : 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final child in children)
              if (child is ProfileActionRow)
                ProfileActionRow(
                  icon: child.icon,
                  title: child.title,
                  color: child.color,
                  expanded: expanded,
                )
              else
                child,
          ],
        ),
      ),
    );
  }
}

class ProfileActionRow extends StatelessWidget {
  const ProfileActionRow({
    required this.icon,
    required this.title,
    required this.color,
    this.expanded = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final Color color;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: expanded ? 7 : 3),
      child: SizedBox(
        height: expanded ? 46 : 38,
        child: Row(
          children: [
            Container(
              width: expanded ? 34 : 28,
              height: expanded ? 34 : 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.42)),
              ),
              child: Icon(icon, color: color, size: expanded ? 19 : 16),
            ),
            SizedBox(width: expanded ? 12 : 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: expanded ? 15 : 13, fontWeight: FontWeight.w900),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.soft),
          ],
        ),
      ),
    );
  }
}

class MessageItem {
  const MessageItem({
    required this.title,
    required this.content,
    required this.time,
    required this.icon,
    required this.color,
    this.unread = false,
  });

  final String title;
  final String content;
  final String time;
  final IconData icon;
  final Color color;
  final bool unread;
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({required this.isDayMode, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    const messages = [
      MessageItem(
        title: '风险提醒',
        content: '西侧碎石坡风力增强，建议 30 分钟内避开该路段。',
        time: '刚刚',
        icon: Icons.warning_rounded,
        color: AppColors.orange,
        unread: true,
      ),
      MessageItem(
        title: '附近响应',
        content: '李明已响应你的互助需求，距离当前位置 890 米。',
        time: '8 分钟前',
        icon: Icons.groups_rounded,
        color: AppColors.green,
        unread: true,
      ),
      MessageItem(
        title: 'Agent 建议',
        content: '已根据天气变化更新返回路线，推荐走东侧缓坡。',
        time: '15 分钟前',
        icon: Icons.psychology_alt_rounded,
        color: AppColors.blue,
      ),
      MessageItem(
        title: '安全档案',
        content: '紧急联系人和离线安全包已同步完成。',
        time: '今天 09:20',
        icon: Icons.verified_user_rounded,
        color: AppColors.green,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      children: [
        Text(
          '消息',
          style: TextStyle(
            color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        GlassPanel(
          radius: 16,
          isDayMode: isDayMode,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Column(
              children: [
                for (var index = 0; index < messages.length; index++) ...[
                  MessageRow(message: messages[index], isDayMode: isDayMode),
                  if (index != messages.length - 1)
                    Divider(
                      height: 10,
                      color: isDayMode ? const Color(0x1F1A120D) : Colors.white.withOpacity(0.08),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MessageRow extends StatelessWidget {
  const MessageRow({required this.message, required this.isDayMode, super.key});

  final MessageItem message;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    final textColor = isDayMode ? const Color(0xFF1A120D) : Colors.white;
    final subColor = isDayMode ? const Color(0xB21A120D) : AppColors.soft;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: message.color.withOpacity(isDayMode ? 0.18 : 0.14),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: message.color.withOpacity(0.38)),
            ),
            child: Icon(message.icon, color: message.color, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        message.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      message.time,
                      style: TextStyle(color: subColor, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  message.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subColor, fontSize: 11, height: 1.28, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          if (message.unread) ...[
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.icon,
    required this.title,
    required this.message,
    required this.isDayMode,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.blue, size: 58),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                color: isDayMode ? const Color(0xFF1A120D) : Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.soft, fontSize: 15, height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.selectedTab,
    required this.onChanged,
    required this.isDayMode,
    super.key,
  });

  final AppTab selectedTab;
  final ValueChanged<AppTab> onChanged;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    final barColor = isDayMode ? const Color(0xF7FFF8EC) : const Color(0xEE120B08);
    final borderColor = isDayMode ? const Color(0xCCD8B06E) : Colors.white.withOpacity(0.14);

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: barColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (final tab in AppTab.values)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    selected: selectedTab == tab,
                    isDayMode: isDayMode,
                    onTap: () => onChanged(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.isDayMode,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final bool isDayMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDayMode ? const Color(0xFF8A4A00) : AppColors.green;
    final inactiveColor = isDayMode ? const Color(0xFF9B8062) : Colors.white.withOpacity(0.46);
    final selectedBg = isDayMode ? const Color(0xFFFFE7B8) : AppColors.green.withOpacity(0.14);

    return Tooltip(
      message: tab.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon, size: 20, color: selected ? activeColor : inactiveColor),
              const SizedBox(height: 3),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? activeColor : inactiveColor,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.radius = 16,
    this.isDayMode = false,
    super.key,
  });

  final Widget child;
  final double radius;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDayMode ? const Color(0xEFFFF7E8) : AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: isDayMode ? const Color(0xB8D9A966) : AppColors.line),
        boxShadow: [
          BoxShadow(
            color: isDayMode
                ? const Color(0xFF6B3D08).withOpacity(0.14)
                : Colors.black.withOpacity(0.26),
            blurRadius: isDayMode ? 22 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: isDayMode
            ? IconTheme.merge(
                data: const IconThemeData(color: Color(0xFF1A120D)),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(color: Color(0xFF1A120D)),
                  child: child,
                ),
              )
            : child,
      ),
    );
  }
}

class RadarBadge extends StatelessWidget {
  const RadarBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: RadarBadgePainter());
  }
}

class AidPin extends StatelessWidget {
  const AidPin({
    required this.distance,
    this.left,
    this.right,
    this.top,
    this.bottom,
    super.key,
  });

  final String distance;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_circle_rounded, color: AppColors.green, size: 30),
          Text(distance, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class MapGrid extends StatelessWidget {
  const MapGrid({this.isDayMode = false, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MapGridPainter(isDayMode: isDayMode));
  }
}

class AgentAvatar extends StatelessWidget {
  const AgentAvatar({this.size = 58, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white, AppColors.blue, Color(0x52FF3F1F)],
          stops: [0.0, 0.48, 1.0],
        ),
      ),
      child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: size * 0.48),
    );
  }
}

class MountainBackground extends StatelessWidget {
  const MountainBackground({this.isDayMode = false, super.key});

  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDayMode
              ? const [Color(0xFFF6F1E9), Color(0xFFD9D0C6), Color(0xFF938B82)]
              : const [Color(0xFF050505), Color(0xFF171717), Color(0xFF3A3A3A)],
        ),
      ),
      child: CustomPaint(painter: MountainBackgroundPainter(isDayMode: isDayMode)),
    );
  }
}

class MountainBackgroundPainter extends CustomPainter {
  const MountainBackgroundPainter({required this.isDayMode});

  final bool isDayMode;

  @override
  void paint(Canvas canvas, Size size) {
    final sunGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.72, -0.82),
        radius: 0.92,
        colors: isDayMode
            ? [
                const Color(0xFFFFF1D2).withOpacity(0.82),
                const Color(0xFFFFC46D).withOpacity(0.28),
                Colors.transparent,
              ]
            : [
                const Color(0xFFE6E6E6).withOpacity(0.18),
                const Color(0xFF8A8A8A).withOpacity(0.12),
                Colors.transparent,
              ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sunGlow);

    final heatGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.68, 0.22),
        radius: 0.78,
        colors: isDayMode
            ? [
                const Color(0xFFFF8A2A).withOpacity(0.18),
                const Color(0xFFFFD36A).withOpacity(0.14),
                Colors.transparent,
              ]
            : [
                const Color(0xFFFF3F1F).withOpacity(0.18),
                const Color(0xFFFFA12B).withOpacity(0.08),
                Colors.transparent,
              ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, heatGlow);

    final mountainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDayMode
            ? [Color(0xA6F6E8D2), Color(0x666C5547)]
            : [Color(0x663A3A3A), Color(0xCC000000)],
      ).createShader(Offset.zero & size);

    final back = Path()
      ..moveTo(0, size.height * 0.62)
      ..lineTo(size.width * 0.22, size.height * 0.46)
      ..lineTo(size.width * 0.38, size.height * 0.58)
      ..lineTo(size.width * 0.57, size.height * 0.36)
      ..lineTo(size.width * 0.78, size.height * 0.61)
      ..lineTo(size.width, size.height * 0.43)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(back, mountainPaint);

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDayMode
            ? [Color(0xFFBBAA96), Color(0xCC4F433A)]
            : [Color(0xFF2B2B2B), Color(0xF4000000)],
      ).createShader(Offset.zero & size);

    final front = Path()
      ..moveTo(0, size.height * 0.78)
      ..lineTo(size.width * 0.2, size.height * 0.68)
      ..lineTo(size.width * 0.5, size.height * 0.76)
      ..lineTo(size.width * 0.7, size.height * 0.62)
      ..lineTo(size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(front, frontPaint);

    _drawContours(canvas, size);
    _drawNetwork(canvas, size);

    final overlay = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDayMode
            ? [Color(0x00FFFFFF), Color(0x4A2A170B)]
            : [Color(0x1F000000), Color(0x8A000000)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, overlay);
  }

  void _drawContours(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.11)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var index = 0; index < 8; index++) {
      final y = index * 58.0;
      final inset = index * 32.0;
      final path = Path()
        ..moveTo(-40 + inset, y)
        ..cubicTo(size.width * 0.26, y - 70, size.width * 0.62, y + 108, size.width + 80, y + 34);
      canvas.drawPath(path, paint);
    }
  }

  void _drawNetwork(Canvas canvas, Size size) {
    final points = [
      const Offset(0.72, 0.12),
      const Offset(0.84, 0.08),
      const Offset(0.92, 0.16),
      const Offset(0.78, 0.22),
      const Offset(0.88, 0.28),
      const Offset(0.96, 0.24),
      const Offset(0.10, 0.66),
      const Offset(0.18, 0.74),
      const Offset(0.04, 0.82),
    ];

    final linePaint = Paint()
      ..color = AppColors.blue.withOpacity(0.28)
      ..strokeWidth = 1;
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.85);
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.32)
      ..style = PaintingStyle.stroke;

    for (var index = 0; index < points.length; index++) {
      final start = Offset(points[index].dx * size.width, points[index].dy * size.height);
      for (var next = index + 1; next < math.min(points.length, index + 3); next++) {
        final end = Offset(points[next].dx * size.width, points[next].dy * size.height);
        canvas.drawLine(start, end, linePaint);
      }
    }

    for (final point in points) {
      final center = Offset(point.dx * size.width, point.dy * size.height);
      canvas.drawCircle(center, 3, dotPaint);
      canvas.drawCircle(center, 12, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MountainBackgroundPainter oldDelegate) {
    return oldDelegate.isDayMode != isDayMode;
  }
}

class MiniMountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xB8B8B8B8), Color(0x665A5A5A)],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);

    final peak = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.23, size.height * 0.48)
      ..lineTo(size.width * 0.4, size.height * 0.78)
      ..lineTo(size.width * 0.62, size.height * 0.2)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(peak, Paint()..color = Colors.white.withOpacity(0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final fill = Paint()..color = AppColors.green.withOpacity(0.14);
    canvas.drawCircle(center, size.shortestSide / 2, fill);
    RadarRingsPainter(AppColors.green).paint(canvas, size);
    final line = Paint()
      ..color = AppColors.green.withOpacity(0.82)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(center.dx, 8), Offset(center.dx, size.height - 8), line);
    canvas.drawLine(Offset(8, center.dy), Offset(size.width - 8, center.dy), line);
    canvas.drawCircle(center, 5, Paint()..color = AppColors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarRingsPainter extends CustomPainter {
  const RadarRingsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    final ring = Paint()
      ..color = color.withOpacity(0.28)
      ..style = PaintingStyle.stroke;
    for (var index = 1; index < 5; index++) {
      canvas.drawCircle(center, maxRadius * index / 4, ring);
    }

    final sweep = Paint()
      ..color = color.withOpacity(0.36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 0.78),
      -0.7,
      0.9,
      false,
      sweep,
    );
  }

  @override
  bool shouldRepaint(covariant RadarRingsPainter oldDelegate) => oldDelegate.color != color;
}

class MapGridPainter extends CustomPainter {
  const MapGridPainter({required this.isDayMode});

  final bool isDayMode;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = isDayMode ? const Color(0xFFFFF3DE) : const Color(0xFF0A0A0A),
    );

    final gridPaint = Paint()
      ..color = isDayMode ? const Color(0x33A45D09) : const Color(0x22FFD7A1)
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.blue.withOpacity(isDayMode ? 0.18 : 0.32),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);

    final roadPaint = Paint()
      ..color = AppColors.blue.withOpacity(isDayMode ? 0.34 : 0.22)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final road = Path()
      ..moveTo(20, size.height * 0.7)
      ..cubicTo(size.width * 0.32, size.height * 0.54, size.width * 0.64, size.height * 0.82, size.width - 10, size.height * 0.28)
      ..moveTo(size.width * 0.18, 10)
      ..cubicTo(size.width * 0.28, size.height * 0.28, size.width * 0.88, size.height * 0.42, size.width * 0.74, size.height - 20);
    canvas.drawPath(road, roadPaint);
  }

  @override
  bool shouldRepaint(covariant MapGridPainter oldDelegate) {
    return oldDelegate.isDayMode != isDayMode;
  }
}

class NetworkOrbPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final nodes = [
      const Offset(0.5, 0.16),
      const Offset(0.24, 0.32),
      const Offset(0.72, 0.34),
      const Offset(0.16, 0.62),
      const Offset(0.46, 0.52),
      const Offset(0.82, 0.64),
      const Offset(0.32, 0.82),
      const Offset(0.64, 0.84),
    ];

    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.blue.withOpacity(0.22), Colors.transparent],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glow);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.blue.withOpacity(0.32)
        ..style = PaintingStyle.stroke,
    );

    final linePaint = Paint()
      ..color = AppColors.blue.withOpacity(0.44)
      ..strokeWidth = 1;
    for (var index = 0; index < nodes.length; index++) {
      final start = Offset(nodes[index].dx * size.width, nodes[index].dy * size.height);
      for (var next = index + 1; next < nodes.length; next++) {
        if ((index + next).isEven) {
          final end = Offset(nodes[next].dx * size.width, nodes[next].dy * size.height);
          canvas.drawLine(start, end, linePaint);
        }
      }
    }

    for (final node in nodes) {
      final point = Offset(node.dx * size.width, node.dy * size.height);
      canvas.drawCircle(point, 4, Paint()..color = Colors.white);
      canvas.drawCircle(point, 2, Paint()..color = AppColors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
