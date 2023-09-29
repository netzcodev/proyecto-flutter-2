import 'package:cars_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:cars_app/features/dashboard/domain/domain.dart';
import 'package:cars_app/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/services/services.dart';
import 'package:cars_app/features/shared/infraestructure/services/keyvalue_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../shared/infraestructure/services/keyvalue_storage_service.dart';

final dashboardProvider =
    StateNotifierProvider.autoDispose<DashboardNotifier, DashboardState>(
  (ref) {
    final dashboardRepository = ref.watch(dashboardRepositoryProvider);
    final keyValueStorageService = KeyValueStorageServiceImpl();
    final authState = ref.read(authProvider);

    return DashboardNotifier(
      dashboardRepository: dashboardRepository,
      keyValueStorageService: keyValueStorageService,
      authState: authState,
    );
  },
);

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository dashboardRepository;
  final KeyValueStorageService keyValueStorageService;
  final AuthState authState;

  DashboardNotifier({
    required this.dashboardRepository,
    required this.keyValueStorageService,
    required this.authState,
  }) : super(DashboardState()) {
    load();
    // checkData();
  }

  Future checkData() async {}

  Future load() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    final comingSchedule =
        await dashboardRepository.getComingSchedule(authState.user!.id);

    if (comingSchedule.runtimeType != Null) {
      state = state.copyWith(
        comingSchedule: comingSchedule,
      );
    }

    final comingService =
        await dashboardRepository.getComingService(authState.user!.id);

    if (comingService.runtimeType != Null) {
      state = state.copyWith(
        comingService: comingService,
      );
    }

    final history = await dashboardRepository.getHistory(
        userId: authState.user!.id, limit: state.limit, offset: state.offset);

    if (history.isNotEmpty) {
      state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        history: [...state.history, ...history],
      );
    }

    if (history.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }
  }

  Future<bool> updateComingService() async {
    try {
      final data = {
        'id': state.comingSchedule!.id!,
        'date': state.scheduleComingDate
      };

      final service = await dashboardRepository.updateComingService(data);

      if (service.runtimeType != Null) {
        state = state.copyWith(comingService: service);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateComingSchedule() async {
    try {
      final data = {
        'id': state.comingSchedule!.id!,
        'date': state.scheduleComingDate
      };

      final schedule = await dashboardRepository.updateComingSchedule(data);

      if (schedule.runtimeType != Null) {
        state = state.copyWith(comingSchedule: schedule);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future setScheduleComingDate(DateTime date) async {
    state = state.copyWith(scheduleComingDate: date);
  }

  Future setServiceComingDate(DateTime date) async {
    state = state.copyWith(serviceComingDate: date);
  }

  Future<bool> getGeneralReport() async {
    try {
      final pdfData =
          await dashboardRepository.getGeneralReport(authState.user!.id);

      if (pdfData.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/${pdfData['filename']}.pdf';

        final download =
            await dashboardRepository.dowloadReport('/tmpData', path);

        if (download.runtimeType == Null) return false;

        return true;
      } else {
        return false; // La cadena de datos está vacía
      }
    } catch (e) {
      return false; // Error al obtener los datos del PDF
    }
  }
}

class DashboardState {
  final bool isLastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final DateTime? scheduleComingDate;
  final DateTime? serviceComingDate;
  final Schedule? comingSchedule;
  final Service? comingService;
  final List<Service> history;

  DashboardState({
    this.isLastPage = false,
    this.isLoading = false,
    this.limit = 10,
    this.offset = 0,
    this.comingSchedule,
    this.comingService,
    this.scheduleComingDate,
    this.serviceComingDate,
    this.history = const [],
  });

  DashboardState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    Schedule? comingSchedule,
    Service? comingService,
    DateTime? scheduleComingDate,
    DateTime? serviceComingDate,
    List<Service>? history,
  }) =>
      DashboardState(
        isLoading: isLoading ?? this.isLoading,
        comingSchedule: comingSchedule ?? this.comingSchedule,
        comingService: comingService ?? this.comingService,
        history: history ?? this.history,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLastPage: isLastPage ?? this.isLastPage,
        scheduleComingDate: scheduleComingDate ?? this.scheduleComingDate,
        serviceComingDate: serviceComingDate ?? this.serviceComingDate,
      );
}
