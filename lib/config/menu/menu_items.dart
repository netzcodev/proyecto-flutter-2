import 'package:flutter/material.dart' show IconData, Icons;

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Customers',
    subTitle: 'Manage Customers',
    link: '/customers',
    icon: Icons.smart_button_outlined,
  ),
  MenuItem(
    title: 'Users',
    subTitle: 'Manage users',
    link: '/users',
    icon: Icons.person_2_outlined,
  ),
];
