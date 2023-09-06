import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final peopleRepositoryProvider = Provider<PeopleRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final peopleRepository = PeopleRepositoryImpl(
    datasource: PeopleDatasourceImpl(accessToken: accessToken),
  );

  return peopleRepository;
});
