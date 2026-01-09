// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:absensi_bkr/helper/color.dart';
import 'package:google_fonts/google_fonts.dart';

class QRCodePopup extends StatefulWidget {
  final String id;
  final String name;

  const QRCodePopup({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<QRCodePopup> createState() => _QRCodePopupState();
}

class _QRCodePopupState extends State<QRCodePopup> {
  final GlobalKey _popupKey = GlobalKey();
  bool _isReady = false; // Flag untuk melacak kesiapan gambar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Memuat gambar ke cache sebelum render dimulai
    _prepareAssets();
  }

  Future<void> _prepareAssets() async {
    const imageProvider = AssetImage('asset/badge/badge.png');
    try {
      // Menunggu gambar benar-benar siap didekode oleh Flutter
      await precacheImage(imageProvider, context);
      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat background: $e");
      // Tetap tampilkan konten meskipun gambar gagal agar tidak stuck di loading
      if (mounted) setState(() => _isReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedOpacity(
        // Efek fade-in selama 400ms agar lebih smooth
        opacity: _isReady ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        child: _isReady
            ? _buildPopupContent()
            : const SizedBox(
                height: 544,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.white))),
      ),
    );
  }

  Widget _buildPopupContent() {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // Area yang akan di-capture saat download
          RepaintBoundary(
            key: _popupKey,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 368,
                minHeight: 544,
              ),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/badge/badge.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 147),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontFamily: 'NeatChalk',
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3.5,
                      ),
                    ),
                    child: QrImageView(
                      data: widget.id,
                      size: 130,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ID: ",
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.id,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Download
          Positioned(
            top: 12,
            right: 55,
            child: _buildCircleButton(
              icon: Icons.download_rounded,
              bgColor: red, // Menggunakan variabel warna dari file helper Anda
              iconColor: white,
              onPressed: _downloadPopupAsImage,
            ),
          ),

          // Tombol Close
          Positioned(
            top: 12,
            right: 12,
            child: _buildCircleButton(
              icon: Icons.close,
              bgColor: white,
              iconColor: red,
              borderColor: red,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk tombol agar kode lebih bersih
  Widget _buildCircleButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _downloadPopupAsImage() async {
    try {
      final RenderRepaintBoundary boundary =
          _popupKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Mengambil snapshot dari boundary
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Logika download untuk Web
      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "${widget.name}_${widget.id}_QR_Code.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint("Gagal mengunduh gambar: $e");
    }
  }
}
