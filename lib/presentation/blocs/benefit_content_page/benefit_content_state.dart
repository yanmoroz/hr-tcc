part of 'benefit_content_bloc.dart';

abstract class BenefitContentState {}

class BenefitContentInitial extends BenefitContentState {}

class BenefitContentLoading extends BenefitContentState {}

class BenefitContentLoaded extends BenefitContentState {
  final List<Widget> widgets;
  final int commentCount;
  final bool isLiked;
  final int likeCount;
  final String? phone;
  final String? email;

  BenefitContentLoaded({
    required this.widgets,
    required this.commentCount,
    required this.isLiked,
    required this.likeCount,
    required this.phone,
    required this.email,
  });

  BenefitContentLoaded copyWith({
    List<Widget>? widgets,
    int? commentCount,
    bool? isLiked,
    int? likeCount,
    String? phone,
    String? email,
  }) {
    return BenefitContentLoaded(
      widgets: widgets ?? this.widgets,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}

class BenefitContentError extends BenefitContentState {
  final String message;

  BenefitContentError(this.message);
}
