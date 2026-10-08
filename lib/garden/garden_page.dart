import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/zen_colors.dart';
import 'sand_painter.dart';

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  final List<List<Offset>> _rakePaths = [];

  List<Offset>? _currentRake;

  void _startRaking(DragStartDetails details) {
    final newPath = <Offset>[
      details.localPosition,
    ];

    _currentRake = newPath;

    setState(() {
      _rakePaths.add(newPath);
    });

    HapticFeedback.selectionClick();
  }

  void _continueRaking(DragUpdateDetails details) {
    final currentRake = _currentRake;

    if (currentRake == null) {
      return;
    }

    setState(() {
      currentRake.add(
        details.localPosition,
      );
    });
  }

  void _finishRaking(DragEndDetails details) {
    _currentRake = null;
  }

  void _resetGarden() {
    setState(() {
      _rakePaths.clear();
      _currentRake = null;
    });

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ZenColors.dawn,
              ZenColors.sand,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16,
                  ),
                  child: _buildGarden(),
                ),
              ),

              _buildToolbar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        12,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Zen Garden',
          style: TextStyle(
            color: ZenColors.ink,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildGarden() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onPanStart: _startRaking,

        onPanUpdate: _continueRaking,

        onPanEnd: _finishRaking,

        child: CustomPaint(
          painter: SandPainter(
            rakePaths: _rakePaths,
          ),

          // This gives CustomPaint an explicit child size.
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24,
      ),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.55,
          ),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            _ToolButton(
              icon: Icons.grass,
              label: 'Rake',
              selected: true,
              onTap: () {},
            ),
            _ToolButton(
              icon: Icons.circle,
              label: 'Stone',
              onTap: () {},
            ),
            _ToolButton(
              icon: Icons.local_florist,
              label: 'Plant',
              onTap: () {},
            ),
            _ToolButton(
              icon: Icons.water,
              label: 'Reset',
              onTap: _resetGarden,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? ZenColors.sand.withValues(
                  alpha: 0.8,
                )
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: ZenColors.ink,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: ZenColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}