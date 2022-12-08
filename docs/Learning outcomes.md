#Learning outcomes
##Jointly upload flutter app in Android studio
Each team member installed the package flutter. As the next step, we all downloaded Android studio. In this we are going to build the application. Berkan created an application, in which we can sit on the app together. Each team member added the application on a local drive on their laptop. Then in File at open we added the application. Now everyone can work on the application.

##Splashscreen
When the app is started, a splashscreen is displayed. The TeamNL logo is used for this. 

##Homepage 
In the app there is first a home page. In the home page, the appbar is displayed with text TeamNL. The appbar itself has been given an orange color. Later this week the logo will be designed, the settings button will be applied and the navigation bar will be displayed in the home page. 

##Settings

##Logo
The logo was created in the program Figma. Then in the assets folder under images the logo Sens_TeamNL.jpg was added. In the folder pubspec.yaml there are two lines that ensure that the logo is displayed on the background of a Samsung or Iphone phone. The code is below. 

dev_dependencies:
flutter_launcher_icons:"^0.11.0"
flutter_test:
sdk: flutter

flutter_icons:
android: true
ios: true
image_path: "assets/Images/Sens_TeamNL.jpg"

##Navigation Bar 
Built into the home.page.dart is a navigation bar, where there are three buttons to navigate to. There are home, current session and sessions history buttons created, which are represented by an icon. Items are displayed with the color white. The navigation bar is colored black. Four icons have been added. These icons are navigated to home page, bluetooth page, current session and sessions history.

##Navigating to session history
Currently, a new page has been created for session history. The page currently only has a piece of text added. In the navigation bar, an icon has been added with session history. When the icon is clicked, the user will be sent to the session history page.

##Navigate to current session
A new page has been created with the current session. Currently, the page displays text with current session. The navigation bar now shows all four options, to where to navigate.

##Start current session
A button has been added on the current page that causes a session to be started. When the user clicks the button, the user starts a session where the heartbeat is measured. This is then displayed in the graph. 

##stop session button
On the heartbeat page, a stop session button has been added. If the user wants to stop the session, this button can be pressed. The user is then returned to the current page.
