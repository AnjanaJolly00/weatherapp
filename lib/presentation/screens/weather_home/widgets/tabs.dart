import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/screens/weather_home/widgets/forecast_list.dart';

import '../provider/weather_provider.dart';

class HourlyForecastTab extends StatelessWidget {
  const HourlyForecastTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your hourly forecast content
    return Consumer<WeatherProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          provider.isListLoading
              ? Container()
              : SizedBox(
                  height: 180,
                  child: SizedBox(
                      height: 160,
                      child: ForecastList(
                        list: provider.weeklyWeather.hourly ?? [],
                      )),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    context
                        .read<WeatherProvider>()
                        .fetchWeather(context, citySearch: false);
                  },
                  icon: const Icon(
                    Icons.location_pin,
                    color: Colors.white,
                  )),
              const Spacer(),
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller:
                                    context.read<WeatherProvider>().cityName,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<WeatherProvider>()
                                        .fetchWeather(context,
                                            citySearch: true);
                                    context
                                        .read<WeatherProvider>()
                                        .fetchWeeklyWeather(context,
                                            citySearch: true);
                                  },
                                  child: const Text('Search'))
                            ],
                          ),
                        );
                      });
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      );
    });
  }
}

class WeeklyForecastTab extends StatelessWidget {
  const WeeklyForecastTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with your weekly forecast content
    return Consumer<WeatherProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          provider.isDailyListLoading
              ? Container()
              : Expanded(
                  flex: 2,
                  child: SizedBox(
                      height: 160,
                      child: ForecastList(
                        isDay: true,
                        list: provider.dailyWeather.list ?? [],
                      )),
                ),
          Expanded(flex: 1, child: ButtonBar())
        ],
      );
    });
  }
}
