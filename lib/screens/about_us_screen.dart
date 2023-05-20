import 'package:flutter/material.dart';
import 'package:rice_up/widgets/palatte.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: secondaryColor,
        ),
        backgroundColor: primaryLightColor,
        elevation: 0.5,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Image.asset(
                'assets/images/back.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Text(
                  //   'Rice Up',
                  //   style: TextStyle(
                  //     fontSize: 24.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Text(
                    'Rice Up is a project focused on improving rice crop management in Egypt. By implementing an IoT-based system for early detection and control of rice diseases, we aim to minimize crop losses and increase rice production. Our user-friendly mobile application provides farmers with real-time data and insights about the health of their rice crops. With our innovative approach, we strive to contribute to Egypt s self-sufficiency in rice production and enhance the overall sustainability of the rice industry.',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
