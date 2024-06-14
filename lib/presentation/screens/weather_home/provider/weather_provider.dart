import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/core.dart';
import 'package:weatherapp/data/models/daily_weather.dart';
import 'package:weatherapp/data/models/location_weather_data.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepo _repo = WeatherRepo();
  late LocationWeatherResponse _weatherInfo;
  late WeeklyWeatherResponse _weeklyWeather;
  late DailyWeatherForecast _dailyWeather;
  bool _isLoading = true;
  bool _isListLoading = true;
  bool _isDailyListLoading = true;
  TextEditingController cityName = TextEditingController();
  LocationWeatherResponse get weatherInfo => _weatherInfo;

  WeeklyWeatherResponse get weeklyWeather => _weeklyWeather;
  DailyWeatherForecast get dailyWeather => _dailyWeather;
  bool get isLoading => _isLoading;
  bool get isListLoading => _isListLoading;
  bool get isDailyListLoading => _isDailyListLoading;
  String formattedDate = DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

  Future<void> fetchWeather(context, {bool citySearch = false}) async {
    /// final Position location = await _determinePosition();
    //
    ApiResponse response;
    if (citySearch) {
      response = await _repo.getLocationWeather(city: cityName.text);
    } else {
      response = await _repo.getLocationWeather(lat: '35', lon: '139');
    }

    if (response.code == 200) {
      if (response.isSuccessful && response.data != null) {
        if (citySearch) {
          Navigator.of(context).pop();
          cityName.clear();
        }
        _weatherInfo = LocationWeatherResponse.fromJson(response.data);
        fetchWeeklyWeather(context,
            lat: _weatherInfo.coord?.lat, lon: _weatherInfo.coord?.lon);
        fetchDailyWeather(context,
            lat: _weatherInfo.coord?.lat, lon: _weatherInfo.coord?.lon);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
      }
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
    }
  }

  Future<void> fetchWeeklyWeather(context,
      {bool citySearch = false, lat, lon}) async {
    /// final Position location = await _determinePosition();
    //
    ApiResponse response;

    response =
        await _repo.getWeeklyLocation(lat: lat ?? '35', lon: lon ?? '139');

    if (response.code == 200) {
      if (response.isSuccessful && response.data != null) {
        _weeklyWeather = WeeklyWeatherResponse.fromJson(response.data);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
      }
      _isListLoading = false;
      notifyListeners();
    } else {
      _isListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
    }
  }

  Future<void> fetchDailyWeather(context,
      {bool citySearch = false, lat, lon}) async {
    /// final Position location = await _determinePosition();
    //
    ApiResponse response;

    response =
        await _repo.getDailyLocation(lat: lat ?? '35', lon: lon ?? '139');

    if (response.code == 200) {
      if (response.isSuccessful && response.data != null) {
        _dailyWeather = DailyWeatherForecast.fromJson(response.data);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
      }
      _isListLoading = false;
      notifyListeners();
    } else {
      _isListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.errorMsg ?? "")));
    }
  }

  // Future<Position> _determinePosition() async {
  //   // Check if location services are enabled
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled return an error message
  //     return Future.error('Location services are disabled.');
  //   }

  //   // Check location permissions
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // If permissions are granted, return the current location
  //   return await Geolocator.getCurrentPosition();
  // }
}
