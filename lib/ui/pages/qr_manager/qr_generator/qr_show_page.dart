import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRShowPage extends StatefulWidget {
  @override
  _QRShowPageState createState() => _QRShowPageState();
}

class _QRShowPageState extends State<QRShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Tạo QR',
          context: context,
        ),
        body: Center(
          child: QrImage(
            data: "https://pub.dev/packages/qr_flutter",
            version: QrVersions.auto,
            size: 200.0,
          ),
        )
    );
  }
}
