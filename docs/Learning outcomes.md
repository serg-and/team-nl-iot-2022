##Joint flutter app upload in Android studio
Each team member installed the package flutter. As a next step, we all downloaded Android studio. In this we are going to build the application. Berkan created an application, in which we can collectively sit on the app.  Each team member added the application on a local disk on their laptop. Then in File at open, we added the application. Now everyone can work on the application.

##Homepage (Rosario)
Today I set up the homepage. I did this by means of YouTube videos. In the app bar I have put the big text TeamNL. In the middle of the page I put the text Home page. So it is clear that this is the homepage. The design of this page will come later in this sprint. The color that I used for the app bar is

##Logo (Rosario)
Logo was created in the program Figma. Then, in the assets folder under images, the Sens_TeamNL.jpg logo was added. In the folder pubspec.yaml I programmed with two lines, that the logo is displayed on the background of a Samsung or Iphone phone. The code is below. 


dev_dependencies:
  flutter_launcher_icons:"^0.11.0"
  flutter_test:
    sdk: flutter

flutter_icons:
  android: true
  ios: true
  image_path: "assets/Images/Sens_TeamNL.jpg"

##Navigation bar (Rosario)
In the home.page.dart there is a navigation bar built in, where there are three buttons to navigate to. There are home, current session and sessions history buttons created, which are represented by an icon. For formatting purposes I have given the items the color white. When a button is selected it turns black and the background of the bar is orange. 

##Navigating to Sessions History
Currently, I have created a new page for the sessions history. In the page at the moment only a piece of text has been added. In the navigation bar, an icon has been added with sessions history. When the icon is clicked, the user is sent to the sessions history page.

##Navigating to Current Session
Liam created the current session page. I myself added an icon via the navigation bar so that the current session page can be navigated to. In the current session page you can see the heart rate in a graph.  