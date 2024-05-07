import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:developer' as l;
import 'package:gtr_app/Segment.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gtr_app/preprocess.dart' as pro;
import 'dart:developer' as devtools;
import 'package:image/image.dart' as img;
import 'package:flutter_color/flutter_color.dart' as color;

/*
 PERFORMING THE INFERENCE IN THE INPUT IMAGE FLOW

 1. Get the image input from the user   ****SETTLE****
 2. Preprocess the image                    
      - Segment the image using YOLOv8 model 
      - Crop the image based on the inference of YOLOv8 model
      - Use the cropped image and apply sobel filter.
 3. Modify the image to match input tensor spec of the model 
      - INPUT TENSOR (None, 50, 50, 3) # 50 WIDTH&HEIGHT, RGB format
      - OUTPUT TENSOR (7) # 7 classes 
 4. Input the image into the MODEL
 5. Extract the prediction result and display it to the user
 */

/* 
  INTEGRATING THE YOLO AND CNN MODEL INTO THE APP

  1. 
*/

/* 
  RETRIEVE AND USE THE USER INPUTTED IMAGE

  1. Retrieve the image from previous screen ***SETTLED***
  2. 
*/

class ResultPage extends StatefulWidget {
  //File imageFile holds the user-inputted image
  final File imageFile;

  const ResultPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  /* Perform Computation */
  //import the defined preprocess package

  //final pro.ImagePreprocessing _imageProcessing = pro.ImagePreprocessing();
  Future<Uint8List?>? segmentImage;
  Segment segmentationModel = Segment();

  @override
  void initState() {
    super.initState();
    //call initialize method which kick start the whole inference thing
    initialize();
  }

  Future<void> initialize() async {
    //Load segmentation model
    segmentationModel.initModel();
    //converts the imageFile path to image data
    Uint8List imageData = readImage(widget.imageFile.path);
    l.log("Read image data");
    //run inference on the input image
    var segmentImageFuture = MainrunInference(imageData);
    l.log("inference done...");
    //Update the state after all async operations are completed
    setState(() {
      segmentImage = segmentImageFuture;
    });
  }

  //read the image from image path and return the image data
  Uint8List readImage(String imagePath) {
    Uint8List imgBytes = File(imagePath).readAsBytesSync();
    return imgBytes;
  }

  //the method that incorporates the segmentation inference
  Future<Uint8List?> MainrunInference(Uint8List inputImage) async {
    //need to review the segmentation model inference
    final result = await segmentationModel.runInference(inputImage);
    if (result.isNotEmpty) {
      // Crop the original image based on the bounding box coordinates

      // Use the result from inference to draw the bbox
      // Use inputImage to draw the bbox on the image
      List<int> prediction = overlayBoundingBoxes(inputImage, result);

      // Uint8List resultSegment = Uint8List.fromList(prediction);
      l.log('returning segmentatized image');
      return Uint8List.fromList(prediction);
    } else {
      return null;
    }
  }

  //overlay the bouding box on the original image
  List<int> overlayBoundingBoxes(
      Uint8List inputImage, List<List<double>> boundingBoxes) {
    // Load the input image
    //convert from image data to Image object
    var image = img.decodeImage(inputImage)!;

    // Loop through bounding boxes and draw rectangles
    // [x_min,y_min,x_max,y_max]
    for (List<double> box in boundingBoxes) {
      int x1 = (box[0]).toInt();
      int y1 = (box[1]).toInt();
      int x2 = (box[2]).toInt();
      int y2 = (box[3]).toInt();

      // Draw rectangle on the original image
      img.drawRect(image,
          x1: x1,
          y1: y1,
          x2: x2,
          y2: y2,
          color: img.ColorFloat16.rgb(0, 255, 0));
    }
    l.log("Boundng box applied...");
    //return the image
    return img.encodeJpg(image);
  }

  /* ******************************************* */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: result_page_txt(),
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text('Recognition Result'),
            ),
            Container(
                color: Colors.amberAccent,
                height: 300,
                width: 500,
                //Display the image to the screen
                child: FutureBuilder<Uint8List?>(
                    future: segmentImage,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Image.memory(snapshot.data!);
                      }
                    }))
          ])
        ],
      ),
    )
        //Button
        //floatingActionButton: FloatingActionButton(onPressed: Null),
        ;
  }
}

//Result Text Page
class result_page_txt extends StatelessWidget {
  const result_page_txt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text('Below is the predicted result of selected image. '));
  }
}
