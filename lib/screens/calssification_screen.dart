import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:rice_up/widgets/palatte.dart';
// import 'package:flutter/services.dart' show rootBundle;

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
      return 'مرض فطرى يسبب وجوده بقع بنية اللون فى حجم رأس عود الكبريت على الأوراق وكذلك تظهر هذه البقع على الحبوب فتشوه مظهرها (شكل رقم 2) ولا يؤدى هذا المرض إلى فقد كبير فى المحصول تحت الظروف العادية، بينما يشتد الضرر فى حالات الأراضى الضعيفة أو عند إستخدام مياه المصارف فى عملية الرى خاصة للأصناف القابلة للإصابة بشــدة .الحالية مقاومة لهذا المرض فيما عدا الصنف جيزة 177 وسخا 102 . وعموما فإن المقاومة المتكاملة والتى تعتمد على جميع عناصر المقاومة سواء الوقائية مثل إستخدام أصناف مقاومة والإلتزام بالمعدل الموصى به فى التسميد الآزوتى حيث أن النقص يشجع الإصابة والتخلص من مصادر العدوى مثل قش الأرز والحشائش وزراعة تقاوى سليمة أو المقاومة العلاجية عند الضرورة سوف تؤدى إلى زيادة المحصول وذلك برش كبريتات الزنك 1 % بمعدل 1 كجم / فدان أو الهينوزان بمعدل 400 سم3 / ف';
    } else if (prediction == 'Blast') {
      return '''
العوامل التي تساعد على انتشار مرض اللفحة في الأرز:
1. زراعة الأصناف القديمة القابلة للإصابة بمرض اللفحة.
2. التأخير في الزراعة بعد النصف الأول من شهر مايو.
3. زيادة التسميد الآزوتي عن المعدلات الموصى بها.
4. زيادة نسبة الرطوبة وارتفاع حرارة الجو.
5. تجفيف التربة لفترات طويلة من 7-10 أيام.
الإجراءات الوقائية لمكافحة مرض اللفحة:
1. زراعة الأصناف المقاومة والموصى بها للزراعة.
2. التبكير في الزراعة (النصف الأول من شهر مايو للمشاتل).
3. إدارة الري بشكل مناسب وعدم تجفيف التربة لفترات طويلة.
4. التخلص من قش الأرز كمصدر أساسي للعدوى.''';
      ;
    } else if (prediction == 'Healthy') {
      return 'The plant appears to be healthy. Keep up the good work!';
    } else {
      return 'No feedback available for the predicted class.';
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
          color: Colors.amberAccent,
        ),
        backgroundColor: primaryLightColor,
        elevation: 0.0,
        title: const Text(
          'Classification Result',
          style: TextStyle(
            color: Colors.amber,
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
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
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
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("diagnosing..."),
                              ],
                            )
                          } else ...{
                            Text(
                              'حالة المحصول: $_imagePrediction ',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              '  التعريف والعلاج: $feedback',
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          }
                        ],
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
