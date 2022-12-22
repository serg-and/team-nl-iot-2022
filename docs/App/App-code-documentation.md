# Code Documentation
This page contains the code for the app. In the code of the TeamNL MoveSens app, comments have been added so that the reader can understand what the functionalities do that have been used in the app. These comments are represented with a //. 

## Main 
In the main, the database is set up. In the main, the text TeamNL is also displayed in the appbar. The settings button is also placed in the main. Because the appbar and settings button are placed in the main, these options are displayed on every page. 

```
// Import the pages
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/configure_supabase.dart';
import 'package:app/onboarding_page.dart';
import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await configureApp(); // Awaiting the configuration of the app

  final prefs = await SharedPreferences.getInstance();// Getting the shared preferences instance
  final showHome = prefs.getBool('showHome') ?? false;// Getting the value for 'showHome' from the shared preferences, or false if it does not exist

  runApp(MyApp(showHome: showHome));// Running the MyApp widget
}

class MyApp extends StatelessWidget {
  final bool showHome; // Declaring a boolean variable 'showHome'

  const MyApp({
    Key? key,
    required this.showHome, // The 'showHome' variable is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome ? Routing() : OnBoardingPage(),// If showHome is true, display the Routing widget, otherwise display the OnBoardingPage
      debugShowCheckedModeBanner: false, // Don't show the debug banner
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize; // The preferred size of the app bar
  final navigatorKey = GlobalKey<NavigatorState>(); // A key to access the app's navigator
  final String title; // The title to display in the app bar

  CustomAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(50.0), // Set the app bar's preferred height to 50.0
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('TeamNL'), // Set the app bar's title to 'TeamNL'
      centerTitle: true,
      backgroundColor: Color(0xFFF59509), // Set the background color to a hex color code
      actions: [
        PopupMenuButton(
            itemBuilder: (ctx) => [
                  const PopupMenuItem(
                      value: "Settings", child: Text("Settings"))
                ],// Set the items in the popup menu to a single 'Settings' option
            onSelected: (result) {
              if (title != "Settings") { // If the selected item is not 'Settings'
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              }
            })
      ],
    );
  }
}

```

### Routing
This Dart code is a simple routing class that manages the navigation between different pages in an app. The code imports several classes from other files, including Home, Bluetooth, Current, and History, which are the different pages that the user can navigate to.

```
// Import the other pages
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/current_session.dart';
import 'package:app/sessions.history.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'home_page.dart';


class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {

  var currentIndex = 0;

  List routing = [
    Home(),
    const Bluetooth(),
    const Current(),
    const History()
  ];
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [ // This is the widget that will be displayed at the current index
            routing.elementAt(currentIndex),
            Container(
              margin: EdgeInsets.all(displayWidth * .05),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFFF59509),
                  borderRadius: BorderRadius.all(Radius.circular(displayWidth))),
              child: currentIndex == 4
                  ? GestureDetector( // This is the "Book Now" button that will be displayed on the last screen
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Book Now ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    )
                  ],
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(bottomBar.length, (i) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        currentIndex = i;
                      }),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bottomBar[i],
                          const SizedBox(height: 4),
                          currentIndex == i
                              ? Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          )
                              : Container()
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ));
  }
}
```
### Settings
Three dots have been added in the main dart. These three dots is the settings button. The user can click on settings and will be redirected.  

```
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package

class Settings extends StatelessWidget {
  const Settings({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Settings"), // Use CustomAppBar with "Settings" as title
      body: Center(
        child: Text('Settings'), // Display "Settings" text in the center of the screen
      ),
    ); // End Scaffold
  }
}
```

### Onboarding page
The onboarding pages provide the app's color combinations. In addition, it also takes care of the style that the app has. 

