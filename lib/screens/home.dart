import 'dart:async';
import 'package:admin_itp/blocs/paradas_bloc.dart';
import 'package:admin_itp/blocs/rastreamento_bloc.dart';
import 'package:admin_itp/utils/utils.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:admin_itp/utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'custom_drawer.dart';
import 'detalhes_parada_screen.dart';
import 'linhas_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController _mapController;

  Set<Polyline> _itinerariosPolyline = {};

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

//  CameraTargetBounds _cameraTargetBounds;
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
            if (_currentCameraPosition != null) {
              return;
            }
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));

            if (mounted) {
              setState(() {
                if (_currentLocation == null) {
                  _currentLocation = result;
                  print(_currentLocation);
                }
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
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _paradasBloc = BlocProvider.of<ParadasBloc>(context);
    final _rastreamentoBloc = BlocProvider.of<RastreamentoBloc>(context);

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
        body: StreamBuilder<List<DocumentSnapshot>>(
            stream: _paradasBloc.outParadas,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Stack(
                alignment: Alignment(0, 1),
                children: <Widget>[
                  Container(
                    child: GoogleMap(
//                      cameraTargetBounds: _cameraTargetBounds,
                      polylines: _itinerariosPolyline,
//              compassEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
//            onMapCreated: (GoogleMapController controller) {
//              _controller.complete(controller);
//            },
//            initialCameraPosition: _currentCameraPosition,
                      initialCameraPosition: _initialCamera,
                      markers: _desenharParadasProximas(snapshot.data),
//            markers: _createMarker(_latLng),
//              initialCameraPosition: CameraPosition(
//                target: LatLng(-5.082618, -42.790596),
//                zoom: 11,
//              ),
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _rastreamentoBloc.outLinhasRastreadas,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.isEmpty) {
                          return Container();
                        }

                        _extrairItinerariosParaPolylines(snapshot.data);

                        return Container(
                          height: 60,
                          color: Colors.white,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.map((linha) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Chip(
                                  avatar: Icon(
                                    Icons.directions_bus,
                                    color: _determinarCor(linha['cor']),
                                  ),
                                  label: Text(linha['CodigoLinha']),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    _rastreamentoBloc
                                        .removerLinha(linha['CodigoLinha']);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      })
                ],
              );
            })

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

  _extrairItinerariosParaPolylines(
      List<Map<String, dynamic>> linhasRastreadas) async {
    Set<Polyline> polylines = {};
    linhasRastreadas.forEach((linha) {
      if (linha['Itinerarios'] != null && linha['Itinerarios'].isNotEmpty) {
//        print(linha['Itinerarios'][0]['Caminho']);
        List<String> coordsStr = linha['Itinerarios'][0]['Caminho'].split("\ ");
        List<LatLng> coords = [];
        coordsStr.forEach((coordsStr) {
//          print("#${coordsStr}#");
          double lat = double.parse(coordsStr.split("\,")[0]);
          double long = double.parse(coordsStr.split("\,")[1]);
          LatLng latLng = LatLng(lat, long);
          coords.add(latLng);
        });

//        setState(() {
        polylines.add(Polyline(
            width: 2,
            polylineId: PolylineId(linha['CodigoLinha']),
            color: _determinarCor(linha['cor']),
            points: coords));
//        });
      }
    });

    _itinerariosPolyline = polylines;

//    LatLng northeast = LatLng(-180, 0);
//    LatLng southwest = LatLng(180, 0);

    double latNortheast = -90;
    double latSouthwest = 90;
    double longEastest = -180;
    double longWestest = 180;

    _itinerariosPolyline.forEach((polyline) {
      polyline.points.forEach((ponto) {
        if (ponto.latitude > latNortheast) {
          latNortheast = ponto.latitude;
        }

        if (ponto.latitude < latSouthwest) {
          latSouthwest = ponto.latitude;
        }

        if (ponto.longitude > longEastest) {
          longEastest = ponto.longitude;
        }

        if (ponto.longitude < longWestest) {
          longWestest = ponto.longitude;
        }
      });
    });

    LatLng northeast = LatLng(latNortheast, longWestest);
    LatLng southwest = LatLng(latSouthwest, longEastest);
//    print("northeast: ${northeast}, southwest: ${southwest}");

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(northeast: northeast, southwest: southwest), 30));
  }

  _determinarCor(int cor) {
    switch (cor) {
      case 0:
        return Colors.blueAccent;
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.lightGreenAccent;
      case 3:
        return Colors.yellowAccent;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.green;
      case 6:
        return Colors.brown;
      case 7:
        return Colors.cyanAccent;
      case 8:
        return Colors.lightGreenAccent;
      default:
        return Colors.grey;
    }
  }

  String _titleInfowindow(Map<String, dynamic> parada) {
    return 'Parada ${parada['CodigoParada']} • ${parada['Denomicao']}';
  }

  Set<Marker> _desenharParadasProximas(List<DocumentSnapshot> paradas) {
    Set<Marker> _markers = Set();

    paradas.forEach((parada) {
//      _cameraTargetBounds = CameraTargetBounds(LatLngBounds(southwest: null, northeast: null))
      if (_currentLocation != null) {
        if (parada.data['Lat'] != null && parada.data['Lat'] != null) {
          double lat = double.parse(parada.data['Lat']);
          double long = double.parse(parada.data['Long']);
          double dist = getDistanceBetween(
              _currentLocation.latitude, _currentLocation.longitude, lat, long);

          if (dist <= DISTANCE_SEARCH_SOPTS) {
            _markers.add(Marker(
              markerId: MarkerId("${parada.data['CodigoParada']}"),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(
                  title: _titleInfowindow(parada.data),
                  snippet: '${parada.data['Endereco']}',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetalhesParadaScreen(
                              codigoParada: parada.data['CodigoParada'],
                            )));
                  }),
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? BitmapDescriptor.fromAsset("assets/ios/stopbus_green.png")
                  : BitmapDescriptor.fromAsset(
                      "assets/android/stopbus_green.png"),
            ));
          }
        }
      }
    });

    return _markers;
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
