import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class NoDevices extends StatelessWidget {
  const NoDevices({Key? key}) : super(key: key);

  void _copyToClipboard(BuildContext context) {
    FlutterClipboard.copy('riceupegypt@hotmail.com').then((value) {
      final snackBar = SnackBar(
        content: Text('Email copied to clipboard'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset('assets/images/no_device.png'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 350,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text(
                    'There are no devices registered for this account.\n\n\ncontact us at our email address to request a device.\n',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      _copyToClipboard(context);
                    },
                    child: const Text(
                      'riceupegypt@hotmail.com',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Press to copy',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
