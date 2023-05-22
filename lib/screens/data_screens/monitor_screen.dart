import 'package:flutter/material.dart'; //  flutter essentials
import 'package:rice_up/screens/data_screens/no_devices.dart';
import 'package:rice_up/widgets/palatte.dart'; // custom widget
import 'package:syncfusion_flutter_charts/charts.dart'; // charts and visualization

import 'package:connectivity_plus/connectivity_plus.dart'; // for connectivity check
import 'dart:async'; // for stream subscription
import "package:amplify_flutter/amplify_flutter.dart"; // for amplify backend
import '../../models/Reading.dart'; // for GraphQL models
import 'package:amplify_api/amplify_api.dart'; // for appsync graphql api

import "dart:convert"; // for response data parsing
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  _MonitorScreenState createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  // Charts data
  List<LiveData> temperatureChartData = [];
  List<LiveData> moistureChartData = [];
  late ChartSeriesController _chartSeriesControllerTemp;
  late ChartSeriesController _chartSeriesControllerMois;

  int time = 23; // Start X-axis (time) for new subscription at 19
  int limit = 24; // limit of first query
  String deviceId = '';
  String deviceName = '';

  // Intialize data structrues for items to be displayed
  List<int> lastTemperature = [];
  List<int> lastMoisture = [];
  List<Reading> readings = [];

  // defining Subscribtion variable
  StreamSubscription<GraphQLResponse<Reading>>? subscription;

  String userId = '';
  int _deviceCount = 0;
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
    unsubscribe(); // Close API subscription
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection(showSnackBarMessage);

    // Checks internet connection to establish subscription and query data
    // checkInternetConnection(showSnackBarMessage);
  }

  void checkInternetConnectionToSubscribe(
      void Function(String) showMessage) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showMessage(
          'No internet connection. Try connecting to the internet again to be able to view data.');
    } else {
      subscribe(); // Establish API subscription
      init(); // Get last Items recorded previously
    }
  }

  void checkInternetConnection(void Function(String) showMessage) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showMessage(
          'No internet connection. Try connecting to the internet again to be able to view data.');
    } else {
      getDeviceCount().then((Map<String, String> data) {
        final Data = data;
        debugPrint('Dataaaaaaaaaaaaa: $Data');
        _deviceCount = int.parse(Data['devicesCount'] ?? '0');

        debugPrint('devicecountttttttt:$_deviceCount');
        if (_deviceCount != 0) {
          deviceId = Data['deviceId'] ?? '';
          debugPrint('deviceIDDDD: $deviceId');
          deviceName = Data['deviceName'] ?? '';
          checkInternetConnectionToSubscribe(showSnackBarMessage);
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  Future<void> init() async {
    // Get last Items recorded previously
    List<List<int>> lastItems = await queryListItems();
    if (!lastItems.isEmpty) {
      lastTemperature = lastItems[0];
      lastMoisture = lastItems[1];
      setState(() {
        temperatureChartData = getTempChartData(
            lastTemperature); // Get last previous 10 temperature data
        moistureChartData = getMoisChartData(lastMoisture);
      });
    }
  }

  Future<Map<String, String>> getDeviceCount() async {
    final user = await Amplify.Auth.getCurrentUser();
    setState(() {
      userId = user.userId;
    });
    const apiKey = 'aWzzjgesucaB0UYwycJwo6BiAMcynYSr9Kj7JqxS';
    final url =
        'https://pb3crrjdhc.execute-api.us-east-1.amazonaws.com/dev/devices?user_id=$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final devicesCount = jsonResponse['number of devices'];
      if (devicesCount > 0) {
        final deviceId = jsonResponse['devices_id'][0];
        final deviceName = jsonResponse['devices names'][0];
        return {
          'deviceId': deviceId,
          'devicesCount': devicesCount.toString(),
          'deviceName': deviceName
        };
      }
      print('Number of books about HTTP: $devicesCount.');
      debugPrint(jsonResponse.toString());
      setState(() {
        _deviceCount = devicesCount;
      });
      return {'devicesCount': devicesCount.toString()};
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return {'devicesCount': ''};
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

  // GraphQl API subscription
  void subscribe() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Reading.classType);
    final Stream<GraphQLResponse<Reading>> operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    );
    subscription = operation.listen(
      (event) {
        setState(() {
          if (event.data!.device_id == deviceId) {
            readings.add(event.data!);
            int temperature = event.data!.temperature!.toInt();
            int moisture = event.data!.moisture!.toInt();
            updateData(temperature, moisture);
          }
        });

        safePrint('Subscription event data received: ${event.data}');
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  // Unsubscribe GraphQl subscription
  void unsubscribe() {
    subscription?.cancel();
    subscription = null;
  }

  void updateData(int temperature, int moisture) {
    if (temperatureChartData.length >= limit - 1) {
      temperatureChartData.removeAt(0);
    }
    if (moistureChartData.length >= limit - 1) {
      moistureChartData.removeAt(0);
    }
    time++;
    temperatureChartData.add(LiveData(time, temperature));
    moistureChartData.add(LiveData(time, moisture));
    // Update the chart data source
    _chartSeriesControllerTemp.updateDataSource(
        addedDataIndex: temperatureChartData.length - 1, removedDataIndex: 0);
    _chartSeriesControllerMois.updateDataSource(
        addedDataIndex: moistureChartData.length - 1, removedDataIndex: 0);
  }

  // Query last limit items to plot for the user
  // when user opens the chart
  Future<List<List<int>>> queryListItems() async {
    String document = '''
        query MyQuery {
          listReadings(device_id: "$deviceId",
           limit: $limit, sortDirection: DESC) {
            items {
              moisture
              temperature
            }
          }
        }''';

    try {
      final request = GraphQLRequest(document: document);
      final response = await Amplify.API.query(request: request).response;

      dynamic data = json.decode(response.data)["listReadings"]["items"];

      List<int> temp = [];
      List<int> mois = [];
      List<Map> values = List.from(data);
      if (values.length >= 24) {
        for (int i = 0; i < limit; i++) {
          temp.add(data[i]['temperature'].toInt());
          mois.add(data[i]['moisture'].toInt());
          safePrint("temp:  $temp");
          safePrint("mois:  $mois");
          safePrint((temp).runtimeType);
        }
        return [temp, mois];
      } else {
        return [];
      }
      if (data == null) {
        safePrint('errors: ${response.errors}');
      }
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return [];
    }
  }

  List<LiveData> getTempChartData(List<int> lastTemperature) {
    List<LiveData> tempChartData = [];
    for (int i = limit - 1; i >= 0; i--) {
      tempChartData
          .add(LiveData(lastTemperature.length - i - 1, lastTemperature[i]));
      safePrint("tempChartData: $tempChartData");
    }
    return tempChartData;
  }

  List<LiveData> getMoisChartData(List<int> lastMoisture) {
    List<LiveData> moisChartData = [];
    for (int i = limit - 1; i >= 0; i--) {
      moisChartData.add(LiveData(lastMoisture.length - i - 1, lastMoisture[i]));
      safePrint("tempChartData: $moisChartData");
    }
    return moisChartData;
  }

  // Go to summary stats screen when tab on the chart
  void chartOnPressed() {
    Navigator.pushNamed(context, '/stats_route', arguments: deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: secondaryColor,
        ),
        backgroundColor: primaryLightColor,
        elevation: mainElevation,
        title: const Text(
          'Monitor',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isLoading
                    ? // Show loading icon while fetching device count
                    const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : (_deviceCount == 0)
                        ? // No devices message
                        const NoDevices()
                        : Column(
                            children: [
                              // Render charts
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Device Name: ${this.deviceName}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 114, 147, 67),
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: chartOnPressed,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  // Temperature chart
                                  child: SfCartesianChart(
                                    title: ChartTitle(
                                      text: 'Temperature in Field',
                                      alignment: ChartAlignment.center,
                                      borderColor: Colors.transparent,
                                      borderWidth: 0,
                                    ),
                                    series: <LineSeries<LiveData, int>>[
                                      LineSeries<LiveData, int>(
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          _chartSeriesControllerTemp =
                                              controller;
                                        },
                                        dataSource: temperatureChartData,
                                        color: Colors.orange,
                                        xValueMapper: (LiveData sales, _) =>
                                            sales.time,
                                        yValueMapper: (LiveData sales, _) =>
                                            sales.data,
                                      ),
                                    ],
                                    primaryXAxis: NumericAxis(
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift,
                                      interval: 2,
                                      title: AxisTitle(
                                        text: 'Time (minutes)',
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      axisLine: const AxisLine(width: 0),
                                      majorTickLines:
                                          const MajorTickLines(size: 0),
                                      title: AxisTitle(
                                        text: 'Temperature (C°)',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: chartOnPressed,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  // Moisture chart
                                  child: SfCartesianChart(
                                    title: ChartTitle(
                                      text: 'Moisture in Field',
                                      alignment: ChartAlignment.center,
                                      borderColor: Colors.transparent,
                                      borderWidth: 0,
                                    ),
                                    series: <LineSeries<LiveData, int>>[
                                      LineSeries<LiveData, int>(
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          _chartSeriesControllerMois =
                                              controller;
                                        },
                                        dataSource: moistureChartData,
                                        color: Colors.blue,
                                        xValueMapper: (LiveData sales, _) =>
                                            sales.time,
                                        yValueMapper: (LiveData sales, _) =>
                                            sales.data,
                                      )
                                    ],
                                    primaryXAxis: NumericAxis(
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift,
                                      interval: 2,
                                      title: AxisTitle(
                                        text: 'Time (minutes)',
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      axisLine: const AxisLine(width: 0),
                                      majorTickLines:
                                          const MajorTickLines(size: 0),
                                      title: AxisTitle(
                                        text: 'Moisture (%)',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LiveData {
  LiveData(this.time, this.data);
  final int time;
  final int data;
}
