import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iptv_player/common/constants/constants.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      height: 90,
      itemCount: 2,
      gapWidth: 70,
      tabBuilder: (int index, bool isActive) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  height: 24,
                  NavBarIconConstants.iconPaths[index],
                  colorFilter: isActive
                      ? const ColorFilter.mode(
                          Colors.blueAccent, BlendMode.srcIn)
                      : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 4),
                Text(
                  NavBarIconConstants.getLocalizeLabel(index, context),
                  style: TextStyle(
                    color: isActive ? Colors.blueAccent : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ));
      },
      activeIndex: selectedIndex,
      onTap: onItemTapped,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      shadow: const Shadow(
        color: Colors.black12,
        blurRadius: 20,
      ),
    );
  }
}
