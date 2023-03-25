import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartvoting/pages/electionInfo.dart';
import 'package:smartvoting/services/functions.dart';
import 'package:smartvoting/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? webClient;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    httpClient = Client();
    webClient = Web3Client(infuraUrl, httpClient!);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Election"),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  filled: true, hintText: "Enter Election Name:"),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      await startElection(controller.text, webClient!);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ElectionInfo(
                                web3client: webClient!,
                                electionName: controller.text),
                          ));
                    }
                  },
                  child: const Text("Start Election")),
            ),
          ],
        ),
      ),
    );
  }
}
