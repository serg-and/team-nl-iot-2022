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

## Flutter Native Splash

Version 2.2.15

The package "Flutter Native Splash" is a Flutter package that allows you to add native splash screens to your Flutter apps for both iOS and Android. This package provides a seamless transition between your app's loading screen and the first Flutter screen, providing a better user experience.

## 

Version 0.2.1

The package "Ionicons" is a Flutter package that provides access to the Ionicons icon library. Ionicons is a set of over 700 open-source icons that can be used in your Flutter app. You can use these icons to enhance the visual appearance of your app, add additional context to elements, or simply make your app look more polished. With this package, you can easily access the icons in the Ionicons library and incorporate them into your Flutter app.

## supabase_flutter

Version 1.2.2

The package "Supabase Flutter" is a Flutter package that provides a simple and convenient way to interact with the Supabase API in your Flutter app. Supabase is a backend as a service (BaaS) platform that provides real-time databases, user authentication, and serverless functions. With the Supabase Flutter package, you can access Supabase functionality from within your Flutter app, making it easier to build apps that interact with a backend. This package can help simplify the process of integrating Supabase into your app, allowing you to focus on building your app's functionality instead of dealing with low-level API details.

## jiffy

Version 5.0.0

The package "jiffy" is a Flutter package that provides a comprehensive DateTime library for Dart. It provides a number of useful functions for working with dates and times, such as parsing strings into dates, formatting dates into strings, performing date arithmetic, and more. Jiffy also supports multiple languages, making it easy to display dates and times in a way that is appropriate for the user's locale. With Jiffy, you can easily perform common date and time operations in your Flutter app, without having to write your own code or use multiple libraries.

## filter_list

Version 1.0.2

The package "filter_list" is a Flutter package that provides a simple and efficient way to filter a list of items. With this package, you can quickly and easily filter a list of items based on user input, making it easy to implement search functionality in your app. The package provides a widget that you can use to filter a list of items, and it automatically updates the list in real-time as the user types. This package can help you implement search functionality in your app quickly and easily, without having to write a lot of custom code.

## permission_handler

Version 10.2.0

The package "permission_handler" is a Flutter package that provides a simple and convenient way to handle runtime permissions in your Flutter app. With this package, you can request permissions, check their status, and handle the results of the request, all from within your Flutter code. The package provides a simple and consistent API for working with permissions, making it easy to implement this functionality in your app. This package can help you ensure that your app is able to request the permissions it needs, while also making it easy to handle the results of those requests.

## provider

Version 6.0.4

The package "provider" is a Flutter package that provides a simple and efficient way to manage state in your Flutter app. It provides a way to store and manage app state in a central location, making it easier to build and maintain your app. With provider, you can easily access and update the state from anywhere in your app, and you can use a single provider or a combination of providers to manage different parts of your state. This package can help you manage your state in a way that is simple, efficient, and scalable, making it easier to build and maintain your Flutter app.