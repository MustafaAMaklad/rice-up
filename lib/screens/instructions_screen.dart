import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLightColor,
        centerTitle: true,
        elevation: 0.0,
        leading: const BackButton(
          color: secondaryColor,
        ),
        title: const Text(
          'Instructions',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Temperature\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                              style: TextStyle(color: Colors.black),
                              text:
                                  '1. م° يتأثر الإنبات سلبيا إذا إرتفعت درجة الحراره عن 30 - 35 \nحيث لاتنبت البذور\n\n'),
                          TextSpan(
                            style: TextStyle(color: Colors.black),
                            text:
                                '2. فإن درجات الحراره لمناسبه لنمو الأرز أثناء مراحل نموه المختلفه\nتتراوح بين 20-37 م° ويتأثر النمو إذا تعرض النبات فى أى طور من أطوار نموه لدرجات حراره أقل من 15 م°\n\n',
                          ),
                          TextSpan(
                            style: TextStyle(color: Colors.black),
                            text:
                                '3. يتأثر محصول الأرز سلبيا إذا تعرضت النباتات لدرجات حراره مرتفعه أثناء الليل\n\n',
                          ),
                          TextSpan(
                            style: TextStyle(color: Colors.black),
                            text:
                                '4. الأراضي الطينية الخصبة الغنية بالمادة العضوية وذات القوام المتماسك.والأرز يتحمل الملوحة بدرجة قليلة',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text(
                'Moisture',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
