import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherBloc.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherEvent.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherState.dart';
import 'package:vortex/src/feature/home/presentation/location-widget.dart';

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
  Timer? _clockTimer;
  var nameDay= DateFormat('EEEE').format(DateTime.now());
  var time = DateFormat('h:mm a').format(DateTime.now());
  var dateTime = DateFormat('d MMM, yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();

    _locationTimer = Timer.periodic(Duration(minutes: 10), (timer){
      _getLocationUpdates();
    });

    // Update time every second
    _clockTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        nameDay = DateFormat('EEEE').format(DateTime.now());
        time = DateFormat('h:mm a').format(DateTime.now());
        dateTime = DateFormat('d MMM, yyyy').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _clockTimer?.cancel();
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

    context.read<WeatherBloc>().add(FetchWeather(position.latitude, position.longitude));

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

  // Function to determine background image based on weather description
  String _getBackgroundImage(String description) {
    switch (description) {
      case "overcast clouds":
      case "broken clouds":
      case "scattered clouds":
      case "few clouds":
      case "mist":
        return "assets/images/cloud.jpg";
      case "Clear":
      case "Sunny":
      case "clear sky":
        return "assets/images/sunny.jpg";
      case "Heavy Rain":
      case "Rain":
      case "Showers":
      case "Drizzle":
      case "moderate rain":
      case "light rain":
        return "assets/images/rain.jpg";
      case "heavy snow":
      case "shower snow":
      case "shower sleet":
      case "light shower sleet":
      case "light snow":
        return "assets/images/snow.jpg";
      default:
        return "assets/images/sunny.jpg";
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
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, weatherState){
          String backgroundImage = "";
          if(weatherState is WeatherLoaded){
            backgroundImage = _getBackgroundImage(weatherState.weather.description);
          }
          return Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 60,),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Location
                            LocationWidget(locationText: locationText),
                            SizedBox(height: 20,),
                            //Name and signOut
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 5,),
                                //text hello + name:
                                Text(
                                  "Hello,\n${state.displayName ?? "User"}",
                                  style: TextStyle(fontSize: 16, fontWeight:
                                  FontWeight.bold),
                                ),
                                SizedBox(width: 190),
                                IconButton(
                                    onPressed: (){
                                      context.read<AuthBloc>().add(LogoutRequested());
                                    },
                                    icon: Icon(
                                      Icons.exit_to_app_rounded,
                                      size: 30,
                                      color: Colors.red,
                                    )
                                ),
                              ],
                            ),
                            //Current weather data

                            SizedBox(height: 20,),
                            BlocBuilder<WeatherBloc, WeatherState>(
                              builder: (context, weatherState) {
                                if (weatherState is WeatherLoading) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (weatherState is WeatherLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.network(
                                            "https://openweathermap.org/img/wn/${weatherState.weather.icon}@2x.png",
                                            width: 80,
                                            height: 80,
                                            errorBuilder: (context, error, stackTrace) => Icon(Icons.cloud, size: 80),
                                          ),
                                          Column(
                                            children: [
                                              Text(nameDay, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              Text(dateTime, style: TextStyle(fontSize: 14)),
                                              Text(time, style: TextStyle(fontSize: 14)),
                                            ],
                                          ),

                                          Column(
                                            children: [
                                              Text(weatherState.weather.description, style: TextStyle(fontSize: 16)),
                                              Text("${weatherState.weather.temperature} °C", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              Text("${weatherState.weather.minTemperature} °C / ${weatherState.weather.maxTemperature} °C",
                                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Wind Speed: ${weatherState.weather.windSpeed} m/s", style: TextStyle(fontSize: 16)),
                                            Text("Humidity: ${weatherState.weather.humidity}%", style: TextStyle(fontSize: 16)),
                                            Text("Clouds: ${weatherState.weather.clouds}%", style: TextStyle(fontSize: 16)),
                                            Text("Sea Level: ${weatherState.weather.seaLevel} hPa", style: TextStyle(fontSize: 16)),
                                            Text("Sunrise: ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherState.weather.sunrise * 1000))}", style: TextStyle(fontSize: 16)),
                                            Text("Sunset: ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherState.weather.sunset * 1000))}", style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );

                                } else if (weatherState is WeatherError) {
                                  return Center(child: Text("Failed to load weather data: ${weatherState.message}"));
                                }
                                return Text("Fetching weather data...");
                              },
                            ),

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
                ],

              ),
            ),
          );
        },
      ),
    );
  }
}






