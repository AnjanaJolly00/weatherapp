import 'package:flutter/material.dart';
import 'package:weatherapp/core.dart';

class ForecastList extends StatelessWidget {
  final List list;
  final bool isDay;
  const ForecastList({super.key, required this.list, this.isDay = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding:
            const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 20),
        itemCount: list.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) {
          var item = list[i];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 4, right: 4),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.transparent,
                border: Border.all(color: Colors.white.withOpacity(.5))),
            child: Column(
              children: [
                TextWidget.manropeRegularText(
                    text: getTimeFromUnixTimestamp(item?.dt ?? 0, isDay: isDay),
                    color: Colors.white,
                    fontSize: 14),
                Image.network(
                    'https://openweathermap.org/img/wn/${item?.weather?.first.icon}@4x.png'),
                TextWidget.manropeRegularText(
                    text: '${fahrenheitToCelsius(item?.temp ?? 0)}°',
                    color: Colors.white,
                    fontSize: 14),
              ],
            ),
          );
        });
  }
}
