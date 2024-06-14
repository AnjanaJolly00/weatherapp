import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/core.dart';

import 'widgets/tabs.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WeatherProvider>().fetchWeather(context);
    context.read<WeatherProvider>().fetchWeeklyWeather(context);
    context.read<WeatherProvider>().fetchDailyWeather(context);
    return Scaffold(
        bottomSheet: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
                image: const DecorationImage(
                    image: AssetImage('assets/tab_bg.png'),
                    fit: BoxFit.fitWidth)),
            child: DefaultTabController(
              length: 2,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                TabBar(
                  unselectedLabelStyle: TextWidget.customTextStyle(
                      color: Colors.white.withOpacity(.5)),
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextWidget.customTextStyle(color: Colors.white),
                  tabs: const [
                    Tab(
                      text: "Hourly Forecast",
                    ),
                    Tab(text: "Weekly Forecast"),
                  ],
                ),
                const SizedBox(
                  height: 250,
                  child: TabBarView(
                    children: [
                      HourlyForecastTab(),
                      WeeklyForecastTab(),
                    ],
                  ),
                )
              ]),
            )),
        body: Consumer<WeatherProvider>(builder: (context, provider, _) {
          return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/stars.png',
                    ),
                    fit: BoxFit.fitHeight),
              ),
              padding: const EdgeInsets.all(20),
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: .5,
                    ))
                  : Container(
                      padding: const EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget.manropeMediumText(
                                text: provider.weatherInfo.name ?? "",
                                color: Colors.white,
                                fontSize: 22),
                            TextWidget.manropeRegularText(
                                text:
                                    "${fahrenheitToCelsius(provider.weatherInfo.main?.temp)}°C",
                                fontSize: 100,
                                color: Colors.white),
                            TextWidget.manropeSemiBoldText(
                                text: (provider.weatherInfo.weather?.first
                                            .description ??
                                        "")
                                    .toCamelCase(),
                                fontSize: 20,
                                color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget.manropeSemiBoldText(
                                      text:
                                          'H:${fahrenheitToCelsius(provider.weatherInfo.main?.tempMax)}°',
                                      color: Colors.white,
                                      fontSize: 20),
                                  const SizedBox(width: 20),
                                  TextWidget.manropeSemiBoldText(
                                      text:
                                          'L:${fahrenheitToCelsius(provider.weatherInfo.main?.tempMin) ?? ""}°',
                                      color: Colors.white,
                                      fontSize: 20)
                                ],
                              ),
                            ),
                          ])));
        }));
  }
}
