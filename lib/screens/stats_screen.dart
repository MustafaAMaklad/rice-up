import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int> temp = {
    'Max Temperature': 30,
    'Min Temperature': 10,
    'Avg Temperature in the last 12 hours': 40,
  };

  Map<String, int> mois = {
    'Max Moisture': 80,
    'Min Moisture': 40,
    'Avg Moisture in the last 12 hours': 90,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.amberAccent,
        ),
        backgroundColor: primaryLightColor,
        elevation: 0.0,
        title: const Text(
          'Summary Statistics',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(left: 8.0, top: 8.0),
            //   child: Text(
            //     "Summary Statistics",
            //     style: TextStyle(color: primaryColor, fontSize: 28.0),
            //   ),
            // ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Row(
                children: [
                  Row(
                    children: const [
                      Text(
                        'Temperature',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.sunny,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 70.0,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Moisture',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.water_drop,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        final key = temp.keys.elementAt(index);
                        final value = temp.values.elementAt(index);
                        final isAvg =
                            key == 'Avg Temperature in the last 12 hours';
                        final isHigh = isAvg && (value > 25);

                        return Container(
                          width: 150,
                          height: 180,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$value°C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: isHigh ? Colors.red : Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (isAvg)
                                Text(
                                  isHigh ? 'Too high' : 'Good',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isHigh ? Colors.red : Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        final key = mois.keys.elementAt(index);
                        final value = mois.values.elementAt(index);
                        final isAvg =
                            key == 'Avg Moisture in the last 12 hours';
                        final isHigh = isAvg && (value > 80);

                        return Container(
                          width: 150,
                          height: 180,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$value%',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: isHigh ? Colors.red : Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (isAvg)
                                Text(
                                  isHigh ? 'Too high' : 'Good',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isHigh ? Colors.red : Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
