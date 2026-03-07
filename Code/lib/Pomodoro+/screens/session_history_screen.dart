import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/session_record.dart';
import '../providers/focus_provider.dart';
import '../utils/app_colors.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen>
    with SingleTickerProviderStateMixin {
  SessionFilter _activeFilter = SessionFilter.today;

  late AnimationController _fadeController;
  late Animation<double>   _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _changeFilter(SessionFilter filter) {
    setState(() => _activeFilter = filter);
    _fadeController.forward(from: 0.4); 
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FocusProvider>();
    final sessions = provider.filteredSessions(_activeFilter);

    final totalMinutes   = sessions.fold(0, (sum, s) => sum + s.durationSeconds ~/ 60);
    final completedCount = sessions.where((s) => s.completed).length;
    final streakDays     = provider.streakDays;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildStatsRow(
                totalMinutes:   totalMinutes,
                completedCount: completedCount,
                streakDays:     streakDays,
              ),
              const SizedBox(height: 20),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildSessionList(sessions),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_left, color: AppColors.green, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Session History',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatsRow({
    required int totalMinutes,
    required int completedCount,
    required int streakDays,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            icon:  Icons.timer_outlined,
            value: '${totalMinutes ~/ 60}h ${totalMinutes % 60}m',
            label: 'Focus Time',
            flex:  2,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon:  Icons.check_circle_outline,
            value: '$completedCount',
            label: 'Sessions',
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon:       Icons.local_fire_department_outlined,
            value:      '$streakDays',
            label:      'Day Streak',
            accentColor: AppColors.orange,
          ),
        ],
      ),
    );
  }


  Widget _buildFilterChips() {
    const filters = [
      (filter: SessionFilter.today, label: 'Today'),
      (filter: SessionFilter.week,  label: 'This Week'),
      (filter: SessionFilter.all,   label: 'All Time'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.map((item) {
          final isActive = _activeFilter == item.filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _changeFilter(item.filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:        isActive ? AppColors.green : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border:       Border.all(
                    color: isActive ? AppColors.green : AppColors.greenDim,
                  ),
                ),
                child: Text(
                  item.label,
                  style: TextStyle(
                    color:      isActive ? AppColors.background : AppColors.textSecondary,
                    fontSize:   13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildSessionList(List<SessionRecord> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, color: AppColors.greenDim, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No sessions yet',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ],
        ),
      );
    }

    final grouped = <String, List<SessionRecord>>{};
    for (final session in sessions) {
      grouped.putIfAbsent(session.dateLabel, () => []).add(session);
    }
    final dateGroups = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dateGroups.length,
      itemBuilder: (context, index) {
        final entry        = dateGroups[index];
        final groupMinutes = entry.value.fold(0, (s, r) => s + r.durationSeconds ~/ 60);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color:      AppColors.textPrimary,
                      fontSize:   14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    '${groupMinutes}m total',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

            ...entry.value.asMap().entries.map((e) {
              final isLastInGroup = e.key == entry.value.length - 1;
              return _SessionTile(session: e.value, isLastInGroup: isLastInGroup);
            }),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}


class _StatCard extends StatelessWidget {
  final IconData icon;
  final String   value;
  final String   label;
  final int      flex;
  final Color    accentColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.flex        = 1,
    this.accentColor = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border:       Border.all(color: accentColor.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color:       AppColors.textPrimary,
                fontSize:    20,
                fontWeight:  FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}


class _SessionTile extends StatelessWidget {
  final SessionRecord session;
  final bool          isLastInGroup;

  const _SessionTile({required this.session, required this.isLastInGroup});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width:  10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape:     BoxShape.circle,
                    color:     session.completed ? AppColors.green : AppColors.textSecondary.withOpacity(0.4),
                    boxShadow: session.completed
                        ? [BoxShadow(color: AppColors.green.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)]
                        : null,
                  ),
                ),
                if (!isLastInGroup)
                  Expanded(
                    child: Container(
                      width:  1.5,
                      color:  AppColors.greenDim,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Container(
              margin:  const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(
                  color: session.completed ? AppColors.greenDim : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.task,
                          style: const TextStyle(
                            color:      AppColors.textPrimary,
                            fontSize:   14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: AppColors.textSecondary, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              session.timeLabel,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:        session.completed
                              ? AppColors.green.withOpacity(0.12)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          session.durationLabel,
                          style: TextStyle(
                            color:      session.completed ? AppColors.green : AppColors.textSecondary,
                            fontSize:   13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.completed ? '✓ Done' : '✕ Stopped',
                        style: TextStyle(
                          color:    session.completed
                              ? AppColors.green.withOpacity(0.6)
                              : AppColors.textSecondary.withOpacity(0.5),
                          fontSize: 10,
                        ),
                      ),
                    ],
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
