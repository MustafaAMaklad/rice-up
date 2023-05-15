import "dart:async";
import "dart:convert";

// import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:amplify_flutter/amplify_flutter.dart";
import "package:flutter/material.dart";

import "../models/Reading.dart";

import 'package:amplify_api/amplify_api.dart';

import 'package:graphql/client.dart';

class UserAttributes extends StatefulWidget {
  const UserAttributes({super.key});

  @override
  State<UserAttributes> createState() => _UserAttributesState();
}

class _UserAttributesState extends State<UserAttributes> {
  StreamSubscription<GraphQLResponse<Reading>>? subscription;
  List<Reading> readings = [];
  // const UserAtrributes({super.key});
  // Future<Map<String, String>> getUserAttributes() async {
  //   final attributes = await Amplify.Auth.fetchUserAttributes();
  //   final data = {for (var e in attributes) e.userAttributeKey.key: e.value};

  //   for (var key in data.keys) {
  //     var value = data[key];
  //     print('$key: $value');
  //   }
  //   return data;
  // }
//   GraphQLRequest<String> request = GraphQLRequest<String>(
//     document: '''
//     query MyQuery {
//   getReading(id: "54/1683153689.1684") {
//     timestamp
//     moisture
//     temperature
//   }
// }
//   ''',
//   );

  @override
  void dispose() {
    super.dispose();
    unsubscribe();
  }

  @override
  void initState() {
    super.initState();
    subscribe();
  }

  // Future<Reading?> queryItem(Reading queriedReading) async {
  //   try {
  //     final request = ModelQueries.get(
  //       Reading.classType,
  //       queriedReading.modelIdentifier as String,
  //     );
  //     final response = await Amplify.API.query(request: request).response;
  //     final todo = response.data;
  //     if (todo == null) {
  //       safePrint('errors: ${response.errors}');
  //     }
  //     return todo;
  //   } on ApiException catch (e) {
  //     safePrint('Query failed: $e');
  //     return null;
  //   }
  // }

  dynamic queryListItems() async {
    const document = '''
        query MyQuery {
          listReadings(filter: {id: {beginsWith: "arn:aws:iot:us-east-1:404548260653:thing/ESP32_Farm1"}}, limit: 10) {
            items {
              moisture
              temperature
              timestamp
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
      safePrint("reading:  $data");
      // safePrint("date:  $formatedTime");
      safePrint((data).runtimeType);
      if (data == null) {
        safePrint('errors: ${response.errors}');
      }
      return data.toString();
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return [];
    }
  }

  Future<void> createReading() async {
    try {
      final reading = Reading(
        device_id: "12345678",
        timestamp: 123,
        temperature: 0.1111,
        moisture: 0.1111,
      );
      final request = ModelMutations.create(reading);
      final response = await Amplify.API.mutate(request: request).response;

      final createdReading = response.data;
      if (createdReading == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdReading.device_id}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<Reading?> queryReading(Reading queriedReading) async {
    try {
      final request = ModelQueries.get(
        Reading.classType,
        queriedReading.modelIdentifier as String,
      );
      final response = await Amplify.API.query(request: request).response;
      final reading = response.data;
      if (reading == null) {
        safePrint('errors: ${response.errors}');
      }
      return reading;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  Future<List<Reading?>> queryListReading() async {
    try {
      final request = ModelQueries.list(Reading.classType);
      final response = await Amplify.API.query(request: request).response;

      final reading = response.data?.items;
      if (reading == null) {
        safePrint('errors: ${response.errors}');
        return const [];
      }
      safePrint(reading.length);
      return reading;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return const [];
    }
  }

  // Stream<GraphQLResponse<Reading>> subscribe() {
  //   final subscriptionRequest = ModelSubscriptions.onCreate(Reading.classType);
  //   final Stream<GraphQLResponse<Reading>> operation = Amplify.API
  //       .subscribe(
  //         subscriptionRequest,
  //         onEstablished: () => safePrint('Subscription established'),
  //       )
  //       // Listens to only 5 elements
  //       .take(5)
  //       .handleError(
  //     (Object error) {
  //       safePrint('Error in subscription stream: $error');
  //     },
  //   );
  //   safePrint(operation);
  //   return operation;
  // }

  void subscribe() {
    final subscriptionRequest = ModelSubscriptions.onCreate(Reading.classType);
    final Stream<GraphQLResponse<Reading>> operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => safePrint('Subscription established'),
    );
    subscription = operation.listen(
      (event) {
        setState(() {
          readings.add(event.data!);
        });
        safePrint('Subscription event data received: ${event.data}');
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  void unsubscribe() {
    subscription?.cancel();
    subscription = null;
  }

  final UserAttributes display = UserAttributes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Real-time Data',
        ),
        elevation: 0.0,
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: readings.length,
        itemBuilder: (context, index) {
          final reading = readings[index];
          return ListTile(
            title: Text('Device ID ${reading.device_id}'),
            subtitle: Column(
              children: [
                Text('Time: ${reading.timestamp}'),
                Text('Temperature: ${reading.temperature}'),
                Text('Moisture: ${reading.moisture}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
