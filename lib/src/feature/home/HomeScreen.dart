import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';

import '../authentication/presentation/AuthBloc.dart';
import '../authentication/presentation/AuthEvent.dart';
import '../authentication/presentation/AuthState.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String locationText = "Fetching location...";
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();

    _locationTimer = Timer.periodic(Duration(minutes: 10), (timer){
      _getLocationUpdates();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _getLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationText = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationText = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationText = "Location permissions are permanently denied.";
      });
      return;
    }


    //current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert to human readable address
    _getAddressFromCoordinates(position.latitude, position.longitude);


    /* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update if user moves 100 meters
      ),
    ).listen((Position position) {
      _getAddressFromCoordinates(position.latitude, position.longitude);
    });*/

  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          locationText = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        locationText = "Error fetching location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Loginscreen()),
                  (route) => false,
            );
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome, ${state.displayName ?? "User"}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Email: ${state.email ?? "Not available"}",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 20),
                    Text("Location: $locationText",
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                    SizedBox(height: 20),
                   /* ElevatedButton(
                      onPressed: _getLocationUpdates,
                      child: Text("Update Location"),
                    ),
                    SizedBox(height: 20),*/
                    ElevatedButton(onPressed: (){
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                        child: Text("Logout"))
                  ],
                );
              } else if (state is AuthLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthError) {
                return Text("Error: ${state.message}");
              }
              return Text("Not authenticated");
            },
          ),
        ),
      ),
    );
  }
}