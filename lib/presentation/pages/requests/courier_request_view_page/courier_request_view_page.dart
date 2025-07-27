import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/domain/repositories/repositories.dart';
import 'package:hr_tcc/domain/usecases/usecases.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/pages/requests/courier_request_view_page/components/components.dart';
import 'package:hr_tcc/presentation/pages/requests/components/components.dart';

class CourierRequestViewPage extends StatelessWidget {
  final String requestId;
  const CourierRequestViewPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => CourierRequestViewBloc(
            FetchCourierRequestDetailsUseCase(CourierRequestRepositoryMock()),
          )..add(LoadCourierRequestDetails(requestId)),
      child: const _CourierRequestView(),
    );
  }
}

class _CourierRequestView extends StatelessWidget {
  const _CourierRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RequestAppBar(title: 'Заявка'),
      backgroundColor: AppColors.white,
      body: BlocBuilder<CourierRequestViewBloc, CourierRequestViewState>(
        builder: (context, state) {
          if (state is CourierRequestDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CourierRequestDetailsError) {
            return Center(child: Text(state.message));
          }
          if (state is CourierRequestDetailsLoaded) {
            final d = state.details;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                RequestStatusDateRow(
                  status: StatusChip(status: d.status),
                  date: d.createdAt,
                ),
                const Gap(12),
                GeneralInfoSection(details: d),
                const Gap(24),
                SenderSection(details: d),
                const Gap(24),
                DeliveryDatesSection(details: d),
                const Gap(24),
                ReceiverSection(details: d),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
