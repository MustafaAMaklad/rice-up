import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

import "dart:async";
import "dart:convert";

// import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:amplify_flutter/amplify_flutter.dart";

import "../models/Reading.dart";

import 'package:amplify_api/amplify_api.dart';

import 'package:graphql/client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  int time = 19; // Start X-axis (time) for new subscription at 20
  int limit = 20; // limit of first query
  String deviceId = "arn:aws:iot:us-east-1:404548260653:thing/ESP32_Farm1";

  // Intialize data structrues for items to be displayed
  dynamic lastItems = [];
  List<int> lastTemperature = [];
  List<int> lastMoisture = [];
  List<Reading> readings = [];

  // defining Subscribtion variable
  StreamSubscription<GraphQLResponse<Reading>>? subscription;

  @override
  void dispose() {
    super.dispose();
    unsubscribe(); // Close API subscription
  }

  @override
  void initState() {
    super.initState();
    // Checks internet connection to establish subscription and query data
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection. Try connecting to the internet again to be able to view data.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      subscribe(); // Establish API subscription
      init(); // Get last Items recorded previously
    }
  }

  Future<void> init() async {
    // Get last Items recorded previously
    List<List<int>> lastItems = await queryListItems();

    List<int> lastTemperature = lastItems[0];
    List<int> lastMoisture = lastItems[1];
    setState(() {
      temperatureChartData = getTempChartData(
          lastTemperature); // Get last previous 10 temperature data
      moistureChartData =
          getMoisChartData(lastMoisture); // Get last previous 10 moisture data
    });
  }

  // GraphQl API subscription
  void subscribe() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Reading.classType);
    debugPrint("here is an error1");
    final Stream<GraphQLResponse<Reading>> operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    );
    debugPrint("here is an error2");
    subscription = operation.listen(
      (event) {
        debugPrint("here is an error3");
        setState(() {
          readings.add(event.data!);
          int temperature = event.data!.temperature!.toInt();
          int moisture = event.data!.moisture!.toInt();
          updateData(temperature, moisture);
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
    if (temperatureChartData.length >= 19) {
      temperatureChartData.removeAt(0);
    }
    if (moistureChartData.length >= 19) {
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

  // Query last 10 items to plot for the user
  // when user opens the chart
  Future<List<List<int>>> queryListItems() async {
    String document = '''
        query MyQuery {
          listReadings(device_id: "arn:aws:iot:us-east-1:404548260653:thing/ESP32_Farm1",
           limit: 20, sortDirection: DESC) {
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
      // data = DateTime.fromMillisecondsSinceEpoch(data.toInt());
      // String formatedTime =
      //     '${data.year}/${data.month}/${data.day} ${data.hour}:${data.minute}';
      // safePrint("reading:  $data");
      // List<dynamic> values = data;
      // dynamic value = data[0]['moisture'].toInt();
      List<int> temp = [];
      List<int> mois = [];
      for (int i = 0; i < limit; i++) {
        temp.add(data[i]['temperature'].toInt());
        mois.add(data[i]['moisture'].toInt());
      }
      safePrint("temp:  $temp");
      safePrint("mois:  $mois");
      // safePrint("date:  $formatedTime");
      safePrint((temp).runtimeType);
      if (data == null) {
        safePrint('errors: ${response.errors}');
      }
      return [temp, mois];
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return [];
    }
  }

  // void updateDataSource(Timer timer) {
  //   if (chartData.length >= 19) {
  //     chartData.removeAt(0);
  //   }
  //   // time++;
  //   // chartData.add(LiveData(time, (math.Random().nextInt(60) + 30)));
  //   // _chartSeriesControllerTemp.updateDataSource(
  //   //     addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  //   // _chartSeriesControllerMois.updateDataSource(
  //   //     addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  // }

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
    Navigator.pushNamed(context, '/stats_route');
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
        elevation: 0.0,
        title: const Text(
          'Sensor Measurements',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => chartOnPressed(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  // Temperature chart
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Temperature in Field',
                      alignment: ChartAlignment.center,
                      // backgroundColor: Colors.white,
                      borderColor: Colors.transparent,
                      borderWidth: 0,
                    ),
                    // annotations: <CartesianChartAnnotation>[
                    //   CartesianChartAnnotation(
                    //     widget: Container(
                    //       height: 1,
                    //       width: 250,
                    //       color: Colors.red,
                    //     ),
                    //     coordinateUnit: CoordinateUnit.logicalPixel,
                    //     region: AnnotationRegion.chart,
                    //     verticalAlignment: ChartAlignment.center,
                    //     horizontalAlignment: ChartAlignment.center,
                    //     x: 0,
                    //     y: 25,
                    //   ),
                    // ],
                    series: <LineSeries<LiveData, int>>[
                      LineSeries<LiveData, int>(
                        onRendererCreated: (ChartSeriesController controller) {
                          _chartSeriesControllerTemp = controller;
                        },
                        dataSource: temperatureChartData,
                        color: Colors.orange,
                        xValueMapper: (LiveData sales, _) => sales.time,
                        yValueMapper: (LiveData sales, _) => sales.data,
                      ),
                    ],
                    primaryXAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 3,
                      title: AxisTitle(
                        text: 'Time (seconds)',
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      title: AxisTitle(
                        text: 'Temperature (C°)',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  // Moisture chart
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Moisture in Field',
                      alignment: ChartAlignment.center,
                      // backgroundColor: Colors.white,
                      borderColor: Colors.transparent,
                      borderWidth: 0,
                    ),
                    // annotations: <CartesianChartAnnotation>[
                    //   CartesianChartAnnotation(
                    //     widget: Container(
                    //       height: 1,
                    //       width: 250,
                    //       color: Colors.red,
                    //     ),
                    //     coordinateUnit: CoordinateUnit.logicalPixel,
                    //     region: AnnotationRegion.chart,
                    //     verticalAlignment: ChartAlignment.center,
                    //     horizontalAlignment: ChartAlignment.center,
                    //     x: 0,
                    //     y: 25,
                    //   ),
                    // ],
                    series: <LineSeries<LiveData, int>>[
                      LineSeries<LiveData, int>(
                        onRendererCreated: (ChartSeriesController controller) {
                          _chartSeriesControllerMois = controller;
                        },
                        dataSource: moistureChartData,
                        color: Colors.blue,
                        xValueMapper: (LiveData sales, _) => sales.time,
                        yValueMapper: (LiveData sales, _) => sales.data,
                      )
                    ],
                    primaryXAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 3,
                      title: AxisTitle(
                        text: 'Time (seconds)',
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      title: AxisTitle(
                        text: 'Moisture (C°)',
                      ),
                    ),
                  ),
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
