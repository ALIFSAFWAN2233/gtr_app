import 'dart:io';
import 'dart:ui';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
/*
2. Preprocess the image                    
      - Segment the image using YOLOv8 model 
      - Crop the image based on the inference of YOLOv8 model
      - Use the cropped image
      - apply sobel filter. ***SETTLED***
 3. Modify the image to match input tensor spec of the model 
      - INPUT TENSOR (None, 50, 50, 3) # 50 WIDTH&HEIGHT, RGB format ***SETTLED***
      - OUTPUT TENSOR (7) # 7 classes 
  4. Map the prediction result
*/
/*
class ImagePreprocessing {
  //Method

  //Resizing to 50x50 method
  //accept the File type of img
  //return the resized image in Image type
  img.Image resize50x50(File imagePath) {
    List<int> imageBytes = imagePath.readAsBytesSync();
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      // Resize the image to 50x50 pixels
      img.Image resizedImage =
          img.copyResize(originalImage, width: 50, height: 50);

      // Return the resized image
      return resizedImage;
    } else {
      throw Exception('Failed to decode the image.');
    }
  }

  //Apply Sobel to img method
  //Accepts and return the image in Image data type
  img.Image SobelApp(img.Image inputImage) {
    // Convert the blurred image to grayscale
    img.Image grayImage = img.grayscale(inputImage);
    // Apply gaussian blur to the input image
    img.Image blurredImage =
        img.gaussianBlur(grayImage, 3); // Adjust the sigma value as needed
    // Apply Sobel operator to compute gradients
    img.Image sobelImage = img.sobel(blurredImage);
    img.Image sobelXImage = extractXComponent(sobelImage);

    return sobelXImage;
  }

  // Function to extract the x-axis component from Sobel gradients
  img.Image extractXComponent(img.Image sobelImage) {
    int width = sobelImage.width;
    int height = sobelImage.height;
    img.Image sobelXImage =
        img.Image(width, height); // Create a new image for x-axis component

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int gx = sobelImage.getPixel(x, y); // Get gradient at current pixel
        int r = (gx >> 16) & 0xFF; // Extract red channel (x-axis component)
        sobelXImage.setPixel(
            x, y, img.getColor(r, r, r)); // Set pixel in x-axis component image
      }
    }
    return sobelXImage;
  }
  //Ensure the image in RGB format method

  //Crop Image based on bbox method
  //Inference the image using trained YOLO
}
*/