// String baseUrlV1_0 = "http://10.0.2.2:5000";
// String baseUrlV1_0 = "http://127.0.0.1:5000";
String baseUrlV1_0 = "https://flutterfly.nl";

String apiUrlV1_0 = "$baseUrlV1_0/api/v1.0/";

String githubLogin = "$baseUrlV1_0/login/github";
String googleLogin = "$baseUrlV1_0/login/google";
String redditLogin = "$baseUrlV1_0/login/reddit";

// deploy to server:
// (flutter clean)
// flutter build web --web-renderer=canvaskit
// this creates the 'build/web' folder
// archive contents (compress) => flutterfly.zip
// move zip to server (in de juiste nginx folder)
// scp /home/zwaar/ZwaarProjects/FlutterFly/FlutterFly/build/web/flutterfly.zip root@flutterfly.nl:/var/www/flutterfly.nl/html/flutterfly.zip
// unzip het op de server (in de juiste nginx folder):
// (sudo apt-get install unzip)
// remove existing index.html (or existing flutter thing)
// unzip flutterfly.zip -d /var/www/flutterfly.nl/html
// or in the folder
// unzip flutterfly.zip -d .


// deploy to play store (android):
// flutter build appbundle
// this creates the 'build/app/outputs/bundle/release/app-release.aab'
// upload to play store
// on the developer play store go to flutterfly and then releases overview
// create new release


