import 'package:flutter/material.dart';

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

const globalMenuItems = <MenuItem>[
  MenuItem(
    title: 'Dashboard',
    subTitle: 'See Dashboard',
    link: '/dashboard',
    icon: Icons.dashboard_outlined,
  ),
  MenuItem(
    title: 'Customers',
    subTitle: 'Manage Customers',
    link: '/customers',
    icon: Icons.remember_me_outlined,
  ),
  MenuItem(
    title: 'Employees',
    subTitle: 'Manage Employees',
    link: '/employees',
    icon: Icons.business_center_outlined,
  ),
  MenuItem(
    title: 'People',
    subTitle: 'Manage People',
    link: '/people',
    icon: Icons.accessibility_new_outlined,
  ),
  MenuItem(
    title: 'Permissions',
    subTitle: 'Manage Permissions',
    link: '/permissions',
    icon: Icons.lock_person_outlined,
  ),
  MenuItem(
    title: 'Roles',
    subTitle: 'Manage Roles',
    link: '/roles',
    icon: Icons.admin_panel_settings_outlined,
  ),
  MenuItem(
    title: 'Schedules',
    subTitle: 'Manage Schedules',
    link: '/schedules',
    icon: Icons.schedule_outlined,
  ),
  MenuItem(
    title: 'Services',
    subTitle: 'Manage Services',
    link: '/services',
    icon: Icons.room_service_outlined,
  ),
  MenuItem(
    title: 'Users',
    subTitle: 'Manage users',
    link: '/users',
    icon: Icons.supervised_user_circle_outlined,
  ),
  MenuItem(
    title: 'Vehicles',
    subTitle: 'Manage Vehicles',
    link: '/vehicles',
    icon: Icons.directions_car_filled_outlined,
  ),
  MenuItem(
    title: 'Calendar',
    subTitle: 'See Calendar',
    link: '/calendar',
    icon: Icons.calendar_month_outlined,
  ),
];
