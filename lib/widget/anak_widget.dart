import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/grade.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:absensi_bkr/helper/padding.dart';
import 'package:absensi_bkr/model/kid_model.dart';
import 'package:absensi_bkr/menu/master_menu.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_bloc.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_event.dart';
import 'package:absensi_bkr/bloc/kids_bloc/kids_state.dart';
import 'package:absensi_bkr/component/dynamic_pagination.dart';
import 'package:absensi_bkr/popup/delete_confirmation_anak_popup.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_bloc.dart';
import 'package:absensi_bkr/bloc/sidebar_menu_bloc/sidebar_menu_event.dart';

bool isDataActuallyThere = false;
final TextEditingController namaAnakController = TextEditingController();

Widget semuaAnakWidget(BuildContext context) {
  final ScrollController scrollController = ScrollController();
  final double screenWidth = MediaQuery.of(context).size.width;

  return screenWidth < 1000
      ? mobileLayout(context)
      : Container(
          color: white,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.025,
                  child: Image.asset(
                    'asset/image/background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: paddingMenu,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Semua Anak",
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: black,
                                ),
                              ),
                              Text(
                                "${kelasOptions[1]} - ${kelasOptions.last}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<SidebarMenuBloc>().add(
                                    FetchSidebarMenuEvent(
                                        menu: "Anak Tambah Data",
                                        data: Object()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add, color: white),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Tambah Anak",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: lightGrey,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<GetKidsBloc, KidsState>(
                        builder: (context, state) {
                          if (tableLoadingAnak == false) {
                            tableLoadingAnak = true;
                            return Skeletonizer(
                              enabled: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 2,
                                    runSpacing: 0,
                                    children: [
                                      Text(
                                        "Total Data: ",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Text(
                                        "0 dari 00 anak",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    height: 400,
                                    width: double.infinity,
                                    color: lightGrey,
                                  ),
                                ],
                              ),
                            );
                          } else if (state is KidsGetData) {
                            isDataActuallyThere = true;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 2,
                                  runSpacing: 0,
                                  children: [
                                    Text(
                                      "Total Data: ",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: black,
                                      ),
                                    ),
                                    Text(
                                      "${state.data.length} dari ${state.totalData} anak",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  color: purple,
                                  padding: EdgeInsets.all(20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 300,
                                      child: _fieldCariData(
                                        context,
                                        namaAnakController,
                                        false,
                                      ),
                                    ),
                                  ),
                                ),
                                screenWidth < 1200
                                    ? GestureDetector(
                                        onHorizontalDragUpdate: (details) {
                                          scrollController.jumpTo(
                                            scrollController.offset -
                                                details.delta.dx,
                                          );
                                        },
                                        child: Scrollbar(
                                          controller: scrollController,
                                          thumbVisibility: true,
                                          scrollbarOrientation:
                                              ScrollbarOrientation.bottom,
                                          child: SingleChildScrollView(
                                            controller: scrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: _tabel(context, state.data,
                                                state.currentPage, true,
                                                isMobile: false),
                                          ),
                                        ),
                                      )
                                    : _tabel(context, state.data,
                                        state.currentPage, false,
                                        isMobile: false),
                                SizedBox(height: 20),
                                DynamicPagination(
                                  currentPage: state.currentPage,
                                  totalPages: state.totalPage,
                                  onPageChanged: (pageNumber) {
                                    selectedPaginationNumberOfAllAnakPage =
                                        pageNumber;
                                    context.read<GetKidsBloc>().add(
                                          FetchKidsEvent(
                                            page: pageNumber,
                                            searchNameQuery:
                                                namaAnakController.text,
                                          ),
                                        );
                                  },
                                ),
                              ],
                            );
                          } else if (state is KidsGetDataIsEmpty) {
                            if (isDataActuallyThere == false) {
                              return Text(
                                "Data anak tidak ditemukan.",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: lightGrey,
                                ),
                              );
                            } else {
                              List<Kid> data = [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pencarian \"${state.searchNameQuery}\" tidak ditemukan",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    color: purple,
                                    padding: EdgeInsets.all(20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 300,
                                        child: _fieldCariData(
                                          context,
                                          namaAnakController,
                                          false,
                                        ),
                                      ),
                                    ),
                                  ),
                                  screenWidth < 1200
                                      ? GestureDetector(
                                          onHorizontalDragUpdate: (details) {
                                            scrollController.jumpTo(
                                              scrollController.offset -
                                                  details.delta.dx,
                                            );
                                          },
                                          child: Scrollbar(
                                            controller: scrollController,
                                            thumbVisibility: true,
                                            scrollbarOrientation:
                                                ScrollbarOrientation.bottom,
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              scrollDirection: Axis.horizontal,
                                              child: _tabel(
                                                context,
                                                data,
                                                selectedPaginationNumberOfAllAnakPage,
                                                true,
                                                isMobile: true,
                                              ),
                                            ),
                                          ),
                                        )
                                      : _tabel(
                                          context,
                                          data,
                                          selectedPaginationNumberOfAllAnakPage,
                                          false,
                                          isMobile: false,
                                        )
                                ],
                              );
                            }
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
}

