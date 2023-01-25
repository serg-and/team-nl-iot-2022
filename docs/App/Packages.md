# Packages

In this page shows all the packages used in the project, with a link to the documentation and why we
use it.

## Bluetooth "mdsflutter" and flutter_reactive_ble

flutter_reactive_ble version: 5.03 mdsflutter version: own fork
of [petri lipponen-movesense](https://github.com/petri-lipponen-movesense/mdsflutter)

For the bluetooth package we have used flutter_reactive_ble. Flutter Reactive BLE is a Flutter
package that allows you to work with Bluetooth Low Energy devices. It provides a reactive interface
for connecting, scanning, and reading/writing to BLE peripherals. The package is a well-designed and convenient
tool for building Flutter apps that interact with BLE devices. It provides a reactive interface,
convenient methods, and good documentation, making it a good choice for developers looking to build
BLE apps with Flutter. Also, this package has been well tested by the developers and is regularly updated and worked on.

Also we have used the mdsflutter package. However we needed to fork this package and make some
changes since this package is not maintained in a long time. The for we have used can be
found [here](https://github.com/Berkanozc/mdsflutter)

mdsflutter is a package for Flutter, an open-source mobile application development framework created
by Google. It provides a set of custom widgets and helper classes for building Material
Design-themed apps. Material Design is a design system developed by Google that provides a
consistent look and feel across multiple platforms, including Android, iOS, and the web.

The mdsflutter package includes a variety of custom widgets and helper classes that can be used to
build Material Design-themed apps with Flutter. Some of the features provided by the package
include:

Customized versions of common Flutter widgets, such as buttons, cards, and sliders, that are styled
to match the Material Design guidelines Classes for handling common Material Design tasks, such as
creating app bars, handling drawer navigation, and displaying dialogs A set of pre-designed themes
that can be applied to an entire app or to individual widgets, allowing developers to easily
customize the appearance of their app To use the mdsflutter package, you will need to add it as a
dependency in your Flutter project's pubspec.yaml file and import it into your code. You can then
use the custom widgets and helper classes provided by the package to build your Material
Design-themed app.

## Data visualization "Fl_chart"

Version: 0.55.2

[Fl_chart](https://pub.dev/packages/fl_chart) is used to visualize data in flutter. Its a free to
use package, that overs a lot of customizability. It makes use of FlSpots as data point wich are
like a 2D-Vector, this makes it very easy to implement. The package offers a wide range of different
ways to visualize data. 

## Smooth page indicator

Version: 1.0.0+2

The package "smooth_page_indicator" in Flutter is used to create a customizable and smooth page indicator that can be used to indicate the current page in a page view. It allows for a wide range of customization options, such as changing the shape and color of the indicators, and provides smooth animations when transitioning between pages.

It's used for the onboarding pages.

## Shared Preferences

Version: 2.0.12

The package "shared_preferences" in Flutter allows developers to easily save and retrieve key-value data in an app's local storage. This can be useful for storing small amounts of data such as user preferences, login credentials, or cached data that should persist even when the app is closed. The package provides a simple API for reading and writing data, and the saved data is persistent across app launches. It is easy to use and can be used for storing small set of data that needs to be persistent.