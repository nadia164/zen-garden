import 'package:flutter/material.dart';

import '../theme/zen_colors.dart';
import 'sand_painter.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({super.key});

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
                child: _buildGarden(),
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
      padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        children: [
          Text(
            'Zen Garden',
            style: TextStyle(
              color: ZenColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGarden() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CustomPaint(
          painter: SandPainter(),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(36),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              onTap: () {},
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
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? ZenColors.sand.withValues(alpha: 0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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