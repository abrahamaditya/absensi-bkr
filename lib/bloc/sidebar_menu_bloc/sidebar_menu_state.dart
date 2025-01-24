import 'package:equatable/equatable.dart';

abstract class SidebarMenuState extends Equatable {
  const SidebarMenuState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class SidebarMenuInitial extends SidebarMenuState {}

class SidebarMenuSuccess extends SidebarMenuState {
  final String? menu;
  final dynamic data;
  final dynamic detailKegiatanPreviousMenu;
  const SidebarMenuSuccess(
      {this.menu, this.data, this.detailKegiatanPreviousMenu});
  @override
  List<Object> get props => [menu!, data];
}

class SidebarMenuError extends SidebarMenuState {
  final String errMessage;
  const SidebarMenuError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}
