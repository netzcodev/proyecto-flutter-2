import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _CalendarView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Eres genial!'));
  }
}
