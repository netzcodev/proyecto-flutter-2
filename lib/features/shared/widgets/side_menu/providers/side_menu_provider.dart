import 'package:cars_app/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sidemenuStateProvider =
    StateNotifierProvider<SideMenuStateNotifier, SideMenuState>((ref) {
  return SideMenuStateNotifier();
});

class SideMenuStateNotifier extends StateNotifier<SideMenuState> {
  SideMenuStateNotifier() : super(SideMenuState());

  void loadMenu(int index) {
    state = state.copyWith(
      navDrawerIndex: index,
    );
  }

  void onDestinationSelected(int index) {
    state = state.copyWith(navDrawerIndex: index);
  }

  int getNavIndex() {
    return state.navDrawerIndex;
  }
}

class SideMenuState {
  final int navDrawerIndex;

  SideMenuState({
    this.navDrawerIndex = 0,
  });

  SideMenuState copyWith({
    int? navDrawerIndex,
    List<MenuItem>? menus,
  }) =>
      SideMenuState(
        navDrawerIndex: navDrawerIndex ?? this.navDrawerIndex,
      );
}
