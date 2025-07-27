part of 'benefit_content_bloc.dart';

abstract class BenefitContentEvent {}

class LoadBenefitContent extends BenefitContentEvent {}

class LikePressed extends BenefitContentEvent {}

class LinkPressed extends BenefitContentEvent {}
