import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/shared/widgets/side_menu/providers/side_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final loginState = ref.watch(authProvider);
    final navDrawerIndex = ref.watch(sidemenuStateProvider.notifier);
    final menuInitialIndex =
        loginState.menus?.indexWhere((element) => element.title == 'Calendar');

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex.getNavIndex() == 0
          ? menuInitialIndex
          : navDrawerIndex.getNavIndex(),
      onDestinationSelected: (value) {
        navDrawerIndex.onDestinationSelected(value);

        final menuItem = loginState.menus![value];
        ref.watch(goRouterProvider).go(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Saludos', style: textStyles.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
          child: Text(loginState.user!.fullName, style: textStyles.titleSmall),
        ),
        ...loginState.menus!
            .map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              ),
            )
            .toList(),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            text: 'Cerrar sesión',
          ),
        ),
      ],
    );
  }
}
