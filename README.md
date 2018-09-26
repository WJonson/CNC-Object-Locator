# CNC Object Locator


Our goal for this project was to correctly locate objects on a grid and connect them using a CNC XY Plotter. Since this project was made for a Mechatronics class, it works for the purpose of the project. With some modifications, the project could be applied to different tasks and become more robust.

## A Summary of How it Works

Our team wanted to identifty the objects and send Gcode to the machine all within MATLAB. For the purposes of the project, our task was to locate "RED" and "GREEN" objects on a grid and connect them to "4" and "E" respectively. We implemented a neural network that was trained to recongnize a small set of colors. After training the neural network, our MATLAB functions will scan through a photo that was captured from an iPhone and identifty where the GREEN and RED objects are located on the grid. Once the objects are found, Gcode will be generated and sent to an Arduino running GRBL.

## Getting Started

We will only cover the software of the project and will list the core hardware that was used. GRBL 1.1 must be modded to work as an XY Plotter with a pen. Under the "Software" section, we have listed an instructable to mod GRBL.

### Prerequisites

Software:
  - MATLAB with "APP Designer"
  - GRBL 1.1 modded for XY Plotter
     http://www.instructables.com/id/How-to-Control-a-Servo-Using-GRBL/
  - "IPcam" from the Apple App store
     https://itunes.apple.com/us/app/ip-cam/id333208495?mt=8

Hardware:
  - Arduino UNO with GRBL
  - iPhone
  - 2 Stepper Motors and 1 Mirco Servo
  - 2 Stepper Motor Drivers
  - External Power Source
  - Linear Rails
  - (Optional) Arduino Motor Shield

```
Our Hardware:
  - KEYSTUDIO Arduino UNO w/ Arduino CNC Shield v3
  - 2 A4988 Stepper Motor Drivers
     https://www.amazon.com/gp/product/B016O7TD6O/ref=oh_aui_detailpage_o04_s00?ie=UTF8&psc=1
  - 2 Beauty Star NEMA 17, 1.8 Deg, 40 N.cm Stepper Motors
     https://www.amazon.com/gp/product/B0716S32G4/ref=oh_aui_detailpage_o06_s00?ie=UTF8&psc=1
  - 1 Tower Pro SG90 Mirco Servo
     https://www.amazon.com/TowerPro-Micro-Airplane-Helicopter-Controls/dp/B01J477UHU/ref=sr_1_1?ie=UTF8&qid=1528511710&sr=8-1&keywords=tower+pro+sg90
  - External Power Source (Used PSU from school)
  - Spare Linear Rails lying around
```

### Installing

After downloading the files, be sure to place all of the functions in the same directory.To run the GUI click on the following .mlapp file.

```
ColorLocator.mlapp
```

## How to Use

### Initial Setup and Using the Nerual Network

Open "IPcam" on the iPhone and copy the URL that is given by the app. Place the iPhone above the grid so that it can see the grid. Also, connect the Arduino UNO to the computer and find its COM Port. The user will need to enter these attributes at the at the bottom of the GUI.

**NOTE** The URL will need "//image.jpg" added to the end of it.

Example
```
Camera URL: http://10.129.1.32:8020//image.jpg
COMM Port: COM8
```

Pre-trainned weights from the nerual network are already included under "testedWeights.mat". The GUI loads these weights to scan through the picture (to change go into GUI code). To change, new weights can be found using the files under "NN Training". The examples we used are not provided.

### Capture

Capture a picture from the iPhone.

If everything is setup correctly, "Capture" will take an image from the iPhone and display it under "Camera View". The grid lines displayed are there to give the user a visual representation of how the "encode" button works.

### Scan

Use the pre-trainned NN weights to identify RED and GREEN objects.

The algorithm uses a 20x20 pixel window to scan through the entire picture. When the program identifies a GREEN or RED object, a 20x20 pixel box will be displayed under "Camera View".

Although it is not shown, the pixel locations and the classification of the results from the scan are saved.

### Encode

Using the results from "Scan", find where these objects lie on the grid and the Gcode required to move to there.

A LUT is used to identify where to RED and GREEN objects lie on the grid. This is all specific to the grid given for our project. Each location in the LUT also has Gcode that corresponds to the location on the physical grid. All of the "encoded" data will be displayed under "Encoded Data".

As stated in "Capture" the grid lines represent the LUT. To achieve optimal results, align the grid lines to the physical grid lines on the paper.

The program is set to only find 2 RED and 2 GREEN objects. For our project there would only 2 of each.

### Send Gcode

Take the encoded data, generate a Gcode .txt file, and send to the Arduino.

Using the data from "Encode", create .txt file with all of the Gcode found. Once the Gcode is generated, it will be sent to the arduino.

The Arduino will home the system first and then require user input to continue after homming is complete.

Gcode Output File:
```
gcode_grid.txt
```

### Auto

This will perform all four actions.

## Authors

* **Wesley Jonson** - *Initial work* - [WJonson](https://github.com/WJonson)
* **Rex Congdon**   - *Mechanical work*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* **Sergio Rivera Lavado** - Created circuit_to_gcode.m function. I followed his approach to createing Gcode files in MATLAB.
	https://www.mathworks.com/matlabcentral/fileexchange/34965-circuit-to-gcode
* **lingib** - Created Instructable on how to use GRBL with a PEN
	http://www.instructables.com/id/How-to-Control-a-Servo-Using-GRBL/
* **Andrew Ng** - For his Machine Learning course on Coursera. I structured the NN based on one of the projects we did in his class.
	https://www.coursera.org/learn/machine-learning
* Mojtaba Azadi, Ph.D. - SFSU Mechatronics Instructor
