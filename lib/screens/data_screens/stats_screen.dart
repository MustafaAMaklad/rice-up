import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, int> temperatureStats = {
    'Max Temperature in The Last 24 Hours': 0,
    'Min Temperature in The Last 24 Hours': 0,
    'Average Temperature in The Last 24 Hours': 0,
  };

  Map<String, int> moistureStats = {
    'Max Moisture in The Last 24 Hours': 0,
    'Min Moisture in The Last 24 Hours': 0,
    'Average Moisture in The Last 24 Hours': 0,
  };
  String? deviceId;
  @override
  void initState() {
    super.initState();

    // Get Statistics data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      deviceId = ModalRoute.of(context)?.settings.arguments.toString();
      init(showSnackBarMessage);
    });
    debugPrint('device ID: $deviceId');

    // Retrieve the deviceId argument from the ModalRoute
  }

  // Fetch data when screen opens
  Future<void> init(void Function(String) showMessage) async {
    // Query Statistics data
    List<Map<String, int>> stats = await queryStatistics(context);

    // Updata the state of Intialized variables
    if (stats.isEmpty) {
      showMessage(
          'No internet connection. Try connecting to the internet again to be able to view data.');
    } else {
      setState(() {
        temperatureStats = stats[0];
        moistureStats = stats[1];
      });
    }
  }

