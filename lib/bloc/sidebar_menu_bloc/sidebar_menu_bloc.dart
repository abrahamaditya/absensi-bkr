import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_state.dart';

class SidebarMenuBloc extends Bloc<SidebarMenuEvent, SidebarMenuState> {
  SidebarMenuBloc() : super(SidebarMenuInitial()) {
    on<FetchSidebarMenuEvent>((input, emit) async {
      try {
        emit(SidebarMenuSuccess(
            menu: input.menu!,
            data: input.data,
            detailKegiatanPreviousMenu: input.detailKegiatanPreviousMenu));
      } catch (e) {
        emit(
          SidebarMenuError(e.toString()),
        );
      }
    });
  }
}
