import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scafoldKey = GlobalKey<ScaffoldState>();
    final permissions = ref
        .read(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'People');

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scafoldKey),
      appBar: AppBar(
        title: const Text('Personas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tips_and_updates_outlined)),
        ],
      ),
      body: const _PeopleView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (permissions.add == 0) return;
          context.push('/people/0');
        },
        label: const Text('persona'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _PeopleView extends ConsumerStatefulWidget {
  const _PeopleView();

  @override
  _PeopleViewState createState() => _PeopleViewState();
}

class _PeopleViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(peopleProvider.notifier).loadNextPage();
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
        .showSnackBar(const SnackBar(content: Text('Persona Eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    final peopleState = ref.watch(peopleProvider);
    final authState = ref.read(authProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AlignedGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: peopleState.people.length,
        itemBuilder: (context, index) {
          final person = peopleState.people[index];
          return GestureDetector(
            child: CrudCard<People>(
              entity: person,
              role: authState.user!.role,
              icon: Icons.person_outline,
              options: authState.user!.menu!
                  .firstWhere((element) => element.menuName == 'People'),
              onDeleteCallback: (value) {
                ref.watch(peopleProvider.notifier).deletePeople(value!).then(
                  (value) {
                    if (!value) return;
                    showSnackbar(context);
                    // context.push('/people');
                  },
                );
              },
            ),
            onTap: () => context.push('/people/${person.id}'),
          );
        },
      ),
    );
  }
}
