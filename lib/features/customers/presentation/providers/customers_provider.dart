import 'package:cars_app/features/customers/domain/domain.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'customers_repository_provider.dart';

final customersProvider =
    StateNotifierProvider<CustomersNotifier, CustomersState>((ref) {
  final customersRepository = ref.watch(customersRepositoryProvider);
  return CustomersNotifier(customersRepository: customersRepository);
});

class CustomersNotifier extends StateNotifier<CustomersState> {
  final CustomersRepository customersRepository;

  CustomersNotifier({
    required this.customersRepository,
  }) : super(CustomersState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateCustomers(
      Map<String, dynamic> customersLike) async {
    try {
      final customer =
          await customersRepository.createUpdateCustomer(customersLike);
      final isPersonInList =
          state.customers.any((element) => element.id == customer.id);

      if (!isPersonInList) {
        state = state.copyWith(customers: [...state.customers, customer]);
        return true;
      }

      state = state.copyWith(
        customers: state.customers
            .map((element) => (element.id == customer.id) ? customer : element)
            .toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true,
    );

    final customers = await customersRepository.getCustomersByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (customers.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      customers: [...state.customers, ...customers],
    );
  }
}

class CustomersState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<People> customers;

  CustomersState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.customers = const [],
  });

  CustomersState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<People>? customers,
  }) =>
      CustomersState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        customers: customers ?? this.customers,
      );
}
