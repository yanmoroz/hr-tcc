import 'package:flutter/material.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';

import '../../../blocs/unplanned_training_request/unplanned_training_request_bloc.dart';

class SubmitButtonSection<B extends BlocBase<S>, S> extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(BuildContext context) onSubmit;
  const SubmitButtonSection({
    super.key,
    required this.formKey,
    required this.onSubmit,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        bool isEnabled = true;
        bool isLoading = false;
        // Для курьерской заявки
        if (state is CourierRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is AlpinaRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is WorkCertificateRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is ViolationRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is AbsenceRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is ReferralProgramRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is TwoNdflRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is PassRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.loading;
        }
        if (state is ParkingRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.loading;
        }
        if (state is BusinessTripRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.loading;
        }
        if (state is UnplannedTrainingRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        if (state is WorkBookRequestState) {
          isEnabled = state.isFormValid;
          isLoading = state.isSubmitting;
        }
        return AppButton(
          text: 'Создать',
          isFullWidth: true,
          isDisabled: !isEnabled,
          isLoading: isLoading,
          onPressed: () => onSubmit(context),
        );
      },
    );
  }
}
