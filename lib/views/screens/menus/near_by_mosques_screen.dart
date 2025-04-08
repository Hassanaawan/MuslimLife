import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../../../constants/images_constants.dart';

class NearbyMosquesScreen extends StatefulWidget {
  const NearbyMosquesScreen({super.key});

  @override
  State<NearbyMosquesScreen> createState() => _NearbyMosquesScreenState();
}

class _NearbyMosquesScreenState extends State<NearbyMosquesScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogleplex = CameraPosition(
      target: LatLng(21.4241, 39.8173),
      zoom: 12
  );

  List<Marker> _marker = [];
  final Dio dio = Dio();

  Uint8List? markerImage;

  Future<Uint8List> getBytesFromAssets(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  final String? mapApiKey = dotenv.env['map_Api_Key'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_marker.addAll(_list);
    //location();

    //Getting user current location
    getUserCurrentLocation().then((value) async {
      print("My current location");
      print(value.latitude.toString());
      print(value.longitude.toString());

      //Add marker in my current location
      _marker.add(
          Marker(
              markerId: const MarkerId('3'),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                  title: "My current location"
              )
          )
      );

      //Animating to my current location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 12,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      getMosque(value.latitude.toString(), value.longitude.toString());

      setState(() {

      });

    });
  }


  ///Get user current location
  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }


  Future<void> getMosque(String lat, String lon) async {
    // Construct the request URL
    String s =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" +
            lat +
            "," +
            lon +
            "&radius=5000&types=mosque&name=mosque" +
            "&key=$mapApiKey";

    try {
      // Perform GET request using Dio
      var response = await dio.get(s);

      print('----------------');
      await printFullResponse(response);
      print('----------------');
      await updateMapMarkers(response);
    } catch (e) {
      print('Error fetching mosque data: $e');
    }
  }

  Future<void> updateMapMarkers(Response response) async {
    // Decode the response body
    final decodedResponse = json.decode(response.data);

    if (decodedResponse.containsKey('results')) {
      List<dynamic> results = decodedResponse['results'];

      final Uint8List markerIcon = await getBytesFromAssets(AppImages.mosqueLocationPNG, 100);

      setState(() {
        // Clear previous markers if needed
        //_marker.clear();

        // Add new markers
        for (var result in results) {
          var location = result['geometry']['location'];
          var lat = location['lat'];
          var lon = location['lng'];
          _marker.add(
            Marker(
              markerId: MarkerId(result['place_id']),
              position: LatLng(lat, lon),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              infoWindow: InfoWindow(title: result['name']),
            ),
          );
        }
      });
    }
  }

  Future<void> printFullResponse(Response response) async {
    // Set the maximum chunk size for printing
    final int maxChunkSize = 1024;

    // Print the response body in chunks
    for (var i = 0; i < response.data.length; i += maxChunkSize) {
      print(response.data.substring(i, i + maxChunkSize));
    }

    // Animate the camera to a default position (optional)
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(23.8041, 90.4152),
          zoom: 12,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGoogleplex,
        mapType: MapType.normal,
        myLocationEnabled: true,
        compassEnabled: true,
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),

    );
  }
}
