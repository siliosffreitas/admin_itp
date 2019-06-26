import 'package:admin_itp/blocs/rastreamento_bloc.dart';
import 'package:admin_itp/screens/primeiramente_cadastr_para_ver.dart';
import 'package:admin_itp/tiles/linha_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'horarios_linha_screen.dart';

class DetalhesParadaScreen extends StatefulWidget {
  final int codigoParada;

  DetalhesParadaScreen({Key key, @required this.codigoParada})
      : super(key: key);

  @override
  _DetalhesParadaScreenState createState() => _DetalhesParadaScreenState();
}

class _DetalhesParadaScreenState extends State<DetalhesParadaScreen> {
  GoogleMapController _mapController;

  LatLng _latLng;

  @override
  Widget build(BuildContext context) {
    final _rastreamentoBloc = BlocProvider.of<RastreamentoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Parada ${widget.codigoParada}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('paradas')
                    .where("CodigoParada", isEqualTo: widget.codigoParada)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.documents == null ||
                        snapshot.data.documents.isEmpty) {
                      return PrimeiramenteCadastreParaVer();
                    }

                    return _desenharParada(snapshot.data.documents[0]);
                  }
                }),
            Container(
              height: 10,
              color: Colors.grey[200],
            ),
            Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text(
                  "Linhas",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('linhasDaParada')
                    .where("CodigoParada", isEqualTo: widget.codigoParada)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.documents == null ||
                        snapshot.data.documents.isEmpty) {
                      return PrimeiramenteCadastreParaVer();
                    }

                    return _createListLinhas(
                        snapshot.data.documents[0]['Linhas']);
                  }
                }),
          ],
        ),
      ),
    );
  }

  _desenharParada(DocumentSnapshot parada) {
    _latLng = LatLng(
      double.parse(parada.data['Lat']),
      double.parse(parada.data['Long']),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 250,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _createMarker(_latLng),
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: 15,
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${parada.data['Denomicao']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text("${parada.data['Endereco']}"),
            ],
          ),
        )
      ],
    );
  }

  _createListLinhas(List linhas) {
//    final _rastreamentoBloc = BlocProvider.of<RastreamentoBloc>(context);
    return Column(
      children: linhas.map((linha) {
        return LinhaTile.fromMap(linha);
      }).toList(),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    setState(() {
      _mapController = controller;
    });
  }

  Set<Marker> _createMarker(LatLng latLong) {
    return <Marker>[
      Marker(
          markerId: MarkerId("marker_1"),
          position: latLong,
          icon: Theme.of(context).platform == TargetPlatform.iOS
              ? BitmapDescriptor.fromAsset("assets/ios/stopbus_green.png")
              : BitmapDescriptor.fromAsset("assets/android/stopbus_green.png")),
    ].toSet();
  }
}