// display error message when there is no internet connection
  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  String getBefore24HTime() {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Subtract 24 hours from the current time
    DateTime timeBefore24Hours =
        currentTime.subtract(const Duration(hours: 1 * 24));

    // Format the time in the desired format
    String formattedTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(timeBefore24Hours.toUtc());

    // safePrint(formattedTime);
    return formattedTime.toString();
  }

  Future<List<Map<String, int>>> queryStatistics(BuildContext context) async {
    String time = getBefore24HTime();
    debugPrint('hereee e:$deviceId');
    String document = """
           query MyQuery {
              searchReadings(aggregates: [
                {field: temperature, name: "Average Temperature in The Last 24 Hours", type: avg},
                {field: moisture, name: "Average Moisture in The Last 24 Hours", type: avg},
                {field: temperature, name: "Min Temperature in The Last 24 Hours", type: min},
                {field: temperature, name: "Max Temperature in The Last 24 Hours", type: max},
                {field: moisture, name: "Min Moisture in The Last 24 Hours", type: min},
                {field: moisture, name: "Max Moisture in The Last 24 Hours", type: max}
                ],
                filter: {createdAt: {gte: "$time"}, device_id : {eq: "$deviceId"}, temperature : {gt:0}, moisture : {lt:100, gt:0}}) {
                aggregateItems {
                  name
                  result {
                    ... on SearchableAggregateScalarResult {
                      value
                    }
                  }
                }
                
              }
            }""";
    debugPrint('Doc: $document');

    try {
      final request = GraphQLRequest(document: document);
      final response = await Amplify.API.query(request: request).response;
      Map<String, dynamic> parsedResponse = jsonDecode(response.data);

      Map<String, dynamic> searchReadings = parsedResponse['searchReadings'];
      // int total = searchReadings['total'];
      List<dynamic> aggregateItems = searchReadings['aggregateItems'];
      if (aggregateItems[0]['result'] == null) {
        showSnackBarMessage('No Available Data');
        return [];
      }
      debugPrint(aggregateItems.toString());
      // Accessing individual items in the aggregateItems list
      for (var item in aggregateItems) {
        String name = item['name'];

        double value = item['result']['value'];
        if (name.contains('Temp')) {
          temperatureStats[name] = value.toInt();
        } else {
          moistureStats[name] = value.toInt();
        }
      }
      return [temperatureStats, moistureStats];
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return [];
    }
  }

  Future<void> _refreshData() async {
    await init(showSnackBarMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: Colors.amberAccent,
        ),
        backgroundColor: primaryLightColor,
        elevation: mainElevation,
        title: const Text(
          'Summary Statistics',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Row(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Temperature',
                          style: TextStyle(fontSize: 25),
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
                    const SizedBox(
                      width: 50.0,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Moisture',
                          style: TextStyle(fontSize: 25),
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
                          final key = temperatureStats.keys.elementAt(index);
                          final value =
                              temperatureStats.values.elementAt(index);
                          final isAvg =
                              key == 'Average Temperature in The Last 24 Hours';
                          final isVeryHigh = (value > 35);
                          final isHigh = (value > 30 && value <= 35);
                          final isNormal = (value >= 20 && value <= 30);
                          final isLow = (value >= 10 && value < 20);
                          final isVeryLow = (value < 10);

                          return Container(
                            width: 150,
                            height: 180,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[100],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    key,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    '$value°C',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: isAvg
                                          ? (isVeryHigh
                                              ? const Color.fromARGB(
                                                  255, 255, 17, 0)
                                              : (isHigh
                                                  ? const Color.fromARGB(
                                                      255, 255, 94, 0)
                                                  : (isNormal
                                                      ? Colors.green
                                                      : (isLow
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 255, 94, 0)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              255, 17, 0)))))
                                          : Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isAvg
                                        ? (isVeryHigh
                                            ? 'Very High Avg Temperature'
                                            : (isHigh
                                                ? 'High Avg Temperature'
                                                : (isNormal
                                                    ? 'Normal Avg Temperature'
                                                    : (isLow
                                                        ? 'Low Avg Temperature'
                                                        : 'Very Low Avg Temperature'))))
                                        : '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isVeryHigh
                                          ? const Color.fromARGB(
                                              255, 255, 17, 0)
                                          : isHigh
                                              ? const Color.fromARGB(
                                                  255, 255, 94, 0)
                                              : isNormal
                                                  ? Colors.green
                                                  : isLow
                                                      ? const Color.fromARGB(
                                                          255, 255, 94, 0)
                                                      : const Color.fromARGB(
                                                          255, 255, 17, 0),
                                    ),
                                  ),
                                ],
                              ),
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
                          final key = moistureStats.keys.elementAt(index);
                          final value = moistureStats.values.elementAt(index);
                          final isAvg =
                              key == 'Average Moisture in The Last 24 Hours';
                          final isVeryHigh = (value > 90);
                          final isHigh = (value > 70 && value <= 90);
                          final isNormal = (value >= 40 && value <= 70);
                          final isLow = (value >= 20 && value < 40);
                          final isVeryLow = (value < 20);

                          return Container(
                            width: 150,
                            height: 180,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[100],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    key,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    '$value %',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: isAvg
                                          ? (isVeryHigh
                                              ? const Color.fromARGB(
                                                  255, 255, 17, 0)
                                              : (isHigh
                                                  ? const Color.fromARGB(
                                                      255, 255, 94, 0)
                                                  : (isNormal
                                                      ? Colors.green
                                                      : (isLow
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 255, 94, 0)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              255, 17, 0)))))
                                          : Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isAvg
                                        ? (isVeryHigh
                                            ? 'Very High Avg Moisture'
                                            : (isHigh
                                                ? 'High Avg Moisture'
                                                : (isNormal
                                                    ? 'Normal Avg Moisture'
                                                    : (isLow
                                                        ? 'Low Avg Moisture'
                                                        : 'Very Low Avg Moisture'))))
                                        : '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isVeryHigh
                                          ? const Color.fromARGB(
                                              255, 255, 17, 0)
                                          : isHigh
                                              ? const Color.fromARGB(
                                                  255, 255, 94, 0)
                                              : isNormal
                                                  ? Colors.green
                                                  : isLow
                                                      ? const Color.fromARGB(
                                                          255, 255, 94, 0)
                                                      : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton.icon(
                  onPressed: () {
                    goToTemperatureSuggestions();
                  },
                  label: const Text(
                    'Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,

                    // onPrimary: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToTemperatureSuggestions() {
    Navigator.pushNamed(context, '/temperature_suggestions_route');
  }
}
