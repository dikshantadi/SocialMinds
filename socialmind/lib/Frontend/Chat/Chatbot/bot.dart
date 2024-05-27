import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatbotService {
  Interpreter? _interpreter;

  /// Loads the TensorFlow Lite model from the specified asset.
  Future<void> loadModel() async {
    try {
      final assetPath = 'socialmind/assets/chatbot_model.tflite';
      print("Loading model from asset: $assetPath");
      _interpreter = await Interpreter.fromAsset(assetPath);
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  /// Runs the model with the provided input and returns the output.
  ///
  /// Throws a [//StateError] if the model is not loaded.
  List<double> runModel(List<double> input) {
    if (_interpreter == null) {
      throw StateError('Model is not loaded');
    }

    // Define the output structure
    List<List<double>> output = List.generate(1, (_) => List.filled(10, 0.0));

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      print("Error running model: $e");
      rethrow;
    }

    return output[0];
  }

  /// Closes the interpreter to free resources.
  void close() {
    _interpreter?.close();
    _interpreter = null;
    print("Interpreter closed.");
  }
}
