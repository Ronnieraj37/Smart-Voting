import 'package:flutter/services.dart';
import 'package:smartvoting/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, 'SmartVoting'),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}

Future<String> callfunction(String funName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funName);
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );
  return result;
}

Future<String> startElection(String name, Web3Client ethclient) async {
  var response =
      await callfunction("startElection", [name], ethclient, ownerKey);
  print("Election Started Successfully");
  return response;
}

Future<String> addCandidate(String name, Web3Client ethclient) async {
  var response =
      await callfunction("addCandidate", [name], ethclient, ownerKey);
  print("Candidate Added Successfully");
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethclient) async {
  var response = await callfunction("authorizeVoter",
      [EthereumAddress.fromHex(address)], ethclient, ownerKey);
  print("Voter Authorized Successfully");
  return response;
}

Future<List> numCandidates(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String funcname, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callfunction(
      "vote", [BigInt.from(candidateIndex)], ethClient, voterKey);
  print("Voted Successfully");
  return response;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}
