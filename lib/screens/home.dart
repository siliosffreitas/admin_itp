import 'dart:async';
import 'package:flutter/services.dart';
import 'package:admin_itp/utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'custom_drawer.dart';
import 'linhas_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController _mapController;

  LocationData _startLocation;
  LocationData _currentLocation;
  bool _permission = false;
  Location _locationService = new Location();
  StreamSubscription<LocationData> _locationSubscription;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(-5.082618, -42.790596),
    zoom: 11,
  );
  CameraPosition _currentCameraPosition;
  String error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

//    FirebaseFirestore firestore = FirebaseFirestore.getInstance();
//    FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
//        .setTimestampsInSnapshotsEnabled(true)
//       .build();
//    firestore.setFirestoreSettings(settings);

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));

            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
//    _mapController = controller;
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LinhasScreen()));
              },
              tooltip: "Buscar por linha",
            )
          ],
        ),
        drawer: CustomDrawer(),
        body:
//        SingleChildScrollView(
//          child:

            Container(
          child: GoogleMap(

//              compassEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
//            onMapCreated: (GoogleMapController controller) {
//              _controller.complete(controller);
//            },
//            initialCameraPosition: _currentCameraPosition,
            initialCameraPosition: _initialCamera,
//            markers: _createMarker(_latLng),
//              initialCameraPosition: CameraPosition(
//                target: LatLng(-5.082618, -42.790596),
//                zoom: 11,
//              ),
          ),
        )

//          Column(
//            children: <Widget>[
//              RaisedButton(
//                  child: Text("Montar linhas"), onPressed: null //_montarLinhas,
//                  ),
//              RaisedButton(
//                  child: Text("Montar paradas"),
//                  onPressed: null //_montarParadas,
//                  ),
//              RaisedButton(
//                  child: Text("Montar horários"),
//                  onPressed: null //_montarHorarios,
//                  ),
//              RaisedButton(
//                child: Text("Montar linhas da parada"),
//                onPressed: null//_montarLinhasDaParada,
//              )
//            ],
//          ),
//        )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

//  _montarLinhas() {
//    List<Map<String, dynamic>> _linhas = linhas;
//    try {
//      _linhas.forEach((map) {
//        Firestore.instance.collection("linhas").add(map).then((doc) {
////        cartProduct.cid = doc.documentID;
//          print(map['CodigoLinha']);
//        });
//      });
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  _montarParadas() {
//    List<Map<String, dynamic>> _paradas = paradas;
//    try {
//      _paradas.forEach((map) {
//        Firestore.instance.collection("paradas").add(map).then((doc) {
//          print(map['CodigoParada']);
//        });
//      });
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  _montarHorarios() {
//    Map<String, Map<String, dynamic>> _horarios = horarios;
//    _horarios.keys.forEach((linha) {
//      Map<String, dynamic> horarioMap = _horarios[linha];
//      horarioMap['CodigoLinha'] = linha;
//
//      Firestore.instance.collection("horarios").add(horarioMap).then((doc) {
//        print(linha);
//      });
//    });
//  }
//
//  _montarLinhasDaParada() {
//    List<List<Map<String, dynamic>>> _linhasDaParada = linhasDaParada;
//    for (int parada = 0; parada < _linhasDaParada.length; parada++) {
//      if (_linhasDaParada[parada] != null) {
//        Map<String, dynamic> linhaParada = {
//          'CodigoParada': parada,
//          'Linhas': []
//        };
////        print("--- inicio ${parada}");
//        for (int linha = 0; linha < _linhasDaParada[parada].length; linha++) {
////          print("  * ${parada} ${_linhasDaParada[parada][linha]['CodigoLinha']}");
//          Map<String, dynamic> linhaMap = {
//            'CodigoLinha': _linhasDaParada[parada][linha]['CodigoLinha'],
//          };
//          List ds = linhaParada['Linhas'];
//          ds.add(linhaMap);
//          linhaParada['Linhas'] = ds;
//        }
//
////        print("--- fim ${parada}");
////      print(linhaParada);
//        Firestore.instance
//            .collection("linhasDaParada")
//            .add(linhaParada)
//            .then((doc) {
//          print(parada);
//        });
//      }
//    }

//    Map<String, Map<String, dynamic>> _horarios = horarios;
//    _horarios.keys.forEach((linha) {
//      Map<String, dynamic> horarioMap = _horarios[linha];
//      horarioMap['CodigoLinha'] = linha;
//
//      Firestore.instance.collection("horarios").add(horarioMap).then((doc) {
//        print(linha);
//      });
//    });
//  }
}
