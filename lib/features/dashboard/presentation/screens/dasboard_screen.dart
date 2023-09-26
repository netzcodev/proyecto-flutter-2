import 'package:cars_app/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:cars_app/features/services/domain/entities/service_entity.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _DashboardView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Reporte'),
        icon: const Icon(Icons.picture_as_pdf_outlined),
        onPressed: () {},
      ),
    );
  }
}

class _DashboardView extends ConsumerStatefulWidget {
  const _DashboardView();

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(dashboardProvider.notifier).load();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Column(
      children: [
        if (dashboardState.comingSchedule.runtimeType != Null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors
                    .deepPurpleAccent.shade200, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Sombra
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white, // Color del icono
                  size: 40,
                ),
                title: Text(
                  dashboardState.comingSchedule?.date ?? 'HAHAHAH',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Próxima cita agendada',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                onTap: () {
                  print('Schedule');
                },
              ),
            ),
          ),
        if (dashboardState.comingService.runtimeType != Null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.build_circle_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                title: Text(
                  dashboardState.comingService?.comingDate ?? 'UYIOIUWE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: const Text(
                  'Próximo servicio',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  print('Servicio');
                },
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (dashboardState.history.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12,
            ),
            child: Divider(),
          ),
        if (dashboardState.history.isNotEmpty)
          const Row(
            children: [
              SizedBox(width: 20),
              Text(
                'Historial:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        if (dashboardState.history.isNotEmpty) const SizedBox(height: 15),
        if (dashboardState.history.isNotEmpty)
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: dashboardState.history.length,
              itemBuilder: (context, index) {
                final histoyItem = dashboardState.history[index];
                return HistoryItem(histoyItem: histoyItem);
              },
            ),
          ),
      ],
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.histoyItem,
  });

  final Service histoyItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 8.0,
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              SizedBox(
                width: 30,
                height: 80,
                child: CustomPaint(
                  painter: _LineWithCirclesPainter(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${histoyItem.name} - ${histoyItem.currentDate}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      histoyItem.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _LineWithCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    const circleRadius = 10.0;
    const lineStart = Offset(circleRadius, 0);
    final lineEnd = Offset(circleRadius, size.height);

    canvas.drawLine(lineStart, lineEnd, paint);

    final bottomCircleCenter =
        Offset(circleRadius, size.height - circleRadius * 4.4);

    // canvas.drawCircle(topCircleCenter, circleRadius, paint);
    canvas.drawCircle(bottomCircleCenter, circleRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
