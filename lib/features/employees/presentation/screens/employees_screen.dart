import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scafoldKey = GlobalKey<ScaffoldState>();
    final permissions = ref
        .read(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Employees');

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scafoldKey),
      appBar: AppBar(
        title: const Text('Mecánicos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: const _EmployeesView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (permissions.add == 0) return;
          context.push('/employees/0');
        },
        label: const Text('Mecánico'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _EmployeesView extends ConsumerStatefulWidget {
  const _EmployeesView();

  @override
  _EmployeesViewState createState() => _EmployeesViewState();
}

class _EmployeesViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(peopleProvider.notifier).loadNextEmployeesPage();
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
        .showSnackBar(const SnackBar(content: Text('Mecánico Eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    final peopleState = ref
        .watch(peopleProvider)
        .people
        .where((element) => element.roleId == 3)
        .toList();
    final authState = ref.read(authProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AlignedGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: peopleState.length,
        itemBuilder: (context, index) {
          final person = peopleState[index];
          return GestureDetector(
            child: CrudCard<People>(
              entity: person,
              role: authState.user!.role,
              icon: Icons.person_outline,
              options: authState.user!.menu!
                  .firstWhere((element) => element.menuName == 'Employees'),
              onDeleteCallback: (value) {
                ref.watch(peopleProvider.notifier).deletePeople(value!).then(
                  (value) {
                    if (!value) return;
                    showSnackbar(context);
                  },
                );
              },
            ),
            onTap: () => context.push('/employees/${person.id}'),
          );
        },
      ),
    );
  }
}
