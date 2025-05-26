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
                  minWidth: 368,
                  minHeight: 544,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        widget.name,
                        style: TextStyle(
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
                        padding: EdgeInsets.all(10),
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
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: red, // border merah
                    width: 2,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets
                      .zero, // supaya iconnya pas di tengah container kecil
                  iconSize: 18, // bisa atur sesuai selera
                  icon: Icon(
                    Icons.close,
                    color: red,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 55,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: red, // background putih
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: white, // border merah
                    width: 2,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: Icon(
                    Icons.download_rounded,
                    color: white,
                  ),
                  onPressed: () async {
                    await _downloadPopupAsImage();
                  },
                ),
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

      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "${widget.name}_${widget.id}_QR_Code.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print("Download error: $e");
    }
  }
}