Widget _tabel(
    BuildContext context, List<Kid> data, int currentPage, bool isSmallScreen,
    {required bool isMobile}) {
  Map<int, TableColumnWidth>? smallScreen = {
    0: FixedColumnWidth(60), // Kolom "No."
    1: FixedColumnWidth(150), // Kolom "ID"
    2: FixedColumnWidth(300), // Kolom "Nama"
    3: FixedColumnWidth(120), // Kolom "Jumlah Kehadiran"
    4: FixedColumnWidth(240), // Kolom "Aksi"
    5: FixedColumnWidth(100), // Kolom "Aksi"
  };
  Map<int, TableColumnWidth>? normalScreen = {
    0: FractionColumnWidth(0.065), // 6,5%
    1: FractionColumnWidth(0.15), // 15%
    2: FractionColumnWidth(0.3), // 30%
    3: FractionColumnWidth(0.15), // 15%
    4: FractionColumnWidth(0.235), // 23,5%
    5: FractionColumnWidth(0.1), // 10%
  };
  return Table(
    columnWidths: {
      if (isSmallScreen) ...smallScreen,
      if (!isSmallScreen) ...normalScreen,
    },
    children: [
      TableRow(
        decoration: BoxDecoration(color: purple),
        children: [
          _headerTabel(context, "No.", isMobile),
          _headerTabel(context, "ID", isMobile),
          _headerTabel(context, "Nama", isMobile),
          _headerTabel(context, "Jumlah Kehadiran", isMobile),
          _headerTabel(context, "", isMobile),
          _headerTabel(context, "", isMobile),
        ],
      ),
      // Data Baris Tabel
      for (var i = 0; i < data.length; i++)
        _barisTabel(
          context,
          ((currentPage - 1) * 20) + (i + 1), // Perhitungan nomor
          data[i],
          isMobile,
        ), // Ambil data[i] untuk setiap baris
    ],
  );
}

Widget _headerTabel(BuildContext context, title, bool isMobile) {
  return Container(
    height: isMobile == true ? 50 : 75,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: white,
      ),
    ),
  );
}

TableRow _barisTabel(
    BuildContext parentContext, int index, Kid kid, bool isMobile) {
  return TableRow(
    decoration: BoxDecoration(
      color: index % 2 == 0 ? fillFieldGrey : white,
    ),
    children: [
      _selTabel("$index.", isCenter: true),
      _selTabel(kid.id!),
      _selTabel(kid.name!, isCenter: true),
      _selTabel(kid.attendance!.length.toString()),
      _selTabel(
        kid.attendance!.length.toString(),
        action: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              parentContext
                  .read<SidebarMenuBloc>()
                  .add(FetchSidebarMenuEvent(menu: "Anak Detail", data: kid));
            },
            style: TextButton.styleFrom(
              foregroundColor: orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              "Lihat Profil & Kehadiran",
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: orange,
              ),
            ),
          ),
        ),
      ),
      isMobile == true
          ? Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: parentContext,
                    builder: (context) {
                      return DeleteConfirmationAnakPopup(
                        parentContext: parentContext,
                        kidData: kid,
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_outline_rounded),
                iconSize: 14,
                color: red,
              ),
            )
          : Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: parentContext,
                    builder: (context) {
                      return DeleteConfirmationAnakPopup(
                        parentContext: parentContext,
                        kidData: kid,
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  "Hapus",
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile == true ? 10 : 14,
                    fontWeight: FontWeight.w600,
                    color: red,
                  ),
                ),
              ),
            ),
    ],
  );
}

Widget _selTabel(String text, {bool isCenter = false, Widget? action}) {
  return Container(
    height: 50,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    child: action ??
        Text(
          text,
          textAlign: isCenter ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: black,
          ),
        ),
  );
}

Widget _fieldCariData(
    BuildContext context, TextEditingController controller, bool isMobile) {
  return TextField(
    controller: controller,
    cursorColor: black,
    keyboardType: TextInputType.text,
    style: GoogleFonts.montserrat(
      fontSize: isMobile == true ? 12 : 14,
      fontWeight: FontWeight.w400,
      color: black,
    ),
    decoration: InputDecoration(
      hintText: 'Cari nama anak',
      hintStyle: GoogleFonts.montserrat(
        fontSize: isMobile == true ? 12 : 14,
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
        vertical: 12,
        horizontal: 20,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Icon(
          Icons.search,
          color: textFieldGrey,
        ),
      ),
      isDense: true,
    ),
    onSubmitted: (value) {
      context.read<GetKidsBloc>().add(
            FetchKidsEvent(
              page: 1,
              searchNameQuery: controller.text,
            ),
          );
    },
  );
}

