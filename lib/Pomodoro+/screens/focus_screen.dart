import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/focus_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/timer_arc_painter.dart';
import 'session_history_screen.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double>   _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _TopBar(),
              _CurrentTask(),
              const SizedBox(height: 16),
              _TimerCircle(pulseAnimation: _pulseAnimation),
              const SizedBox(height: 24),
              _Controls(),
              const SizedBox(height: 16),
              _PageDots(),
              const SizedBox(height: 20),
              _AppBlockerCard(),
              const SizedBox(height: 12),
              _MusicPlayerCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.chevron_left,
            onTap: () => Navigator.maybePop(context),
          ),
          GestureDetector(
            onTap: () {
              final provider = context.read<FocusProvider>();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, anim, __) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const SessionHistoryScreen(),
                  ),
                  transitionsBuilder: (_, anim, __, child) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.history, color: AppColors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  'Session History',
                  style: TextStyle(color: AppColors.green, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CurrentTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final task = context.select<FocusProvider, String>((p) => p.currentTask);

    return Column(
      children: [
        const Text(
          'CURRENT TASK',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          task,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


class _TimerCircle extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const _TimerCircle({required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    final provider   = context.watch<FocusProvider>();
    final isRunning  = provider.timerState == TimerState.running;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) {
        return Transform.scale(
          scale: isRunning ? pulseAnimation.value : 1.0,
          child: SizedBox(
            width: 240,
            height: 240,
            child: CustomPaint(
              painter: TimerArcPainter(progress: provider.progress),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.timeDisplay,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.timerStatusLabel,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _Controls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<FocusProvider>();
    final isRunning = provider.timerState == TimerState.running;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.refresh,
            onTap: () => context.read<FocusProvider>().resetTimer(),
          ),

          GestureDetector(
            onTap: () {
              final p = context.read<FocusProvider>();
              isRunning ? p.pauseTimer() : p.startTimer();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 160,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isRunning ? 'PAUSE' : 'START',
                  style: const TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),

          _CircleIconButton(
            icon: Icons.settings,
            onTap: () => _showSettingsSheet(context, provider),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, FocusProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timer Settings',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _SettingRow(label: 'Focus Duration',  value: '${provider.focusDuration ~/ 60} min'),
            _SettingRow(label: 'Sessions Today',  value: '${provider.pomodoroCount}'),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary,   fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}


class _PageDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width:  i < 2 ? 10 : 8,
          height: i < 2 ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == 0
                ? AppColors.green
                : i == 1
                    ? AppColors.green.withOpacity(0.7)
                    : AppColors.greenDim,
          ),
        );
      }),
    );
  }
}


class _AppBlockerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enabled = context.select<FocusProvider, bool>((p) => p.appBlockerEnabled);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF3D1010),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.block, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Blocker',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  enabled ? 'Strict focus active' : 'Blocker disabled',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.read<FocusProvider>().toggleAppBlocker(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 50,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: enabled ? AppColors.green : AppColors.greenDim,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MusicPlayerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FocusProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 48,
                height: 48,
                color: const Color(0xFF2A3D2A),
                child: const Icon(Icons.music_note, color: AppColors.green),
              ),
            ),
            const SizedBox(width: 12),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.musicTitle,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(provider.musicPositionLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: provider.musicProgress,
                            backgroundColor: AppColors.greenDim,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
                            minHeight: 3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(provider.musicDurationLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            
            GestureDetector(
              onTap: () => context.read<FocusProvider>().skipMusic(),
              child: const Icon(Icons.skip_next, color: AppColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 12),

            
            GestureDetector(
              onTap: () => context.read<FocusProvider>().toggleMusic(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  provider.musicPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.background,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    const items = [
      (icon: Icons.home_filled,           label: 'Home',   active: false),
      (icon: Icons.checklist,             label: 'Habits', active: false),
      (icon: Icons.assignment_outlined,   label: 'Tasks',  active: false),
      (icon: Icons.timer,                 label: 'Focus',  active: true),
      (icon: Icons.sentiment_satisfied_alt, label: 'Mood', active: false),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.greenDim, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: item.active ? AppColors.green : AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    color:      item.active ? AppColors.green : AppColors.textSecondary,
                    fontSize:   10,
                    fontWeight: item.active ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.green, size: 22),
      ),
    );
  }
}
