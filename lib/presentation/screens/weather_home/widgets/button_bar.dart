import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/screens/weather_home/provider/weather_provider.dart';

class ButtonBar extends StatelessWidget {
  const ButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                          controller: context.read<WeatherProvider>().cityName,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<WeatherProvider>()
                                  .fetchWeather(context, citySearch: true);
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
    );
  }
}