```
// Import the pages and files
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/routing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// OnBoardingPage is a stateful widget that represents the onboarding page for the app.
// It displays a series of pages with text and images that explain the features of the app.
class OnBoardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}
// PageController for managing page views
class _OnboardingPageState extends State<OnBoardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.scaleDown,
              width: 275,
              height: 200,
            ),
            const SizedBox(
              height: 65,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );

  // Parsing Hex code to bits
  static const myGrey = const Color(0xFF8D8C8C);
  static const myLightGrey = const Color(0xFFEFEFEF);
  static const myOrange = const Color(0xFFF59509);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
                color: Colors.white,
                urlImage: 'assets/onboardingscreen/connect.png',
                title: "Connect with the sensor",
                subtitle:
                    "You can connect your device with the build in bluetooth functionalities in the app. Search, add, remove and view bluetooth devices."),
            buildPage(
                color: Colors.white,
                urlImage: 'assets/onboardingscreen/analyse.png',
                title: "Analyse the Data of the sensor",
                subtitle:
                    "In the Team NL move app the coaches can see basic analytics that they can understand. The scientist who want to analyse with their own tools can do this, also by exporting the data in csv format!"),
            buildPage(
                color: Colors.white,
                urlImage: 'assets/onboardingscreen/improve.png',
                title: "Improve the atlete",
                subtitle:
                    "By combining training with tracking in this app coaches can make better decision based on scientific reports about training schemes of a atlete for instance!"),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1)),
                backgroundColor: myOrange,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                // navigate to home page
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Routing()),
                );
              },
              child: const Text("GET STARTED",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            )
          : Container(
              // padding: const EdgeInsets.symmetric(horizontal:),
              color: myLightGrey,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      child:
                          const Text("SKIP", style: TextStyle(color: myGrey))),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: myGrey),
                    ),
                  ),
                  TextButton(
                      onPressed: () => controller.nextPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut),
                      child:
                          const Text("NEXT", style: TextStyle(color: myGrey))),
                ],
              ),
            ));
}

```

### Data
Icons have been added to the navigation bar. This allows the user to immediately see where the home, bluetooth, current session and sessions history pages are. 

```
import 'package:flutter/material.dart';

// ! Routing
int currentIndex = 0;
// ! Routing

// List of bottom bar icons
List bottomBar = [
  // Icon for Home page
  const Icon(
    Icons.home,
    color: Colors.white,
  ),
  // Icon for Bluetooth page
  const Icon(
    Icons.bluetooth,
    color: Colors.white,
  ),
  // Icon for Accessibility page
  const Icon(
    Icons.accessibility_sharp,
    color: Colors.white,
  ),
];

// name of the city, country, rating of the city and image of the path
List data = [
  {
    "city": 'Nassau',
    "country": 'Bahamas',
    "rating": '4.6',
    'image': 'assets/images/nassau.jpg'
  },
  {
    "city": 'Mykonos',
    "country": 'Greece',
    "rating": '4.8',
    'image': 'assets/images/mykonos.jpg'
  },
  {
    "city": 'Colosseum',
    "country": 'Rome',
    "rating": '4.4',
    'image': 'assets/images/rome.jpg'
  },
  {
    "city": 'London',
    "country": 'England',
    "rating": '4.5',
    'image': 'assets/images/london.jpg'
  },
];
List data_2 = [
  {"name": 'Flaye', 'image': 'assets/images/flaye.png'},
  {"name": 'Beach', 'image': 'assets/images/beach.png'},
  {"name": 'Park', 'image': 'assets/images/park.png'},
  {"name": 'Camp', 'image': 'assets/images/camp.png'},
  {"name": 'Flaye', 'image': 'assets/images/flaye.png'},
  {"name": 'Beach', 'image': 'assets/images/beach.png'},
  {"name": 'Park', 'image': 'assets/images/park.png'},
  {"name": 'Camp', 'image': 'assets/images/camp.png'},
];
final categoryList = ['Populare', 'Recommended', 'Most Viewd', 'Most Liked'];

// Colors
const kAvatarColor = Color(0xffffdbc9);
const kPrimaryColor = Color(0xFFEEF7FF);
const kSecondaryColor = Color(0xFF29303D);
```
### Configure
This page ensures that when the app starts up, it manages to connect to supabase. 

```
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants.dart';

Future configureApp() async {
  // init Supabase singleton
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnnonKey,
    authCallbackUrlHostname: 'login-callback',
    debug: true,
    localStorage: SecureLocalStorage(),
  );
}

// user flutter_secure_storage to persist user session
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage()
      : super(
          initialize: () async {},
          hasAccessToken: () {
            const storage = FlutterSecureStorage();
            return storage.containsKey(key: supabasePersistSessionKey);
          },
          accessToken: () {
            const storage = FlutterSecureStorage();
            return storage.read(key: supabasePersistSessionKey);
          },
          removePersistedSession: () {
            const storage = FlutterSecureStorage();
            return storage.delete(key: supabasePersistSessionKey);
          },
          persistSession: (String value) {
            const storage = FlutterSecureStorage();
            return storage.write(key: supabasePersistSessionKey, value: value);
          },
        );
}

```

