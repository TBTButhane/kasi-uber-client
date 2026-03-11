import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jabber/Data/appData.dart';
import 'package:jabber/Screens/searchScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:jabber/auth/help.dart';
import 'package:jabber/main.dart';
import 'package:jabber/models/address.dart';
import 'package:jabber/assistance/assistantMethods.dart';
import 'package:jabber/models/directDetails.dart';
import 'package:jabber/assistance/geofireAssistant.dart';
import 'package:jabber/models/nearbyAvailableDrivers.dart';
import 'package:jabber/widgets/divider.dart';
import 'package:jabber/widgets/drawer.dart';
import 'package:jabber/widgets/noDrivers.dart';
import 'package:jabber/widgets/progressIndicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "HomeScreen";
  String name;
  HomeScreen({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;
  Address address = Address();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  // bool mapToggle = false;
  Position currentLocation;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  BitmapDescriptor nearbyIcon;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  bool nearbyAvailableDriversKeysLoaded = false;

  double rideDetailsContainerHeight = 0;
  double requestrideContainerHeight = 0;
  double searchContainerHeight = 250.0;

  bool openDrawer = true;
  // DatabaseReference rideRequestRef;

  List<NearByAvailableDrivers> availableDrivers;

  @override
  void initState() {
    super.initState();
    AssistantMethods.getCurrentOnLineUserInfo();
  }

  void saveRideRequest() {
    print("we here");
    rideRequestRef.push();
    // rideRequestRef =
    //     FirebaseDatabase.instance.reference().child("Ride Requests").push();
    var pickUP = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
    print("we saved");
    Map pickUpLocMap = {
      "latitude": pickUP.latitude.toString(),
      "longitude": pickUP.longitude.toString(),
    };
    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map rideInfoMap = {
      "driver_id": "waiting",
      "Payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo.name,
      "rider_phone": userCurrentInfo.phone,
      "pickup_ address": pickUP.placeName,
      "dropoff_address": dropOff.placeName,
    };
    rideRequestRef.push().set(rideInfoMap);
  }

  void cancelRideRequest() {
    rideRequestRef.remove();
  }

  void displayRequestRideContainer() {
    setState(() {
      requestrideContainerHeight = 270.0;
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 250;
      openDrawer = false;
    });
    saveRideRequest();
  }

  resetApp() {
    setState(() {
      openDrawer = true;
      searchContainerHeight = 250;
      rideDetailsContainerHeight = 0;
      requestrideContainerHeight = 0;
      bottomPaddingOfMap = 0;

      pLineCoordinates.clear();
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
    });
    locatePosition();
  }

  buttonPinPoint() {
    locatePosition();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 280;
      bottomPaddingOfMap = 300;
      openDrawer = false;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentLocation = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address: $address");
    initGeofireListner();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-25.731340, 28.218370),
    //target: LatLng(),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    var locationFound = Provider.of<AppData>(
      context,
    ).pickUpLocation;
    createIconMarker();
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          leading: Container(),
          title: Text("Jabber Rider",
              style: GoogleFonts.oswald(
                  textStyle: TextStyle(fontSize: 25, color: Colors.white))),
          centerTitle: true,
          elevation: 5,
          backgroundColor: Colors.black,
        ),
        drawer: DrawerWidget(),
        body: Stack(
          children: [
            GoogleMap(
                padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                myLocationEnabled: true,
                mapType: MapType.normal,
                polylines: polylineSet,
                //myLocationButtonEnabled: true,
                markers: markersSet,
                circles: circlesSet,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;
                  setState(() {
                    bottomPaddingOfMap = 250;
                  });
                  locatePosition();
                }),

            ///Open drawer position
            Positioned(
              top: 25,
              left: 15,
              child: GestureDetector(
                onTap: () {
                  if (openDrawer) {
                    _globalKey.currentState.openDrawer();
                  } else {
                    resetApp();
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(
                    (openDrawer) ? Icons.menu : Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            //Reset Button
            Positioned(
              top: 80,
              //left: 15,
              right: 15,
              child: GestureDetector(
                // onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton(
                    child:
                        Text("Find Me", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      buttonPinPoint();
                    },
                  ),
                ),
              ),
            ),

            //Search location
            Positioned(
              bottom: 0.0,
              left: 4,
              right: 4,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceOut,
                duration: Duration(milliseconds: 500),
                child: Container(
                  height: searchContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 16,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          Text("Hi there, ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                          Text("Where to? ",
                              style: GoogleFonts.oswald(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));

                              if (res == "obtainDirection") {
                                displayRideDetailsContainer();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7))
                                  ]),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.black),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Search location")
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Icon(Icons.home, color: Colors.grey),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        Provider.of<AppData>(
                                                  context,
                                                ).pickUpLocation !=
                                                null
                                            ? Provider.of<AppData>(
                                                context,
                                              ).pickUpLocation.placeName
                                            : "My Location",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white))),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text("User current Location",
                                        style:
                                            TextStyle(color: Colors.grey[300]))
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          DividerWidget(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(Icons.work, color: Colors.grey),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Add Work",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white))),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text("Work address ",
                                      style: TextStyle(color: Colors.grey[300]))
                                ],
                              )
                            ],
                          )
                        ]),
                  ),
                ),
              ),
            ),

            //Send Request
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceIn,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    height: rideDetailsContainerHeight,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 16,
                              spreadRadius: .5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 16,
                                  spreadRadius: .5,
                                  offset: Offset(0.7, 0.7))
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset("assets/car_android.png",
                                    height: 70, width: 80),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Distance",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black))),
                                    Text(
                                        (tripDirectionDetails != null)
                                            ? tripDirectionDetails.distanceText
                                            : "",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black))),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Fare",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black))),
                                    Text(
                                        (tripDirectionDetails != null)
                                            ? "\R ${AssistantMethods.calculateFare(tripDirectionDetails)}.00"
                                            : " ",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(Icons.money,
                                    size: 18, color: Colors.white),
                                SizedBox(
                                  width: 16,
                                ),
                                Text("Payment Method:",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white))),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 16, color: Colors.white),
                              ],
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              displayRequestRideContainer();
                              availableDrivers =
                                  GeofireAssistant.nearbyAvailableDriversList;
                              searchNearestDriver();
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            child: Padding(
                                padding: EdgeInsets.all(17),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Request a ride",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black))),
                                    SizedBox(width: 10),
                                    Icon(Icons.directions_car,
                                        color: Colors.black, size: 26)
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            //Request container
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: Duration(milliseconds: 500),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0.5,
                              blurRadius: 16.0,
                              color: Colors.black54,
                              offset: Offset(0.7, 0.7))
                        ]),
                    height: requestrideContainerHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Container(
                                height: 50,
                                child: FadeAnimatedTextKit(
                                  repeatForever: true,
                                  isRepeatingAnimation: true,
                                  duration: Duration(milliseconds: 1000),
                                  text: [
                                    "Searching..",
                                    "finding driver..",
                                    "Please wait...!"
                                  ],
                                  textStyle: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Ride request details:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text("Payment via Cash: "),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                        (tripDirectionDetails != null)
                                            ? "\R ${AssistantMethods.calculateFare(tripDirectionDetails)}.00"
                                            : " ",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white))),
                                  ],
                                ),
                                Text(
                                  "Rider Name: Tshegofatso",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  Provider.of<AppData>(context, listen: false)
                                              .pickUpLocation !=
                                          null
                                      ? "Pickup location: " +
                                          Provider.of<AppData>(context,
                                                  listen: false)
                                              .pickUpLocation
                                              .placeName
                                      : "Pick up Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  Provider.of<AppData>(context, listen: false)
                                              .dropOffLocation !=
                                          null
                                      ? "Dropoff location: " +
                                          Provider.of<AppData>(context,
                                                  listen: false)
                                              .dropOffLocation
                                              .placeName
                                      : "Drop off location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                          SizedBox(height: 15),
                          OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.white,
                                  elevation: 2,
                                  backgroundColor: Colors.black,
                                  shadowColor: Colors.black),
                              onPressed: () {
                                print("Cancel ride request");
                                cancelRideRequest();
                                resetApp();
                              },
                              icon: Icon(Icons.cancel, color: Colors.white),
                              label: Text("Cancel ride request"))
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ));
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;

    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressIndi(
              message: "Please wait...",
            ));

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    print("This is Encoded Points :");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "Drop off Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.yellow,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId("pickUpId"));
    Circle dropOffLocCircle = Circle(
        fillColor: Colors.blue,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("dropOffId"));

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  void initGeofireListner() {
    Geofire.initialize("availableDrivers");
    //Correction
    Geofire.queryAtLocation(
            currentLocation.latitude, currentLocation.longitude, 15)
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers();
            nearByAvailableDrivers.key = map['key'];
            nearByAvailableDrivers.lat = map['latitude'];
            nearByAvailableDrivers.lng = map['longitude'];
            GeofireAssistant.nearbyAvailableDriversList
                .add(nearByAvailableDrivers);
            if (nearbyAvailableDriversKeysLoaded == true) {
              updateAvailableDriverOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeofireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onKeyMoved:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers();
            nearByAvailableDrivers.key = map['key'];
            nearByAvailableDrivers.lat = map['latitude'];
            nearByAvailableDrivers.lng = map['longitude'];
            GeofireAssistant.updateDriverNearbyLocation(nearByAvailableDrivers);
            updateAvailableDriverOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriverOnMap();
            break;
        }
      }

      setState(() {});
    });
    //Correction
  }

  void updateAvailableDriverOnMap() {
    setState(() {
      markersSet.clear();
    });
    Set<Marker> tMakers = Set<Marker>();
    for (NearByAvailableDrivers driver
        in GeofireAssistant.nearbyAvailableDriversList) {
      LatLng driverAvailablePosition = LatLng(driver.lat, driver.lng);

      Marker marker = Marker(
        markerId: MarkerId('drivers${driver.key}'),
        position: driverAvailablePosition,
        icon: nearbyIcon,
        rotation: AssistantMethods.createRandomNumber(360),
      );
      tMakers.add(marker);
    }
    setState(() {
      markersSet = tMakers;
    });
  }

  void createIconMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfig =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfig, "assets/car_ios2.png")
          .then((value) {
        nearbyIcon = value;
      });
    }
  }

  void noDriversFound() {
    showDialog(context: context, builder: (context) => NoDriversDialog());
  }

  void searchNearestDriver() {
    if (availableDrivers.length == 0) {
      availableDrivers = [];

      resetApp();
      cancelRideRequest();
      noDriversFound();

      return;
    }
    var driver = availableDrivers[0];
    notifyDriver(driver);
    availableDrivers.removeAt(0);
  }

  void notifyDriver(NearByAvailableDrivers driver) {
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);
    driversRef
        .child(driver.key)
        .child("token")
        .once()
        .then((DatabaseEvent dataEvent) {
      if (dataEvent.snapshot.value != null) {
        String token = dataEvent.snapshot.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, context, rideRequestRef.key);
      }
    });
  }
}
