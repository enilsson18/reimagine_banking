import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Send Values To Next Screen')),
            body: Center(child: HomeScreen())));
  }
}

const double BASE_INVEST = 0.75;
const INDEXES = ["DowJones", "FF49", "FTSE100", "NASDAQ", "SP500"];
const VOLATILITIES = [0.024601, 0.025170, 0.026865, 0.029543, 0.030055];
const WEEKLY_RETURNS = [.002885, .004016, .002508, .003606, .002546];
const SAMPLE_SIZE = [1363, 2325, 717, 596, 595];
const Z_SCORES = [1.645, 1.036];

var inputMoney;
var riskTolerance;
var salary;
var necessarySpending;
var cRisk;
var timeInMarket;

var numTime;
var investHolder;
var numRisk;
var numSalary;
var numAssets;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final salary = TextEditingController();
  final asset = TextEditingController();
  final time = TextEditingController();
  final riskLevel = TextEditingController();

  getItemAndNavigate(BuildContext context) {
    numSalary = double.parse(salary.text);
    numAssets = double.parse(asset.text);
    inputMoney = numSalary - numAssets;
    investHolder = inputMoney * BASE_INVEST;
    if (investHolder > inputMoney) {
      investHolder = inputMoney;
    }

    var splits = [0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 4; i++) {
      splits[i] =
          (VOLATILITIES[i] - VOLATILITIES[i + 1]) / 2.0 + VOLATILITIES[i];
    }

    cRisk = double.parse(riskLevel.text);

    double num = cRisk * (0.0005454) + VOLATILITIES[0];
    String choice = INDEXES[4];
    int choiceIndex = 0;
    for (int i = 0; i < 4; i++) {
      if (num < splits[i]) {
        choice = INDEXES[i];
        choiceIndex = i;
        break;
      }
    }
    timeInMarket = double.parse(time.text);

    var earningsTemp =
        (investHolder) * pow(1 + WEEKLY_RETURNS[4], timeInMarket);

    double roundDouble(double value, var places) {
      var mod = pow(10.0, places);
      return ((value * mod).round().toDouble() / mod);
    }

    earningsTemp = roundDouble(earningsTemp, 2);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecondScreen(
                salaryHolder: salary.text,
                assetsHolder: asset.text,
                timeHolder: time.text,
                riskHolder: riskLevel.text,
                investHolder: investHolder,
                earningsHolder: earningsTemp,
                marketHolder: INDEXES[choiceIndex])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          Container(
              width: 280,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: salary,
                autocorrect: true,
                decoration:
                    const InputDecoration(hintText: 'Enter Yearly Salary (\$)'),
              )),
          Container(
              width: 280,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: asset,
                autocorrect: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Total Yearly Spending (\$)'),
              )),
          Container(
              width: 280,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: time,
                autocorrect: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Number of Weeks to Invest'),
              )),
          Container(
              width: 280,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: riskLevel,
                autocorrect: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Desired Riskiness (0-10)'),
              )),
          RaisedButton(
            onPressed: () => getItemAndNavigate(context),
            color: const Color(0xffFF1744),
            textColor: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: const Text('Click Here To Receive Investment Advice'),
          ),
        ],
      ),
    ));
  }
}

class SecondScreen extends StatelessWidget {
  String salaryHolder;
  String assetsHolder;
  String timeHolder;
  String riskHolder;
  String marketHolder;
  double investHolder;
  double earningsHolder;

  double get numSalary => double.parse(salaryHolder);
  double get numAsset => double.parse(assetsHolder);
  get numTime => double.parse(timeHolder);
  get numRisk => int.parse(riskHolder);

  SecondScreen(
      {Key? key,
      required this.salaryHolder,
      required this.assetsHolder,
      required this.timeHolder,
      required this.riskHolder,
      required this.marketHolder,
      required this.investHolder,
      required this.earningsHolder})
      : super(key: key);

  goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Second Activity Screen"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                'Market to Invest = ' + marketHolder.toString(),
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )),
              Center(
                  child: Text(
                'Amount to Invest = ' + investHolder.toString(),
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )),
              Center(
                  child: Text(
                'Projected Earnings = ' + earningsHolder.toString(),
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )),
              RaisedButton(
                onPressed: () => goBack(context),
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: const Text('Go Back To Previous Screen'),
              )
            ]));
  }
}

double getExpectedValue(double timeIn, double moneyIn) {
  return (moneyIn) * pow(1 + WEEKLY_RETURNS[4], timeIn);
}
