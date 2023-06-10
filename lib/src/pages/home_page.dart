import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

import 'direcciones_page.dart';
import 'mapas_page.dart';

import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapas'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          label: 'Direcciones'
        ),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch(paginaActual) {
      case 0:
        return MapasPage();
      case 1: 
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  _scanQR(BuildContext context) async {
    // https://fernando-herrera.com
    // geo:40.724233047051705,-74.00731459101564

/*    String futureString = ''; */
   String futureString;
   try {
      futureString = await new QRCodeReader().scan();
    } catch(e) {
      futureString = e.toString();
    }

    if(futureString != null ) { 
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

     /*  final scan2 = ScanModel(valor: 'geo:40.724233047051705,-74.00731459101564');
      scansBloc.agregarScan(scan2); */
      if(Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750),(){
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }
  }
}