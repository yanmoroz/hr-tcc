import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_tcc/config/themes/themes.dart';
import 'package:hr_tcc/generated/assets.gen.dart';
import 'package:hr_tcc/presentation/blocs/blocs.dart';
import 'package:hr_tcc/presentation/widgets/common/common.dart';

import '../../blocs/poll_detail/poll_detail_bloc.dart';
import 'shared/finish_button.dart';
import 'widgets/header/header_widget.dart';
import 'widgets/question/question_widget.dart';
import 'widgets/submission_confirmation_widget.dart';

// основной Widget опроса
class PollDetailPage extends StatelessWidget {
  const PollDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PollView();
  }
}

class _PollView extends StatelessWidget {
  const _PollView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PollDetailBloc, PollDetailState>(
      listener: (context, state) {
        if (state is PollDetailSuccess) {
          // показать лист с благодарностью
          appShowModularSheet(
            context: context,
            title: '',
            titleStyle: AppTypography.title4Bold,
            headerHeight: 0,
            bottomGap: 0,
            content: SubmissionConfirmationWidget(
              onFinishPressed: () {
                context.pop();
                context.pop();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PollDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PollDetailFailure) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is PollDetailLoaded) {
          return Stack(
            children: [
              const SizedBox(height: 24),
              Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppNavigationBar(
                  title: '',
                  leftIconAsset: Assets.icons.navigationBar.back.path,
                ),
                body: ListView(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                    bottom: 150,
                  ),
                  children: [
                    HeaderWidget(model: state.poll),
                    const SizedBox(height: 24),
                    ...List.generate(state.poll.questions?.length ?? 0, (
                      index,
                    ) {
                      final questions = state.poll.questions;
                      if (questions == null || index >= questions.length) {
                        return const SizedBox.shrink();
                      }
                      final q = questions[index];
                      final answersForQuestion = state.answers[q.id];
                      if (answersForQuestion == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index < (state.poll.questions?.length ?? 0) - 1
                                  ? 24
                                  : 0,
                        ),
                        child: QuestionWidget(
                          question: q,
                          answers: answersForQuestion,
                          onChanged: (updatedAnswer) {
                            context.read<PollDetailBloc>().add(
                              PollDetailAnswerChanged(
                                questionId: q.id,
                                updatedAnswer: updatedAnswer,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              AppFlostingBottomBar(
                child: FinishButton(
                  text: 'Завершить опрос',
                  onPressed: () {
                    context.read<PollDetailBloc>().add(PollDetailSubmitted());
                  },
                  // enabled: state.allRequiredFilled,
                  enabled: true,
                ),
              ),
            ],
          );
        }
        if (state is PollDetailSubmitting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PollDetailSuccess) {
          return const Scaffold(body: SizedBox());
        }
        return const SizedBox.shrink();
      },
    );
  }
}
