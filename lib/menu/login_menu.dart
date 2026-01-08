import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_bloc.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_state.dart';
import 'package:absensi_bkr/bloc/auth_bloc/auth_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginMenu extends StatelessWidget {
  const LoginMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc()..add(LoginCheckEvent(context: context)),
        ),
        BlocProvider(
          create: (_) => ObscurePasswordBloc()
            ..add(FetchObscurePasswordEvent(isShow: false)),
        ),
      ],
      child: ScreenUtilInit(
        builder: (BuildContext context, Widget? child) => Scaffold(
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthValidSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MasterMenu()),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return SizedBox.shrink();
                } else if (state is AuthInitial || state is AuthError) {
                  return Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('asset/image/backround-low.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: purple.withOpacity(0.92),
                        ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 70),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth < 1000 ? 30 : 40,
                                  vertical: screenWidth < 1000 ? 35 : 45,
                                ),
                                width: screenWidth < 1000 ? 310 : 375,
                                decoration: BoxDecoration(
                                  color: black,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Shalom,",
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              screenWidth < 1000 ? 16 : 18,
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Masuk",
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              screenWidth < 1000 ? 30 : 32,
                                          fontWeight: FontWeight.w700,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    _fieldFormInputUsername(
                                        context, "Nama akun", false),
                                    const SizedBox(height: 15),
                                    _fieldFormInputPassword(context),
                                    const SizedBox(height: 35),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<AuthBloc>().add(
                                              LoginEvent(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  context: context));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Masuk",
                                              style: GoogleFonts.montserrat(
                                                fontSize: screenWidth < 1000
                                                    ? 14
                                                    : 16,
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth < 1000 ? 4 : 6,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: white,
                                              size:
                                                  screenWidth < 1000 ? 18 : 22,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 60),
                              Text(
                                "@2026. BKR MODERNLAND",
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth < 1000 ? 10 : 12,
                                  fontWeight: FontWeight.w500,
                                  color: white,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldFormInputUsername(
      BuildContext context, String hintText, bool isPassword) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return TextField(
      controller: emailController,
      obscureText: isPassword,
      cursorColor: black,
      style: GoogleFonts.montserrat(
        fontSize: screenWidth < 1000 ? 14 : 16,
        fontWeight: FontWeight.w400,
        color: black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: screenWidth < 1000 ? 14 : 16,
          fontWeight: FontWeight.w400,
          color: textFieldGrey,
        ),
        filled: true,
        fillColor: fillFieldGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: purple),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 15,
        ),
      ),
    );
  }

  Widget _fieldFormInputPassword(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ObscurePasswordBloc, AuthState>(
      builder: (context, state) {
        if (state is ObscurePasswordShow) {
          return TextField(
            controller: passwordController,
            obscureText: false,
            cursorColor: black,
            style: GoogleFonts.montserrat(
              fontSize: screenWidth < 1000 ? 14 : 16,
              fontWeight: FontWeight.w400,
              color: black,
            ),
            decoration: InputDecoration(
              hintText: "Sandi",
              hintStyle: GoogleFonts.montserrat(
                fontSize: screenWidth < 1000 ? 14 : 16,
                fontWeight: FontWeight.w400,
                color: lightGrey,
              ),
              filled: true,
              fillColor: fillFieldGrey,
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 15),
                icon: Icon(
                  Icons.visibility,
                  color: textFieldGrey,
                  size: screenWidth < 1000 ? 18 : 15,
                ),
                onPressed: () {
                  context.read<ObscurePasswordBloc>().add(
                        FetchObscurePasswordEvent(isShow: false),
                      );
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: lightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: purple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 15,
              ),
            ),
          );
        } else if (state is ObscurePasswordHide) {
          return TextField(
            controller: passwordController,
            obscureText: true,
            cursorColor: black,
            style: GoogleFonts.montserrat(
              fontSize: screenWidth < 1000 ? 14 : 16,
              fontWeight: FontWeight.w400,
              color: black,
            ),
            decoration: InputDecoration(
              hintText: "Sandi",
              hintStyle: GoogleFonts.montserrat(
                fontSize: screenWidth < 1000 ? 14 : 16,
                fontWeight: FontWeight.w400,
                color: textFieldGrey,
              ),
              filled: true,
              fillColor: fillFieldGrey,
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 15),
                icon: Icon(
                  Icons.visibility_off,
                  color: textFieldGrey,
                  size: screenWidth < 1000 ? 18 : 16,
                ),
                onPressed: () {
                  context.read<ObscurePasswordBloc>().add(
                        FetchObscurePasswordEvent(isShow: true),
                      );
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: lightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: purple),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 15,
              ),
            ),
            onSubmitted: (value) {
              context.read<AuthBloc>().add(
                    LoginEvent(
                      email: emailController.text,
                      password: passwordController.text,
                      context: context,
                    ),
                  );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
