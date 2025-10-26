import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final GlobalKey? targetKey;
  final String instruction;
  final VoidCallback? onTap;

  const TutorialOverlay({
    super.key,
    this.targetKey,
    required this.instruction,
    this.onTap,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  bool _isPositioned = false;

  @override
  void initState() {
    super.initState();
    // Wait for the next frame to ensure widgets are laid out
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isPositioned = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay with hole that allows touches through the target area
        if (_isPositioned && widget.targetKey != null)
          _buildSelectiveBlockingOverlay()
        else
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),

        // Instruction box - doesn't block touches
        if (_isPositioned)
          IgnorePointer(
            child: _buildPositionedInstruction(),
          ),
      ],
    );
  }

  Widget _buildSelectiveBlockingOverlay() {
    final RenderBox? renderBox =
        widget.targetKey!.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return Positioned.fill(
        child: AbsorbPointer(
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    return Positioned.fill(
      child: Stack(
        children: [
          // Visual overlay with hole - doesn't block pointer events
          IgnorePointer(
            child: CustomPaint(
              painter: OverlayHolePainter(targetKey: widget.targetKey!),
              child: Container(),
            ),
          ),

          // Four AbsorbPointer regions that block everything EXCEPT the hole
          // Top region
          if (position.dy > 10)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: position.dy - 10,
              child: AbsorbPointer(
                child: Container(color: Colors.transparent),
              ),
            ),

          // Bottom region
          Positioned(
            top: position.dy + targetSize.height + 10,
            left: 0,
            right: 0,
            bottom: 0,
            child: AbsorbPointer(
              child: Container(color: Colors.transparent),
            ),
          ),

          // Left region
          if (position.dx > 10)
            Positioned(
              top: position.dy - 10,
              left: 0,
              width: position.dx - 10,
              height: targetSize.height + 20,
              child: AbsorbPointer(
                child: Container(color: Colors.transparent),
              ),
            ),

          // Right region
          Positioned(
            top: position.dy - 10,
            left: position.dx + targetSize.width + 10,
            right: 0,
            height: targetSize.height + 20,
            child: AbsorbPointer(
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedInstruction() {
    // Get the position of the target widget if available
    if (widget.targetKey != null) {
      final RenderBox? renderBox =
          widget.targetKey!.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);

        // Position above the target (since FAB is usually at bottom)
        return Positioned(
          top: position.dy - 180, // Card height + padding
          left: 20,
          right: 20,
          child: _buildInstructionCard(),
        );
      }
    }

    // Default position if no target key
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: _buildInstructionCard(),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            size: 40,
            color: Color(0xFF6A82FB),
          ),
          const SizedBox(height: 12),
          Text(
            widget.instruction,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Follow the highlighted area',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OverlayHolePainter extends CustomPainter {
  final GlobalKey targetKey;

  OverlayHolePainter({required this.targetKey});

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    // Create a path for the entire screen
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a circular or rectangular hole for the spotlight
    final spotlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx - 10,
        position.dy - 10,
        targetSize.width + 20,
        targetSize.height + 20,
      ),
      const Radius.circular(50),
    );

    // Subtract the spotlight area
    path.addRRect(spotlightRect);
    path.fillType = PathFillType.evenOdd;

    // Draw the overlay with hole
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Draw highlight border around spotlight
    final borderPaint = Paint()
      ..color = Color(0xFF6A82FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(spotlightRect, borderPaint);

    // Draw pulsing animation effect (optional - you can add animation later)
    final glowPaint = Paint()
      ..color = Color(0xFF6A82FB).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawRRect(spotlightRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
