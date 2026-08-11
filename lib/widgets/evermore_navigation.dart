import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/evermore_theme.dart';

class EvermoreNavigation extends StatelessWidget {
  const EvermoreNavigation({super.key, required this.selectedIndex, required this.onDestinationSelected});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Home'),
    (Icons.menu_book_rounded, Icons.menu_book_outlined, 'Learn'),
    (Icons.groups_rounded, Icons.groups_outlined, 'Community'),
    (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
  ];

  void _select(int index) {
    if (index == selectedIndex) return;
    HapticFeedback.selectionClick();
    onDestinationSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 78,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .76),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white.withValues(alpha: .95)),
                boxShadow: EvermoreTheme.floatingShadow,
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
                        onTap: () => _select(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.translationValues(0, selected ? -7 : 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 360),
                                curve: Curves.easeOutBack,
                                width: selected ? 56 : 44,
                                height: selected ? 56 : 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: selected ? EvermoreTheme.logoGradient : null,
                                  color: selected ? null : Colors.transparent,
                                  boxShadow: selected ? EvermoreTheme.floatingShadow : const [],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 220),
                                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                                  child: Icon(
                                    selected ? item.$1 : item.$2,
                                    key: ValueKey('$index-$selected'),
                                    size: selected ? 24 : 23,
                                    color: selected ? Colors.white : EvermoreTheme.muted,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 180),
                                opacity: selected ? 1 : .72,
                                child: Text(
                                  item.$3,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    height: 1,
                                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                                    color: selected ? EvermoreTheme.primary : EvermoreTheme.muted,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
