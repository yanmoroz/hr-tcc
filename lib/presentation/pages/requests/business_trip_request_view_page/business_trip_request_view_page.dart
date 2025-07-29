import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/themes/themes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/entities/requests/business_trip_request.dart';
import '../../../blocs/blocs.dart';
import '../components/components.dart';

class BusinessTripRequestViewPage extends StatelessWidget {
  final String requestId;
  const BusinessTripRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              BlocFactory.createBusinessTripRequestViewBloc()
                ..add(LoadBusinessTripRequestDetails(requestId)),
      child: BlocBuilder<
        BusinessTripRequestViewBloc,
        BusinessTripRequestViewState
      >(
        builder: (context, state) {
          if (state is BusinessTripRequestViewLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is BusinessTripRequestViewError) {
            return Scaffold(
              appBar: const RequestAppBar(title: 'Заявка'),
              body: Center(child: Text(state.message)),
            );
          }
          if (state is BusinessTripRequestViewLoaded) {
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
                  Text('Командировка', style: AppTypography.title1Bold),
                  const SizedBox(height: 24),
                  const SectionLabel('Период'),
                  const SizedBox(height: 2),
                  Text(
                    AppDateUtils.formatDateRange(request.period),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Откуда'),
                  const SizedBox(height: 2),
                  Text(
                    businessTripCityLabel(request.fromCity),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Куда'),
                  const SizedBox(height: 2),
                  Text(
                    businessTripCityLabel(request.toCity),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Цель'),
                  const SizedBox(height: 2),
                  Text(
                    businessTripPurposeLabel(request.purpose),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  if (request.purpose == BusinessTripPurpose.other &&
                      (request.purposeDescription != null &&
                          request.purposeDescription!.isNotEmpty)) ...[
                    const SizedBox(height: 8),
                    const SectionLabel('Текстовое описание цели'),
                    const SizedBox(height: 2),
                    Text(
                      request.purposeDescription!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const SectionLabel('Цель по виду деятельности'),
                  const SizedBox(height: 2),
                  Text(
                    businessTripActivityLabel(request.activity),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Планируемые мероприятия'),
                  const SizedBox(height: 2),
                  Text(
                    request.plannedEvents,
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('За чей счет'),
                  const SizedBox(height: 2),
                  Text(
                    businessTripAccountLabel(request.account),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel(
                    'Подбор услуг по командировке тревел-координатором',
                  ),
                  const SizedBox(height: 2),
                  Text(
                    travelCoordinatorServiceLabel(request.coordinatorService),
                    style: AppTypography.text1Regular.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  if (request.comment != null &&
                      request.comment!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const SectionLabel('Комментарий'),
                    const SizedBox(height: 2),
                    Text(
                      request.comment!,
                      style: AppTypography.text1Regular.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Командируемые', style: AppTypography.title2Bold),
                  const SizedBox(height: 8),
                  ...request.participants.map(
                    (p) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel('Имя командируемого'),
                        const SizedBox(height: 2),
                        Text(
                          p.fullName,
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
}
