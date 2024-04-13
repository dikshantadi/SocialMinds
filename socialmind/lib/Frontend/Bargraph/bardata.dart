import 'package:socialmind/Frontend/Bargraph/Individualbar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tusAmount;
  final double wedAmount;
  final double thursAmount;
  final double friAmount;
  final double satAmount;

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tusAmount,
    required this.wedAmount,
    required this.thursAmount,
    required this.friAmount,
    required this.satAmount,
  });

  List<Individualbar> barData = [];

  void initializeBarData() {
    barData = [
      //sun
      Individualbar(x: 0, y: sunAmount),

      //mon
      Individualbar(x: 1, y: monAmount),

      //tues

      Individualbar(x: 2, y: tusAmount),

      //wed

      Individualbar(x: 3, y: wedAmount),

      //thurs
      Individualbar(x: 4, y: thursAmount),

      //fri

      Individualbar(x: 5, y: friAmount),

      //sat

      Individualbar(x: 6, y: satAmount),
    ];
  }
}
