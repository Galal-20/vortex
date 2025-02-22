import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:vortex/src/core/constants/strings.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherBloc.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherEvent.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherState.dart';
import 'package:vortex/src/feature/home/presentation/screen/location-widget.dart';
import 'package:vortex/src/feature/home/presentation/screen/daily_weather_card_widget.dart';
import 'package:vortex/src/feature/welcome_screen/presentation/screen/welcome_screen.dart';

import '../../../../core/constants/image_strings.dart';
import '../../../authentication/presentation/AuthBloc/AuthBloc.dart';
import '../../../authentication/presentation/AuthBloc/AuthEvent.dart';
import '../../../authentication/presentation/AuthBloc/AuthState.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String locationText = tFetch;
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
        locationText = tErrorSer;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationText = tLPD;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationText = tLPPD;
      });
      return;
    }


    //current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert to human readable address
    _getAddressFromCoordinates(position.latitude, position.longitude);

    context.read<WeatherBloc>().add(FetchWeather(position.latitude, position.longitude));

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
        locationText = tErrorF;
      });
    }
  }

  String _getBackgroundImage(String description) {
    switch (description) {
      case overcast_clouds:
      case broken_clouds:
      case scattered_clouds:
      case few_clouds:
      case mist:
      case "fog":
      case "Foggy":
      case "Overcast":
      case "Partly Clouds":
        return cloudImage;
      case clear:
      case sunny:
      case clear_sky:
      case "Clear Sky":
        return sunnyImage;
      case heavy_rain:
      case rain:
      case showers:
      case moderate_rain:
      case light_rain:
        return rainImage;
      case heavy_snow:
      case shower_snow:
      case shower_sleet:
      case light_snow:
      case "Snow":
        return snowImage;
      default:
        return sunnyImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial || state is Unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
            body:
            Container(
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                ),
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
                                                style: TextStyle(fontSize: 14, color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30,),
                                      // Daily forecast weather for 7 days:
                                      SizedBox(
                                        height: 200, // Adjust height as needed
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: weatherState.weather.dailyForecast.length -1,
                                          itemBuilder: (context, index) {
                                            final daily = weatherState
                                                .weather.dailyForecast[index +1];
                                            return DailyWeatherCard(
                                              day: DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(daily.date * 1000)),
                                              weatherDescription: daily.description,
                                              maxTemp: daily.maxTemp.toString(),
                                              minTemp: daily.minTemp.toString(),
                                              iconUrl: "https://openweathermap.org/img/wn/${daily.icon}@2x.png",
                                            );
                                          },
                                        ),
                                      ),
                                      // Current weather data footer:
                                      SizedBox(height: 50),
                                      Container(
                                        margin: EdgeInsets.symmetric
                                          (horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.black,width: 2),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(padding: EdgeInsets.symmetric
                                              (vertical: 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (ws),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("Wind Speed:\n${weatherState.weather.windSpeed} m/s",
                                                          style: TextStyle
                                                            (fontSize: 16,
                                                              fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (humidity),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("Humidity:\n${weatherState.weather.windSpeed}%",
                                                          style: TextStyle
                                                            (fontSize: 16,fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (co),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("Clouds:\n${weatherState.weather.windSpeed}%",
                                                          style: TextStyle
                                                            (fontSize: 16, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.symmetric
                                              (vertical: 20),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (sea),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("Sea:\n${weatherState.weather.windSpeed}hPa",
                                                          style: TextStyle
                                                            (fontSize: 16, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (sunrise),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                          "Sunrise:\n${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherState.weather.sunrise * 1000))}",
                                                          style: TextStyle
                                                            (fontSize: 16, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Image(
                                                        image: AssetImage
                                                          (sunset),
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("Sunset:\n${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(weatherState.weather.sunset * 1000))}",
                                                          style: TextStyle
                                                            (fontSize: 16, fontWeight: FontWeight.bold))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ) ,
                                      ),
                                    ],
                                  );
                                } else if (weatherState is WeatherError) {
                                  return Center(child: Text(fLoad + weatherState.message));
                                }
                                return Text(fDw);
                              },
                            ),
                          ],
                        );
                      }
                      else if (state is AuthLoading) {
                        return CircularProgressIndicator();
                      } else if (state is AuthError) {
                        return Text("Error: ${state.message}");
                      }else if(state is Unauthenticated){
                        return Text(not_authenticated);
                      }
                      return Text(not_authenticated);
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