Widget mobileLayout(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return ScrollConfiguration(
    behavior: const ScrollBehavior().copyWith(overscroll: false),
    child: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Semua Anak",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: black,
                    ),
                  ),
                  Text(
                    "${kelasOptions[1]} - ${kelasOptions.last}",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SidebarMenuBloc>().add(FetchSidebarMenuEvent(
                        menu: "Anak Tambah Data", data: Object()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 14,
                    ),
                  ),
                  child: screenWidth < 430
                      ? Icon(
                          Icons.add,
                          color: white,
                          size: 18,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.add,
                              color: white,
                              size: 12,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Tambah Anak",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          BlocBuilder<GetKidsBloc, KidsState>(
            builder: (context, state) {
              if (tableLoadingAnak == false) {
                tableLoadingAnak = true;
                return Skeletonizer(
                  enabled: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        color: lightGrey,
                      ),
                      const SizedBox(height: 15),
                      ...List.generate(
                        5,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: Container(
                              height: 75,
                              width: double.infinity,
                              color: lightGrey,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else if (state is KidsGetData) {
                isDataActuallyThere = true;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _fieldCariData(context, namaAnakController, true),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        final kid = state.data[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: white,
                            border: Border.all(
                              color: lightGrey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 16,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: purple,
                              radius: 18,
                              child: Icon(
                                Icons.person,
                                color: white,
                                size: 19,
                              ),
                            ),
                            title: Text(
                              kid.name!,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: black,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Jumlah Kehadiran: ",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: textFieldGrey,
                                  ),
                                ),
                                Text(
                                  "${kid.attendance!.length}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textFieldGrey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: purple,
                              size: 14,
                            ),
                            onTap: () {
                              context.read<SidebarMenuBloc>().add(
                                    FetchSidebarMenuEvent(
                                      menu: "Anak Detail",
                                      data: kid,
                                    ),
                                  );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tombol pertama untuk ke halaman pertama
                        IconButton(
                          icon: Icon(Icons.keyboard_double_arrow_left,
                              color:
                                  state.currentPage > 1 ? purple : Colors.grey),
                          onPressed: state.currentPage > 1
                              ? () {
                                  selectedPaginationNumberOfAllAnakPage = 1;
                                  context
                                      .read<GetKidsBloc>()
                                      .add(FetchKidsEvent(
                                        page:
                                            selectedPaginationNumberOfAllAnakPage,
                                        searchNameQuery:
                                            namaAnakController.text,
                                      ));
                                }
                              : null, // Disabled jika di halaman pertama
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          // Menghilangkan efek hover dan splash
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          mouseCursor: SystemMouseCursors
                              .click, // Menghilangkan cursor hover default
                        ),
                        // Tombol sebelumnya
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_left,
                              color:
                                  state.currentPage > 1 ? purple : Colors.grey),
                          onPressed: state.currentPage > 1
                              ? () {
                                  selectedPaginationNumberOfAllAnakPage =
                                      state.currentPage - 1;
                                  context
                                      .read<GetKidsBloc>()
                                      .add(FetchKidsEvent(
                                        page:
                                            selectedPaginationNumberOfAllAnakPage,
                                        searchNameQuery:
                                            namaAnakController.text,
                                      ));
                                }
                              : null, // Disabled jika di halaman pertama
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          // Menghilangkan efek hover dan splash
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          mouseCursor: SystemMouseCursors.click,
                        ),
                        // Tombol berikutnya
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right,
                              color: state.currentPage < state.totalPage
                                  ? purple
                                  : Colors.grey),
                          onPressed: state.currentPage < state.totalPage
                              ? () {
                                  selectedPaginationNumberOfAllAnakPage =
                                      state.currentPage + 1;
                                  context
                                      .read<GetKidsBloc>()
                                      .add(FetchKidsEvent(
                                        page:
                                            selectedPaginationNumberOfAllAnakPage,
                                        searchNameQuery:
                                            namaAnakController.text,
                                      ));
                                }
                              : null, // Disabled jika di halaman terakhir
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          // Menghilangkan efek hover dan splash
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          mouseCursor: SystemMouseCursors.click,
                        ),
                        // Tombol terakhir untuk ke halaman terakhir
                        IconButton(
                          icon: Icon(Icons.keyboard_double_arrow_right,
                              color: state.currentPage < state.totalPage
                                  ? purple
                                  : Colors.grey),
                          onPressed: state.currentPage < state.totalPage
                              ? () {
                                  selectedPaginationNumberOfAllAnakPage =
                                      state.totalPage;
                                  context
                                      .read<GetKidsBloc>()
                                      .add(FetchKidsEvent(
                                        page:
                                            selectedPaginationNumberOfAllAnakPage,
                                        searchNameQuery:
                                            namaAnakController.text,
                                      ));
                                }
                              : null, // Disabled jika di halaman terakhir
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          // Menghilangkan efek hover dan splash
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          mouseCursor: SystemMouseCursors.click,
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is KidsGetDataIsEmpty) {
                if (isDataActuallyThere == false) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          "Data anak tidak ditemukan.",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: lightGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // List<Kid> data = [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pencarian \"${state.searchNameQuery}\" tidak ditemukan",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: _fieldCariData(
                          context,
                          namaAnakController,
                          true,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    ),
  );
}