### Constants
This page causes the keys to be retrieved so that a connection can be made to the database.

```
/// Environment variables and shared app constants.
abstract class Constants {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );
}

```

### Widgets
This causes widgets to appear in the app.
```
// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      // leading: Text(result.rssi.toString()),
      leading: Image.asset("assets/Images/ms.png"),
      trailing: ElevatedButton(
        child: const Text('CONNECT'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.black,
        ),
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
      children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data',
            getNiceManufacturerData(result.advertisementData.manufacturerData)),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData)),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile(
      {Key? key, required this.service, required this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.isNotEmpty) {
      return ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).textTheme.caption?.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return ListTile(
        title: const Text('Service'),
        subtitle:
        Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
        required this.characteristic,
        required this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))
              ],
            ),
            subtitle: Text(value.toString()),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;

  const DescriptorTile(
      {Key? key,
        required this.descriptor,
        this.onReadPressed,
        this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
        stream: descriptor.value,
        initialData: descriptor.lastValue,
        builder: (c, snapshot) => Text(snapshot.data.toString()),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onReadPressed,
          ),
          IconButton(
            icon: Icon(
              Icons.file_upload,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
            onPressed: onWritePressed,
          )
        ],
      ),
    );
  }
}

class AdapterStateTile extends StatelessWidget {
  const AdapterStateTile({Key? key, required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: ListTile(
        title: Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subtitle2,
        ),
        trailing: Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subtitle2?.color,
        ),
      ),
    );
  }
}
```

## Home page
This is how the home page is written. At this point there is not much to say about the home page. A piece of text has been added showing that the user is on the home page. More about the home page is coming soon!

```
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import material.dart file

class Home extends StatefulWidget { // Create Home class that extends StatefulWidget
  @override
  State<Home> createState() => _MyHomePageState(); // Override createState() method to return a new instance of _MyHomePageState
}

class _MyHomePageState extends State<Home> { // Create _MyHomePageState class that extends State and takes in a generic type of Home
  @override
  Widget build(BuildContext context) { // Override build() method to return a new Scaffold widget
    return Scaffold(
      appBar: CustomAppBar("Home"), // Set the app bar to a CustomAppBar widget with a title of "Home"
      body: Center(
        child: Text("Homepage"), // Set the body of the Scaffold to a Center widget that contains a Text widget with the text "Homepage"
      ),
    );
  }
}
```
## Bluetooth page
In the bluetooth page, the bluetooth is created so that the app can connect to the sensors. The bluetooth of the app can be turned on and off. In addition, there is a search function to search for sensors or other devices. Once a sensor is found, a connection can be made.

```
import 'dart:math';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth_find_device.dart';
import 'bluetooth_off_page.dart';
import '../widgets.dart';

class Bluetooth extends StatelessWidget {
  const Bluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Bluetooth"),
      body: Container(
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBluePlus.instance.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                return const FindDevicesScreen();
              }
              return BluetoothOffScreen(state: state);
            }),
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () => c.read(),
            onWritePressed: () async {
              await c.write(_getRandomBytes(), withoutResponse: true);
              await c.read();
            },
            onNotificationPressed: () async {
              await c.setNotifyValue(!c.isNotifying);
              await c.read();
            },
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () => d.read(),
                onWritePressed: () => d.write(_getRandomBytes()),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    snapshot.data == BluetoothDeviceState.connected
                        ? const Icon(Icons.bluetooth_connected)
                        : const Icon(Icons.bluetooth_disabled),
                    snapshot.data == BluetoothDeviceState.connected
                        ? StreamBuilder<int>(
                        stream: rssiStream(),
                        builder: (context, snapshot) {
                          return Text(snapshot.hasData ? '${snapshot.data}dBm' : '',
                              style: Theme.of(context).textTheme.caption);
                        })
                        : Text('', style: Theme.of(context).textTheme.caption),
                  ],
                ),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      const IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: const Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: const [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> rssiStream() async* {
    var isConnected = true;
    final subscription = device.state.listen((state) {
      isConnected = state == BluetoothDeviceState.connected;
    });
    while (isConnected) {
      yield await device.readRssi();
      await Future.delayed(const Duration(seconds: 1));
    }
    subscription.cancel();
    // Device disconnected, stopping RSSI stream
  }
}
```

