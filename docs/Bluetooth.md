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
|1|flutter_blue|Flutter blue is a library, which contains a lot of functionalities that we can use. It meets all our requirements. However, there is one drawback. This package has not been updated for a long time. Flutter blue also has a discord page for help.
|2|flutter_blue_plus|Flutter blue plus is a library, whose code is forked from Flutter Blue. This means that they used the same code and built upon it. The owner of this package is also more active and updates are released regularly.|.
|3|Tugberk Akdogan's movesense library|This is a library, in which Akdogan makes it possible to explicitly connect to movesense Sensors. In doing so, Akdogan has also added to visualize data in real time.|.
|4|No library|With Flutter you can also read connections with Bluetooth. However, this goes very deep and creates a lot of boiler plate code in the project.|


## Conclusion
In the end, we came to a conclusion to use the bluetooth library flutter_blue_plus. This is a library that meets all our requirements. It has all the functionalities we need.

During this research we were also able to make findings in the area of data visualization. Tugberk Akdogan's library is open source. In his code, we can see how he visualizes live data from a MoveSense. Since his code is open source we can see all the code and get an idea about how we can visualize live data from a movesense sensor. [Click here](https://github.com/petri-lipponen-movesense/mdsflutter) to go to the github page
