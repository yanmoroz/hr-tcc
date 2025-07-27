import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/domain/entities/parking_request.dart';
import 'package:hr_tcc/domain/repositories/parking_request_repository_mock.dart';
import 'package:hr_tcc/domain/usecases/get_parking_request_by_id_usecase.dart';
import 'package:hr_tcc/presentation/blocs/parking_request/parking_request_view_bloc.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';
import 'package:hr_tcc/config/themes/themes.dart';

class ParkingRequestViewPage extends StatelessWidget {
  final String requestId;
  const ParkingRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ParkingRequestViewBloc(
            GetParkingRequestByIdUseCase(ParkingRequestRepositoryMock()),
          )..add(LoadParkingRequestDetails(requestId)),
      child: BlocBuilder<ParkingRequestViewBloc, ParkingRequestViewState>(
        builder: (context, state) {
          if (state is ParkingRequestViewLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ParkingRequestViewError) {
            return Scaffold(
              appBar: const RequestAppBar(title: 'Заявка'),
              body: Center(child: Text(state.message)),
            );
          }
          if (state is ParkingRequestViewLoaded) {
            final request = state.details;
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: const RequestAppBar(title: 'Заявка'),
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  RequestStatusDateRow(
                    status: StatusChip(status: request.status),
                    date: request.createdAt,
                  ),
                  const SizedBox(height: 16),
                  Text('Парковка', style: AppTypography.title1Bold),
                  const SizedBox(height: 24),
                  const SectionLabel('Тип парковки'),
                  const SizedBox(height: 2),
                  Text(
                    () {
                      switch (request.type) {
                        case ParkingType.guest:
                          return 'Гостевой паркинг';
                        case ParkingType.cargo:
                          return 'Грузовой паркинг';
                        case ParkingType.reserved:
                          return 'Паркинг на определенное место';
                      }
                    }(),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (request.parkingPlaceNumber != null &&
                      request.parkingPlaceNumber!.isNotEmpty) ...[
                    const SectionLabel('Номер парковочного места'),
                    const SizedBox(height: 2),
                    Text(
                      request.parkingPlaceNumber!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.purposeText != null &&
                      request.purposeText!.isNotEmpty) ...[
                    const SectionLabel('Цель посещения'),
                    const SizedBox(height: 2),
                    Text(
                      request.purposeText!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.cargoReason != null &&
                      request.cargoReason!.isNotEmpty) ...[
                    const SectionLabel('Основание'),
                    const SizedBox(height: 2),
                    Text(
                      request.cargoReason!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.cargoDescription != null &&
                      request.cargoDescription!.isNotEmpty) ...[
                    const SectionLabel('Описание груза'),
                    const SizedBox(height: 2),
                    Text(
                      request.cargoDescription!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.driver != null && request.driver!.isNotEmpty) ...[
                    const SectionLabel('Водитель'),
                    const SizedBox(height: 2),
                    Text(
                      request.driver!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.escort != null && request.escort!.isNotEmpty) ...[
                    const SectionLabel('Сопровождающий'),
                    const SizedBox(height: 2),
                    Text(
                      request.escort!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.liftAction != null &&
                      request.liftAction!.isNotEmpty) ...[
                    const SectionLabel('Действие лифта'),
                    const SizedBox(height: 2),
                    Text(
                      request.liftAction!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (request.liftNumber != null) ...[
                    const SectionLabel('Номер лифта'),
                    const SizedBox(height: 2),
                    Text(
                      request.liftNumber.toString(),
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  const SectionLabel('Этаж'),
                  const SizedBox(height: 2),
                  Text(
                    '${request.floor}',
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Офис'),
                  const SizedBox(height: 2),
                  Text(
                    request.office.name,
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Марка автомобиля'),
                  const SizedBox(height: 2),
                  Text(
                    request.carBrand,
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Госномер автомобиля'),
                  const SizedBox(height: 2),
                  Text(
                    request.carNumber,
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Дата или период'),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDate(request.dateRange.start)} — ${_formatDate(request.dateRange.end)}',
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Часы «C»'),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(request.timeFrom),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Часы «До»'),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(request.timeTo),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Посетители', style: AppTypography.title2Bold),
                  const SizedBox(height: 8),
                  ...request.visitors.map(
                    (fio) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('ФИО'),
                        const SizedBox(height: 2),
                        Text(
                          fio,
                          style: AppTypography.text1Regular.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
