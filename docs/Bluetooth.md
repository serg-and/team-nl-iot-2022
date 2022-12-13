## Introduction
Our app is going to communicate a lot through Bluetooth with sensors. This is an important part of our app and it is important to use a bluetooth library with functionalities that suits our requirements. On this page you can read more about what our findings were in terms of different bluetooth libraries. 

## Requirements

Below are the requirements that the library must meet. 

|#|Description|
|-|-|
|1|The library must support Bluetooth Low Enegery (BLE) as the Movesense sensor works with BLE.| 
|2|It must be possible to search for bluetooth devices.||3|It must be possible to search for bluetooth devices. 
|3|It must be possible to connect to a bluetooth device.|3 
|4|It must be possible to communicate using bluetooth| 


## Options

Below are several options for Bluetooth functionality.

|#|Name|Description|
|-|-|-|
|1|flutter_blue|The flutter_blue package is a Flutter plugin that provides a Bluetooth API for Flutter apps. It allows developers to easily integrate Bluetooth functionality into their Flutter apps, allowing them to communicate with other Bluetooth devices. This can be useful for a wide range of applications, such as connecting to fitness trackers, wireless speakers, or other Bluetooth-enabled devices. The flutter_blue package provides a simple, high-level API for working with Bluetooth in Flutter, making it easy for developers to add Bluetooth functionality to their apps without having to deal with the low-level details of working with Bluetooth.
|2|flutter_blue_plus|The flutter_blue_plus package is an extension of the flutter_blue package, which provides a Bluetooth plugin for Flutter. The flutter_blue_plus package adds additional functionality to the flutter_blue package, such as the ability to connect to multiple devices simultaneously and support for Bluetooth Low Energy (BLE) GATT characteristic write types. This can be useful for developers who want to build mobile apps that use Bluetooth to communicate with other devices.|.
|3|mdsflutter|The mdsflutter package is a Flutter plugin that allows developers to easily communicate with Movesense sensors using Bluetooth. By using the mdsflutter package, developers can build Flutter apps that can collect data from Movesense sensors and use it in their applications. This can be useful for a wide range of applications, such as health and fitness tracking, sports performance analysis, and more.|.
|4|No library|With Flutter you can also read connections with Bluetooth. However, this goes very deep and creates a lot of boiler plate code in the project.|


## Conclusion
In the end, we came to a conclusion to use the bluetooth library flutter_blue_plus. This is a library that meets all our requirements. It has all the functionalities we need.

During this research we were also able to make findings in the area of data visualization. Tugberk Akdogan's library is open source. In his code, we can see how he visualizes live data from a MoveSense. Since his code is open source we can see all the code and get an idea about how we can visualize live data from a movesense sensor. [Click here](https://github.com/petri-lipponen-movesense/mdsflutter) to go to the github page