### Bluetooth off Page
This page is for the colors used in the bluetooth page. In addition, the style is also formatted neatly here. 

```
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromRGBO(43, 126, 189, 1),
              Color.fromRGBO(33, 142, 203, 1),
              Color.fromRGBO(21, 160, 220, 1),
              Color.fromRGBO(14, 172, 230, 1),
              Color.fromRGBO(6, 185, 241, 1),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.bluetooth,
              size: MediaQuery.of(context).size.width * 0.15,
              color: Colors.white,
            ),
            Column(
              children: <Widget>[
                Text(
                  'Connect',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white, fontSize: 40),
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    'to any movesense sensor nearby you',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextButton(
                  child: const Text('TURN ON',
                      style: TextStyle(color: Colors.orange)),
                  onPressed: Platform.isAndroid
                      ? () => FlutterBluePlus.instance.turnOn()
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

```

### Bluetooth find device page
This page allows for a device search. SO a connection can be made with the movesens, to collect the data for the heartbeat page.

```
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth_page.dart';
import '../widgets.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
          actions: [
            ElevatedButton(
              child: const Text('TURN OFF'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.instance.turnOff()
                  : null,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => FlutterBluePlus.instance
              .startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 2)).asyncMap(
                      (_) => FlutterBluePlus.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(children: [
                    Column(children: [ListTile(title: Text("Connected Devices: " + snapshot.data!.length.toString() ))],),
                    Column(
                      children: snapshot.data!
                          .map((d) => ListTile(
                                leading: Image.asset("assets/Images/ms.png"),
                                title: Text(d.name),
                                subtitle: Text(d.id.toString()),
                                trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: d.state,
                                  initialData:
                                      BluetoothDeviceState.disconnected,
                                  builder: (c, snapshot) {
                                    if (snapshot.data ==
                                        BluetoothDeviceState.connected) {
                                      return ElevatedButton(
                                        child: const Text('OPEN'),
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    DeviceScreen(device: d))),
                                      );
                                    } else if (snapshot.data ==
                                        BluetoothDeviceState.disconnected) {
                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                            title: Text("Disconnected"),
                                            content: Text(
                                                "Bluetooth device disconnected"),
                                            alignment: Alignment.center),
                                        clipBehavior: Clip.none,
                                      );
                                    }
                                    return Text(snapshot.data.toString());
                                  },
                                ),
                              ))
                          .toList(),
                    )
                  ]),
                ),
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.instance.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map(
                          (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              r.device.connect();
                              return DeviceScreen(device: r.device);
                            })),
                          ),
                        )
                        .where((foundDevice) => foundDevice.result.device.name
                            .contains("Movesense"))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.zero,
          // padding: EdgeInsets.only(bottom: screenHeight * 0.2),
          child: StreamBuilder<bool>(
            stream: FlutterBluePlus.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data!) {
                return FloatingActionButton(
                  child: const Icon(Icons.stop),
                  onPressed: () => FlutterBluePlus.instance.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                    child: const Icon(Icons.search),
                    onPressed: () => FlutterBluePlus.instance
                        .startScan(timeout: const Duration(seconds: 4)));
              }
            },
          ),
        ));
  }
}
```

## Current session page
On the current page there is a button that causes the session to be started. Pressing this button redirects the user to the heartbeat page. 

```
import 'package:app/HeartbeatData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `Current`
class Current extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const Current ({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing an `ElevatedButton`
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Current"),
      body: Center(
          child: ElevatedButton(
              // When the button is pressed, it will navigate to the `HeartBeatPage`
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HeartBeatPage()));
              },
              // The button will have the text "Start session"
              child: Text('Start session'),
            // The button's style is set to a background color of black
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
          ),

      ),
    ); //
  }
}


```

### Heartbeat data
In the heartbeat page, a session is started when the user has pressed the start button. The graph shows the processed data. In this case, it is the heartbeat. The data is written in a script. This script is read and eventually the data is fed to a database. If the session needs to be stopped, the user can click on stop session. The user is then navigated to the current page.

