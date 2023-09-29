import 'package:cars_app/features/notificactions/domain/entities/push_message.dart';
import 'package:cars_app/features/notificactions/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String pushMessageId;
  const NotificationDetailsScreen({
    super.key,
    required this.pushMessageId,
  });

  @override
  Widget build(BuildContext context) {
    final PushMessage? message =
        context.watch<NotificationsBloc>().getMessageById(pushMessageId);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          title: const Text('Detalles'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.supervised_user_circle_outlined),
            )
          ],
        ),
        body: (message != null)
            ? _DetailsView(message: message)
            : const Center(child: Text('Notificación no existe')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.save_outlined),
        ),
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text(message.title, style: textStyles.titleMedium),
          Text(message.body),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
              'En el siguiente enlace podrás gestionar las acciones necesarias:'),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.push('/vehicles'),
            child: const Text('Ir al módulo de vehiculos'),
          ),
        ],
      ),
    );
  }
}
