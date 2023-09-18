import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerScreen extends ConsumerWidget {
  final int peopleId;
  const CustomerScreen({
    super.key,
    required this.peopleId,
  });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cliente Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personState = ref.watch(personProvider(peopleId));
    final permissions = ref
        .read(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Customers');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Cliente'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.supervised_user_circle_outlined),
            )
          ],
        ),
        body: personState.isLoading
            ? const FullScreenLoader()
            : _CustomerView(person: personState.people!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (personState.people == null) return;
            if (permissions.modify == 0) return;
            ref
                .read(personFormProvider(personState.people!).notifier)
                .onCustomerFormSubmit()
                .then(
              (value) {
                if (!value) return;
                showSnackbar(context);
                ref.read(goRouterProvider).go('/customers');
              },
            );
          },
          child: const Icon(Icons.save_outlined),
        ),
      ),
    );
  }
}

class _CustomerView extends ConsumerWidget {
  final People person;

  const _CustomerView({required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personForm = ref.watch(personFormProvider(person));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(image: personForm.photo),
        ),
        const SizedBox(height: 10),
        Center(
            child:
                Text(personForm.fullName.value, style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _CustomerInformation(person: person),
      ],
    );
  }
}

class _CustomerInformation extends ConsumerWidget {
  final People person;
  const _CustomerInformation({required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personForm = ref.watch(personFormProvider(person));
    final authState = ref.read(authProvider);
    final permissions = ref
        .watch(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Customers');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos:'),
          const SizedBox(height: 15),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            isTopField: true,
            label: 'Nombre',
            initialValue: personForm.fullName.value,
            onChanged:
                ref.read(personFormProvider(person).notifier).onNameChanged,
            errorMessage: personForm.fullName.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Documento',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: personForm.document.value == 0
                ? ''
                : personForm.document.value.toString(),
            onChanged: (value) => ref
                .read(personFormProvider(person).notifier)
                .onDocumentChanged(int.tryParse(value) ?? -1),
            errorMessage: personForm.document.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Email',
            initialValue: personForm.email.value,
            onChanged:
                ref.read(personFormProvider(person).notifier).onEmailChanged,
            errorMessage: personForm.email.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            isBottomField: true,
            label: 'Teléfono',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: person.phone,
            onChanged:
                ref.read(personFormProvider(person).notifier).onPhoneChanged,
          ),
          const SizedBox(height: 15),
          if (authState.user!.isAdmin)
            _StatusSelector(
              status: personForm.status,
              onStatusChanged:
                  ref.read(personFormProvider(person).notifier).onStatusChanged,
            ),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String status;
  final void Function(String staus) onStatusChanged;

  const _StatusSelector({
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            GestureDetector(
              child: _CustomBadge(
                text: 'Activo',
                color: status == 'A' ? Colors.green : Colors.grey,
                width: 100,
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                onStatusChanged('A');
              },
            ),
            const SizedBox(width: 10),
            GestureDetector(
              child: _CustomBadge(
                text: 'Inactivo',
                color: status == 'D' ? Colors.redAccent : Colors.grey,
                width: 100,
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                onStatusChanged('D');
              },
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class _CustomBadge extends StatelessWidget {
  final double width;
  final String text;
  final Color color;

  const _CustomBadge(
      {required this.width, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final String image;
  const _ImageGallery({required this.image});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: image == ''
              ? Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover)
              : Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
        ),
      ],
    );
  }
}
