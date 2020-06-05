import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';

import 'location_map.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Enter your",
                    style: TextStyles()
                        .headerTextStyle()
                        .copyWith(fontWeight: FontWeight.w200, fontSize: 24),
                  ),
                  Text(
                    "LOCATION",
                    style:
                        TextStyles().headerTextStyle().copyWith(fontSize: 24),
                  ),
                ],
              ),
              LocationMap(),
            ],
          ),
        ),
      ),
    );
  }
}
