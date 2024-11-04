import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardController {}

final dashboardProvider = StateProvider<int>((ref) {
  return 0;
});

void onChangeDashboardProvider(WidgetRef ref, int val) {
  ref.read(dashboardProvider.notifier).state = val;
}
