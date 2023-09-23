import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ServicesView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('vehiculo'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _ServicesView extends ConsumerStatefulWidget {
  const _ServicesView();

  @override
  _ServicesViewState createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        ref.read(schedulesProvider.notifier).loadNextWeek();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cita Cancelada')));
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(schedulesProvider);

    return Column(
      children: calendarState.generalEvents.isEmpty
          ? []
          : calendarState.generalEvents.entries.map((entry) {
              final day = entry.key;
              final events = entry.value;
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      '${day.day}/${day.month}/${day.year}', // Mostrar la fecha del día
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    ListView.builder(
                      itemCount: events.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () => context.push('/services/:id'),
                            title: Text(
                              '${event.name} - ${event.time.hour}:${event.time.minute < 10 ? '0' : ''}${event.time.minute}${event.time.period == DayPeriod.am ? 'am' : 'pm'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              event.description,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
