import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../services/functions.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client web3client;
  final String electionName;

  const ElectionInfo(
      {super.key, required this.web3client, required this.electionName});

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: numCandidates(widget.web3client),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    const Text("Total Candidates"),
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getTotalVotes(widget.web3client),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    const Text("Total Votes"),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration:
                        const InputDecoration(hintText: "Enter Candidate Name"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addCandidate(
                        addCandidateController.text, widget.web3client);
                    setState(() {});
                  },
                  child: const Text("Add Candidate"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration:
                        const InputDecoration(hintText: "Add Voter Address"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    authorizeVoter(
                        authorizeVoterController.text, widget.web3client);
                  },
                  child: const Text("Authorize Voter"),
                ),
              ],
            ),
            const Divider(),
            FutureBuilder<List>(
              future: numCandidates(widget.web3client),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                          future: candidateInfo(i, widget.web3client),
                          builder: (context, candidatesnapshot) {
                            if (candidatesnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListTile(
                                title: Text(
                                  'Name ${candidatesnapshot.data![0][0].toString()}',
                                ),
                                subtitle: Text(
                                  'Votes ${candidatesnapshot.data![0][1].toString()}',
                                ),
                                trailing: ElevatedButton(
                                    onPressed: () async {
                                      await vote(i, widget.web3client);
                                      setState(() {});
                                    },
                                    child: const Text("Votes")),
                              );
                            }
                          },
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
