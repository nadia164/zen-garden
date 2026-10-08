import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/zen_colors.dart';
import 'sand_painter.dart';
import 'sand_background_painter.dart';

enum GardenTool {
  rake,
  stone,
  plant,
}

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  final List<List<Offset>> _rakePaths = [];
  final List<_GardenStoneData> _stones = [];

  List<Offset>? _currentRake;

  GardenTool _selectedTool = GardenTool.rake;

  void _startRaking(DragStartDetails details) {
    if (_selectedTool != GardenTool.rake) {
      return;
    }

    final newPath = <Offset>[
      details.localPosition,
    ];

    setState(() {
      _currentRake = newPath;
      _rakePaths.add(newPath);
    });

    HapticFeedback.selectionClick();
  }

  void _continueRaking(DragUpdateDetails details) {
    if (_selectedTool != GardenTool.rake) {
      return;
    }

    final currentRake = _currentRake;

    if (currentRake == null) {
      return;
    }

    setState(() {
      currentRake.add(details.localPosition);
    });
  }

  void _finishRaking(DragEndDetails details) {
    _currentRake = null;
  }

  void _placeStone(TapUpDetails details) {
    if (_selectedTool != GardenTool.stone) {
      return;
    }

    final stone = _GardenStoneData(
      position: details.localPosition,
      size: 28 + (_stones.length % 4) * 4,
      rotation: (_stones.length % 5 - 2) * 0.08,
    );

    setState(() {
      _stones.add(stone);
    });

    HapticFeedback.lightImpact();
  }

  void _selectTool(GardenTool tool) {
    setState(() {
      _selectedTool = tool;
    });
  }

  void _resetGarden() {
    setState(() {
      _rakePaths.clear();
      _stones.clear();
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

        onTapUp: _placeStone,

        onPanStart: _startRaking,

        onPanUpdate: _continueRaking,

        onPanEnd: _finishRaking,

        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(
              painter: SandBackgroundPainter(),
            ),

            CustomPaint(
              painter: SandPainter(
                rakePaths: _rakePaths,
              ),
            ),

            for (final stone in _stones)
              _Stone(
                stone: stone,
              ),
          ],
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
              selected:
                  _selectedTool == GardenTool.rake,
              onTap: () {
                _selectTool(GardenTool.rake);
              },
            ),

            _ToolButton(
              icon: Icons.circle,
              label: 'Stone',
              selected:
                  _selectedTool == GardenTool.stone,
              onTap: () {
                _selectTool(GardenTool.stone);
              },
            ),

            _ToolButton(
              icon: Icons.local_florist,
              label: 'Plant',
              selected:
                  _selectedTool == GardenTool.plant,
              onTap: () {
                _selectTool(GardenTool.plant);
              },
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

class _Stone extends StatefulWidget {
  const _Stone({
    required this.stone,
  });

  final _GardenStoneData stone;

  @override
  State<_Stone> createState() => _StoneState();
}

class _StoneState extends State<_Stone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.stone.size;

    return Positioned(
      left: widget.stone.position.dx - size / 2,
      top: widget.stone.position.dy - size / 2,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
        ),
        child: Transform.rotate(
          angle: widget.stone.rotation,
          child: Container(
            width: size,
            height: size * 0.72,
            decoration: BoxDecoration(
              color: ZenColors.stone,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.45),
                topRight: Radius.circular(size * 0.35),
                bottomLeft: Radius.circular(size * 0.35),
                bottomRight: Radius.circular(size * 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.16,
                  ),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Align(
              alignment: const Alignment(-0.3, -0.4),
              child: Container(
                width: size * 0.25,
                height: size * 0.12,
                decoration: BoxDecoration(
                  color: ZenColors.stoneLight
                      .withValues(alpha: 0.45),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GardenStoneData {
  const _GardenStoneData({
    required this.position,
    required this.size,
    required this.rotation,
  });

  final Offset position;
  final double size;
  final double rotation;
}