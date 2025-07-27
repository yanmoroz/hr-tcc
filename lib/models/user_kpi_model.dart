class KpiMetric {
  final String weight;
  final String fact;
  final String result;

  KpiMetric({required this.weight, required this.fact, required this.result});
}

class KpiIndicator {
  final String title;
  final List<KpiMetric> metrics;

  KpiIndicator({required this.title, required this.metrics});
}

class KpiCard {
  final String title;
  final List<KpiIndicator> indicators;

  KpiCard({required this.title, required this.indicators});
}

class KpiPlanValue {
  final String label;
  final String value;

  KpiPlanValue({required this.label, required this.value});
}

class KpiPeriodGroup {
  final String title;
  final String subtitle;
  final double progress; // от 0.0 до 1.0
  final List<KpiPlanValue> planValues;
  final List<KpiCard> kpiCards;

  KpiPeriodGroup({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.planValues,
    required this.kpiCards,
  });
}
