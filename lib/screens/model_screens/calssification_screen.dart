import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:rice_up/widgets/palatte.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({Key? key}) : super(key: key);

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  // Hold model prediction
  String? _imagePrediction;
  // Model
  Model? _imageModel;
  // Image to predict
  File? _imageFile;
  // To display loading icon
  bool _isLoading = true;

  // Result and treatments
  final String blastFeedback = '''\n
Factors that contribute to the spread of rice blast disease:

  1. Planting old varieties susceptible to rice 
      blast disease.
  2. Delaying planting after the first half of May.
  3. Excessive nitrogen fertilization beyond 
      recommended rates.
  4. Increased humidity and high temperature.
  5. Prolonged soil dryness for 7-10 days.


Preventive measures to control rice blast disease:

  1. Plant resistant and recommended varieties.
  2. Early planting (first half of May for 
      nurseries).
  3. Proper irrigation management and avoiding 
      prolonged soil dryness.
  4. Proper disposal of rice straw as a primary 
      source of infection.\n''';
  final String brownFeedback = '''\n
Factors that contribute to the spread of rice brown disease:

1. Favorable conditions: Warm and humid climates.
2. Infected seed/plant material.
3. Lack of crop rotation.
4. Dense planting.
5. Poor water management


Preventive measures to control rice brown disease:

1. Use disease-resistant varieties.
2. Treat seeds with fungicides or hot water.
3. Rotate crops to break the disease cycle.
4. Maintain proper plant spacing.
5. Manage water effectively.
6. Practice field sanitation.
7. Apply fungicides judiciously.\n''';
  final String noFeedBack = '''\n
No feedback available for the predicted class.\n''';
  final String healthyFeedback = '''\n
The plant appears to be healthy. Keep up the good work!\n''';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future<void> loadModel() async {
    String pathModel = 'assets/models/traced_model.pt';
    _imageModel = await PyTorchMobile.loadModel(pathModel);
    runImageModel();
  }

  // model predict image
  Future<void> runImageModel() async {
    _imagePrediction = await _imageModel!.getImagePrediction(
      File(_imageFile!.path),
      300,
      300,
      "assets/labels/labels.csv",
    );
    setState(() {
      _isLoading = false;
    });
  }

  String getFeedbackBasedOnPrediction(String? prediction) {
    if (prediction == 'Brown') {
      return brownFeedback;
    } else if (prediction == 'Blast') {
      return blastFeedback;
    } else if (prediction == 'Healthy') {
      return healthyFeedback;
    } else {
      return healthyFeedback;
    }
  }

  @override
  Widget build(BuildContext context) {
    _imageFile = ModalRoute.of(context)!.settings.arguments as File;
    String feedback = getFeedbackBasedOnPrediction(_imagePrediction);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: secondaryColor,
        ),
        backgroundColor: primaryLightColor,
        elevation: mainElevation,
        title: const Text(
          'Classification Result',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15)),
                  width: 250,
                  height: 250,
                  child: Image.file(
                    _imageFile!,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 350,
                      // height: 300,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 40,
                              width: 30,
                            ),
                            if (_isLoading) ...{
                              Column(
                                children: const [
                                  CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("diagnosing..."),
                                ],
                              )
                            } else ...{
                              Text(
                                'Crop Condition: $_imagePrediction\n',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                'Preventive measures and treatment: $feedback',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            }
                          ],
                        ),
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
