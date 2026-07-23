import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/domain/vm_navigator_service.dart';
import 'demo_routes.dart';

/// Drives navigation from a Cubit, with **no `BuildContext`**: resolves
/// [VmNavigatorService] once at construction (typically via GetIt) and
/// calls it directly. State is the number of times it has navigated, so
/// the demo screen has something observable to render.
class DemoNavigationCubit extends Cubit<int> {
  DemoNavigationCubit(this._navigator) : super(0);

  final VmNavigatorService _navigator;

  void goHome() {
    emit(state + 1);
    _navigator.go(const DemoHomeRoute());
  }
}
