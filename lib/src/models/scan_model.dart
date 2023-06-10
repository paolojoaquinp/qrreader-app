import 'package:latlong2/latlong.dart';

class ScanModel {
    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }) {
      if(this.valor.contains('http')) {
        this.tipo = 'http';
      } else {
        this.tipo = 'geo';  
      }
    }

    int id;
    String tipo;
    String valor;

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        tipo  : json["tipo"],
        valor : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "tipo"  : tipo,
        "valor" : valor,
    };

    LatLng getLatLng() {
       // geo:40.724233047051705,-74.00731459101564
      final lalo = valor.substring(4).split(',');
      final lat = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);
      return LatLng(lat, lng);
    }
}
