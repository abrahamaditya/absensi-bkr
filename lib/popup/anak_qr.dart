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

  const QRCodePopup({super.key, required this.id, required this.name});

  @override
  State<QRCodePopup> createState() => _QRCodePopupState();
}

class _QRCodePopupState extends State<QRCodePopup> {
  final GlobalKey _popupKey = GlobalKey(); // Key untuk RepaintBoundary

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: transparent,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            RepaintBoundary(
              key: _popupKey, // Membungkus seluruh pop-up
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 460,
                  minHeight: 480,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [orange, lightOrange],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/logo/logo-bkr.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    QrImageView(
                      data: widget.id,
                      size: 220,
                      version: QrVersions.auto,
                      backgroundColor: white,
                      padding: EdgeInsets.all(15),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ID: ",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: white,
                            ),
                          ),
                          Text(
                            widget.id,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: white, width: 2),
                        color: orange,
                      ),
                      child: Text(
                        widget.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.close, color: white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              top: 8,
              right: 45,
              child: IconButton(
                icon: Icon(Icons.download_outlined, color: white),
                onPressed: () async {
                  await _downloadPopupAsImage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPopupAsImage() async {
    try {
      final RenderRepaintBoundary boundary =
          _popupKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "${widget.name}_${widget.id}_QR Code.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      return;
    }
  }
}
