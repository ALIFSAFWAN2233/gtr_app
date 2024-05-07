import 'dart:developer' as l;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;

class Segment {
  // Class for yolo segmentation model implementation
  //input tensor of YOLO: shape: [1, 3, 704, 704] dtype: float32
  //output tensor of YOLO:  shape: (1, 5, 10164) dtype: <dtype: 'float32'>
  late tfl.Interpreter _interpreter;
  late List<int> _inputShape;
  late List<int> _outputShape;

  Segment();

  Future<void> initModel() async {
    _interpreter =
        await tfl.Interpreter.fromAsset('assets/Model/SegmodelVersion2.tflite');
    l.log("model loaded$_interpreter");
    _inputShape = _interpreter.getInputTensor(0).shape;
    _outputShape = _interpreter.getOutputTensor(0).shape;
  }

  //run inference on the image data accepted
  Future<List<List<double>>> runInference(Uint8List inputImage) async {
    try {
      await initModel();
      l.log("Initialize model");

      // Convert the format from image data to img format
      final image = img.decodeImage(inputImage);
      // Resize input image into 704x704
      final imageInput = img.copyResize(image!, width: 704, height: 704);

      // Create input image matrix to represent [1, 704, 704, 3]
      final imageMatrix = List.generate(
        704, // Height
        (y) => List.generate(
          704, // Width
          (x) {
            // Get the RGB components of the pixel at coordinates (x, y)
            final pixel = imageInput.getPixel(x, y);
            // Return the RGB values as a double
            return [pixel.r.toDouble(), pixel.g.toDouble(), pixel.b.toDouble()];
          },
        ),
      );

      // Add a batch dimension to the input image matrix
      final input = [imageMatrix];

      // Adjust the output tensor structure to match the shape (1, 5, 10164)
      final output = {
        0: List.generate(10164, (_) => [0, 0, 0, 0, 0.0]),
      };

      // Run inference
      _interpreter.run(input, output);
      l.log("Prediction achieved...");
      print(output);

      // Extract bounding boxes from the output tensor
      final List<List<double>> boundingBoxes = [];
      for (int i = 0; i < 10164; i++) {
        final bbox = output[0]![i].map((e) => e.toDouble()).toList();
        boundingBoxes
            .add(bbox.sublist(0, 4)); // Extract only bounding box coordinates
      }
      l.log(boundingBoxes.toString());

      return boundingBoxes;
    } catch (e) {
      l.log('Error running inference: $e');
      return [];
    } finally {
      _interpreter.close();
    }
  }
}