```
import 'dart:convert';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'models.dart';

const String SERVER = 'https://team-nl-iot-2022.onrender.com/';
const int MAX_GRAPH_VALUES = 30;

List<FlSpot> heartBeatList = [];
int index = 0;
Timer? fakeDataTimer;
List<dynamic> subscriptions = [];

List<OutputValue> initOutputValues(jsonValues) {
  List<OutputValue> outputValues = [];
  jsonValues.forEach((item) =>
      outputValues.add(OutputValue(item['value'], item['timestamp'])));

  return outputValues;
}

Timer startSendingFakeData(IO.Socket socket, int sessionId) {
  print('starting fake data for session session: ${sessionId}');
  Random random = new Random();

  return Timer.periodic(Duration(milliseconds: 100), (Timer t) {
    int heartBeat = 40 + random.nextInt(150 - 40);
    socket.emit(
        'data-point',
        jsonEncode({
          'value': heartBeat,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        }));
  });
}

// retrieve all script_outputs of given session
// and initialise values
Future<List<ScriptOutput>> getOutputs(int sessionId) async {
  final supabase = Supabase.instance.client;
  final sessionOutputs = await supabase
      .from('sessions')
      .select(
      'script_outputs( id, scripts( id, name, description, output_type, output_name ) )')
      .eq('id', sessionId)
      .single();

  List<ScriptOutput> scriptOutputs = [];

  sessionOutputs['script_outputs'].forEach((record) {
    scriptOutputs.add(ScriptOutput(
        record['id'],
        Script(
            record['scripts']['id'],
            record['scripts']['name'],
            record['scripts']['description'],
            record['scripts']['output_type'],
            record['scripts']['output_name']),
        []));
  });

  return scriptOutputs;
}

// start session by opening a websocket
Future<void> createSession(Function callback) async {
  IO.Socket socket = IO.io(SERVER, <String, dynamic>{
    'path': '/socket.io',
    'autoConnect': false,
    'transports': ['websocket'],
  });
  socket.connect();
  socket.onConnect((_) {
    print('Connection established');
  });
  socket.onDisconnect((_) => print('Connection Disconnection'));
  socket.onConnectError((err) => print('onConnectError: ${err}'));
  socket.onError((err) => print('onError: ${err}'));

  // session started, start retrieving outputs
  socket.on(
      'sessionId',
          (sessionId) async => {
        print('started session: ${sessionId}'),
        callback(await getOutputs(sessionId)),
        fakeDataTimer = startSendingFakeData(socket, sessionId),
      });
}

class HeartBeatPage extends StatefulWidget {
  const HeartBeatPage({super.key});

  @override
  State<HeartBeatPage> createState() => _HeartBeatPageState();
}

class _HeartBeatPageState extends State<HeartBeatPage> {
  List<ScriptOutput> outputs = [];

  @override
  void initState() {
    super.initState();
    createSession((List<ScriptOutput> sessionOutputs) => setState(() {
      outputs = sessionOutputs;
    }));
  }

  @override
  void dispose() {
    // stop sending fake data before diposing of page
    fakeDataTimer?.cancel();
    // cancel all database subscriptions
    subscriptions.forEach((subscribtion) {
      subscribtion.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Stack(
        children: [
          ListView(
            children: outputs.map((output) => Output(output: output)).toList(),

            //Add extra data widget here with a button title
            // children: [
            //   DropDownBar("HeartBeat", HeartBeatData()),
            //   DropDownBar('HeartBeat2', HeartBeatData()),
            //   RetrievedDataSection()
            // ],
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: ElevatedButton(
                  onPressed: () {
                    //navigate to the current page
                    Navigator.pop(context);
                  },
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text('Stop session')),
            ),
          )
        ],
      ),
    );
  }
}

class Output extends StatefulWidget {
  const Output({Key? key, required this.output}) : super(key: key);
  final ScriptOutput output;

  @override
  State<Output> createState() => _Output();
}

class _Output extends State<Output> {
  List<OutputValue> values = [];

  void subscribeToData() async {
    final supabase = Supabase.instance.client;
    final subscription = await supabase
        .from('script_outputs')
        .stream(primaryKey: ['id'])
        .eq('id', widget.output.id)
        .listen((List<Map<String, dynamic>> data) {
      if (!data.isEmpty) {
        setState(() {
          final int start = data[0]['values'].length - MAX_GRAPH_VALUES;
          final range = data[0]['values']
              .getRange(start >= 0 ? start : 0, data[0]['values'].length);
          values = initOutputValues(range);
        });
      }
    });
    // add to subscritions so that subscription can be cancled on page dispaose
    subscriptions.add(subscription);
  }

  @override
  void initState() {
    super.initState();
    subscribeToData();
  }

  @override
  Widget build(BuildContext context) {
    return DropDownBar(
        widget.output.script.name,
        HeartBeatData(
            outputName: widget.output.script.outputName, values: values));
  }
}

class DropDownBar extends StatefulWidget {
  final String title;
  final Widget dataWidget;
  const DropDownBar(this.title, this.dataWidget);
  _DropDownBarState createState() => _DropDownBarState();
}

class _DropDownBarState extends State<DropDownBar> {
  bool showData = true;
  Widget build(BuildContext context) {
    Widget showWidget = widget.dataWidget;
    showWidget = showData ? widget.dataWidget : Container();
    return Center(
      child: Column(children: <Widget>[Bar(context), showWidget]),
    );
  }

  Widget Bar(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      fixedSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width * 0.1),
      backgroundColor: Colors.grey,
    );
    return Center(
      child: ElevatedButton(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 20.0),
        ),
        style: style,
        onPressed: () {
          setState(() {
            showData = showData ? false : true;
          });
        },
      ),
    );
  }
}

class HeartBeatData extends StatelessWidget {
  final String outputName;
  final List<OutputValue> values;
  const HeartBeatData({required this.outputName, required this.values});

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          HeartBeatDataText(
            name: outputName,
            lastValue: values.isEmpty ? null : values.last,
          ),
          HeartBeatDataGraph(values: values)
        ],
      ),
    );
  }
}

class HeartBeatDataText extends StatelessWidget {
  final String name;
  final OutputValue? lastValue;
  const HeartBeatDataText({required this.name, required this.lastValue});

  // _HeartBeatState createState() => _HeartBeatState();

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: new Text('Last ${name} = ${lastValue?.value}'),
      ),
    );
  }
}

// class _HeartBeatState extends State<HeartBeatDataText> {
//   int heartBeat = 0;
//   late Timer update;
//   Random random = new Random();

//   @override
//   void initState() {
//     super.initState();
//     update = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
//       setState(() {
//         heartBeat = 40 + random.nextInt(150 - 40);
//         heartBeatList.add(FlSpot(index.toDouble(), heartBeat.toDouble()));
//         if (heartBeatList.length > 30) heartBeatList.removeAt(0);
//         index++;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: new Text('HeartBeat = ' + heartBeat.toString()),
//       ),
//     );
//   }
// }

// class HeartBeatDataGraph extends StatefulWidget {
class HeartBeatDataGraph extends StatelessWidget {
  final List<OutputValue> values;
  const HeartBeatDataGraph({super.key, required this.values});

//   @override
//   State<HeartBeatDataGraph> createState() => _HeartBeatDataGraphState();
// }

// class _HeartBeatDataGraphState extends State<HeartBeatDataGraph> {
  static List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  static bool showAvg = false;
//   late Timer update;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     update = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
//       setState(() {});
//     });
//   }

  List<FlSpot> getSpots() => values
      .map(
          (value) => FlSpot(value.timestamp.toDouble(), value.value.toDouble()))
      .toList();

  @override
  Widget build(BuildContext context) {
    // List<FlSpot> spots = this.values.map((value) => FlSpot(value.timestamp.toDouble(), value.value)).toList();

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              color: Color(0xff232d37),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 0,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\ ${value}',
        style: style,
      ),
      space: 8.0,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\ ${value}', style: style),
    );
  }

  LineChartData mainData() {
    final spots = getSpots();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 10,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}

```
### Models
This code ensures that the scripts enter the app in the best possible way. This way we prevent bugs in the system. The script comes in as a JSON. 

```
class Script {
  int id;// ID of the script
  String name; // Name of the script
  String? description;
  String outputType; // bar_chart || line_chart
  String outputName; // Display name of the value

  Script(
      this.id, this.name, this.description, this.outputType, this.outputName);
}

class OutputValue {
  dynamic value; // The output value
  int timestamp; // Timestamp for when the value was generated

  OutputValue(this.value, this.timestamp);
}

class ScriptOutput {
  int id; // ID of the script output
  Script script; // The script that generated the output
  List<OutputValue>? values; // List of output values generated by the script

  ScriptOutput(this.id, this.script, this.values);
}

```
## Sessions history page
A page has been created for the sessions history. The page now contains only a text with Sessions History. There will be more on this page soon.

```
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `History`
class History extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const History({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing text that reads "Sessions History"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("History"),
      body: Center(
        child: Text("Sessions History")
      ),
    ); //
  }
}
```