import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iptv_player/common/constants/language_constants.dart';
import 'package:iptv_player/presentation/home/add_playlist_menu.dart';
import 'package:iptv_player/presentation/license/license_agreement_dialog.dart';

class AnimatedBorderFab extends StatefulWidget {
  final VoidCallback? onBottomSheetClosed;

  const AnimatedBorderFab({super.key, this.onBottomSheetClosed});
  @override
  _AnimatedBorderFabState createState() => _AnimatedBorderFabState();
}

class _AnimatedBorderFabState extends State<AnimatedBorderFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Controls animation speed
    )..repeat(); // Infinite loop animation
  }

  void _openBottomSheet(BuildContext context) async {
    // Check if license has been accepted
    final licenseAccepted = await isLicenseAccepted();

    if (!licenseAccepted && context.mounted) {
      // Show license agreement dialog first
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return LicenseAgreementDialog(
                onAccepted: () {
                  // After accepting, open the add playlist menu
                  if (context.mounted) {
                    _openAddPlaylistMenu(context);
                  }
                },
              );
            },
          );
        },
      );
    } else if (context.mounted) {
      // License already accepted, open menu directly
      _openAddPlaylistMenu(context);
    }
  }

  void _openAddPlaylistMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddPlaylistMenu(
          onBottomSheetClosed: widget.onBottomSheetClosed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(3), // Border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(2, 233, 243, 1), // Custom Color
                Color.fromRGBO(0, 102, 255, 1),
              ],
              stops: const [0.5, 1],
              transform: GradientRotation(_controller.value * 2 * pi),
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(2, 233, 243, 1), // Custom Color
                    Color.fromRGBO(0, 102, 255, 1), // Secondary color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FloatingActionButton(
                onPressed: () => _openBottomSheet(context),
                backgroundColor: Colors.transparent, // Important!
                elevation: 0, // Avoids default shadow
                shape: const CircleBorder(),
                child: SvgPicture.asset(
                  'assets/icons/MaterialSymbolsAdd.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
