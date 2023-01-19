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
    //The color of the background container
    required Color color,
    //The asset path of the image to be displayed
    required String urlImage,
    //The title text to be displayed
    required String title,
    //The subtitle text to be displayed
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              //Scales the image down while maintaining its aspect ratio
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
        //Padding for the bottom of the container
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          //Updates the state when the page changes
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
                color: Colors.white,
                //The asset path of the image to be displayed
                urlImage: 'assets/onboardingscreen/connect.png',
                //The title text to be displayed
                title: "Connect with the sensor",
                //The subtitle text to be displayed
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
