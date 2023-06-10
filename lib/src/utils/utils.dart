import 'package:url_launcher/url_launcher.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';
import 'package:flutter/material.dart';

Future<void> abrirScan(BuildContext context, ScanModel scan) async {
  if(scan.tipo == 'http') {
    final Uri _url = Uri.parse(scan.valor);

    if (!await launchUrl(_url)) {
      throw 'Could not launch ${scan.valor}';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}