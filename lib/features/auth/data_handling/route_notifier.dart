import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavItem { dashboard, journey }

class RouteNotifier extends StateNotifier<NavItem> {
  RouteNotifier() : super(NavItem.dashboard);

  void setNavItem(NavItem item) {
    state = item;
  }
}

final routeNotifierProvider = StateNotifierProvider<RouteNotifier, NavItem>(
  (ref) => RouteNotifier(),
);
