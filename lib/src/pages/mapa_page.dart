import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';



class MapaPage extends StatefulWidget {
  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      children: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayer(  
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',  
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiaGFua2hvbG1lczEwMTAiLCJhIjoiY2xhbDRhMzRmMDFyeTN2bDV2Z2FxbXZyNiJ9.QNpfS0Gs6MeFdTwFBXOaTQ',
        'id'         : 'mapbox/$tipoMapa'
      },
      // streets-v11, dark-v11, light-v11, outdoors-v11, satellite-v9
      userAgentPackageName: 'com.example.app',
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayer(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ],
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if(tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v11';
        } else if( tipoMapa == 'dark-v11') {
          tipoMapa = 'light-v11';
        } else if( tipoMapa == 'light-v11') {
          tipoMapa = 'outdoors-v11';
        } else if( tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else {
          tipoMapa = 'streets-v11';
        }

        setState(() {});
      }
    );
  }
}