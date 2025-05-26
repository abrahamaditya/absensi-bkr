// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/menu/login_menu.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_event.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_state.dart';

final AuthService _authService = AuthService();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<InitLoginEvent>((data, emit) async {
      emit(AuthInitial());
    });
    on<LoginCheckEvent>((data, emit) async {
      emit(AuthLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final loginTimestamp = prefs.getInt('loginTimestamp');

        if (loginTimestamp == null) {
          // Jika tidak ada timestamp, sesi dianggap tidak valid
          emit(AuthInitial());
          return; // Menghentikan proses jika null
        }

        // Hitung selisih waktu sekarang dengan waktu login
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final elapsedHours = (currentTime - loginTimestamp) / (1000 * 60 * 60);

        if (elapsedHours > 12) {
          // Jika lebih dari 12 jam, sesi tidak valid
          emit(AuthInitial());
        } else {
          // Jika sesi valid
          emit(AuthValidSuccess());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((data, emit) async {
      try {
        final auth = await _authService.masuk(
            email: data.email, password: data.password);

        // Simpan waktu login ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'loginTimestamp', DateTime.now().millisecondsSinceEpoch);

        emit(AuthSuccess(auth!));
        ScaffoldMessenger.of(data.context).showSnackBar(
          SnackBar(
            backgroundColor: green,
            duration: Duration(seconds: 3),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            showCloseIcon: true,
            closeIconColor: white,
            content: Text(
              "Login Berhasil",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: white,
              ),
            ),
          ),
        );
        Navigator.pushReplacement(
          data.context,
          MaterialPageRoute(
            builder: (context) => const MasterMenu(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(data.context).showSnackBar(
          SnackBar(
            backgroundColor: red,
            duration: Duration(seconds: 3),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            showCloseIcon: true,
            closeIconColor: white,
            content: Text(
              "Gagal Login. Email atau Password salah",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: white,
              ),
            ),
          ),
        );
        return;
      }
    });
    on<LogoutEvent>((data, emit) async {
      try {
        await _authService.keluar();

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('loginTimestamp');

        emit(LogoutSuccess());
        Navigator.pushReplacement(
          data.context,
          MaterialPageRoute(
            builder: (context) => const LoginMenu(),
          ),
        );
      } catch (e) {
        emit(
          LogoutError(e.toString()),
        );
      }
    });
  }
}

class ObscurePasswordBloc extends Bloc<AuthEvent, AuthState> {
  ObscurePasswordBloc() : super(AuthInitial()) {
    on<FetchObscurePasswordEvent>((option, emit) async {
      try {
        if (option.isShow == true) {
          emit(ObscurePasswordShow(true));
        } else {
          emit(ObscurePasswordHide(false));
        }
      } catch (e) {
        emit(
          AuthError(e.toString()),
        );
      }
    });
  }
}
