import 'package:equatable/equatable.dart';

abstract class SidebarMenuEvent extends Equatable {}

class InitEvent extends SidebarMenuEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class FetchSidebarMenuEvent extends SidebarMenuEvent {
  final String? menu;
  final dynamic data;
  final dynamic detailKegiatanPreviousMenu;
  FetchSidebarMenuEvent(
      {required this.menu, this.data, this.detailKegiatanPreviousMenu});
  @override
  List<Object?> get props => [];
}
