import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnimatedBorderFab extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(3), // Border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Color.fromRGBO(2, 233, 243, 1), // Custom Color
                Color.fromRGBO(0, 102, 255, 1),
              ],
              stops: const [1, 1],
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
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                            height: 300,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.link),
                                    title: Text(AppLocalizations.of(context)!
                                        .inputPlaylistUrl),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.upload),
                                    title: Text(AppLocalizations.of(context)!
                                        .uploadM3UFile),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.folder),
                                    title: Text(AppLocalizations.of(context)!
                                        .uploadFromFiles),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.folder),
                                    title: Text(AppLocalizations.of(context)!
                                        .playSingleStream),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.add),
                                    title: Text(AppLocalizations.of(context)!
                                        .importFromLibrary),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ));
                      });
                },
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
