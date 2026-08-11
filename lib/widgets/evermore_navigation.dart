import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/evermore_theme.dart';

class EvermoreNavigation extends StatelessWidget {
  const EvermoreNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Home'),
    (Icons.menu_book_rounded, Icons.menu_book_outlined, 'Learn'),
    (Icons.groups_rounded, Icons.groups_outlined, 'Community'),
    (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            height: 74,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .78),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: .95)),
              boxShadow: [
                BoxShadow(
                  color: EvermoreTheme.primary.withValues(alpha: .10),
                  blurRadius: 34,
                  offset: const Offset(0, 12),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: .06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = selectedIndex == index;

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: item.$3,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onDestinationSelected(index),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 360),
                          curve: Curves.easeOutBack,
                          width: selected ? 68 : 58,
                          height: selected ? 60 : 56,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedScale(
                                scale: selected ? 1 : .82,
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutBack,
                                child: AnimatedOpacity(
                                  opacity: selected ? 1 : 0,
                                  duration: const Duration(milliseconds: 180),
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: EvermoreTheme.heroGradient,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: EvermoreTheme.violet.withValues(alpha: .28),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: Icon(
                                  selected ? item.$1 : item.$2,
                                  key: ValueKey('$index-$selected'),
                                  size: selected ? 25 : 23,
                                  color: selected ? Colors.white : EvermoreTheme.muted,
                                ),
                              ),
                              Positioned(
                                bottom: selected ? -1 : 1,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 260),
                                  width: selected ? 5 : 0,
                                  height: selected ? 5 : 0,
                                  decoration: const BoxDecoration(
                                    color: EvermoreTheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
