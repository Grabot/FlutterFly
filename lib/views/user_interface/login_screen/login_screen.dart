import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfly/constants/url_base.dart';
import 'package:flutterfly/game/flutter_fly.dart';
import 'package:flutterfly/models/rest/login_request.dart';
import 'package:flutterfly/models/rest/register_request.dart';
import 'package:flutterfly/services/rest/auth_service_login.dart';
import 'package:flutterfly/util/box_window_painter.dart';
import 'package:flutterfly/util/change_notifiers/login_screen_change_notifier.dart';
import 'package:flutterfly/util/change_notifiers/score_screen_change_notifier.dart';
import 'package:flutterfly/util/util.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/change_notifiers/loading_box_change_notifier.dart';
import '../../../util/change_notifiers/web_view_box_change_notifier.dart';

class LoginScreen extends StatefulWidget {

  final FlutterFly game;

  const LoginScreen({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool showLoginScreen = false;

  late LoginScreenChangeNotifier loginScreenChangeNotifier;

  bool normalMode = true;
  bool isLoading = false;

  int signUpMode = 0;
  bool passwordResetSend = false;

  final formKeyLogin = GlobalKey<FormState>();
  final formKeyReset = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    loginScreenChangeNotifier = LoginScreenChangeNotifier();
    loginScreenChangeNotifier.addListener(loginScreenChangeListener);
    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkTopBottomScroll() {
    if (_controller.hasClients) {
      double distanceToBottom =
          _controller.position.maxScrollExtent -
              _controller.position.pixels;
      double distanceToTop =
          _controller.position.minScrollExtent -
              _controller.position.pixels;
      if (distanceToBottom != 0) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() {showBottomScoreScreen = false;}));
      } else {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() {showBottomScoreScreen = true;}));
      }
      if (distanceToTop != 0) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() {showTopScoreScreen = false;}));
      } else {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() {showTopScoreScreen = true;}));
      }
    }
  }

  goBack() {
    setState(() {
      LoginScreenChangeNotifier().setLoginScreenVisible(false);
      widget.game.focusGame();
    });
  }

  signInFlutterFly() {
    if (formKeyLogin.currentState!.validate() && !isLoading) {
      _controller.jumpTo(0);
      isLoading = true;
      // send login request
      String emailOrUserName = emailOrUsernameController.text;
      String password = password1Controller.text;
      AuthServiceLogin authServiceLogin = AuthServiceLogin();
      bool isWeb = false;
      if (kIsWeb) {
        isWeb = true;
      }
      LoginRequest loginRequest = LoginRequest(emailOrUserName, password, isWeb);
      authServiceLogin.getLogin(loginRequest).then((loginResponse) {
        if (loginResponse.getResult()) {
          ScoreScreenChangeNotifier().notify();
          goBack();
          isLoading = false;
          setState(() {});
        } else if (!loginResponse.getResult()) {
          showToastMessage(loginResponse.getMessage());
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        isLoading = false;
      });
    }
  }

  signUpFlutterFly() {
    if (formKeyRegister.currentState!.validate() && !isLoading) {
      _controller.jumpTo(0);
      isLoading = true;
      String email = emailController.text;
      String userName = usernameController.text;
      String password = password2Controller.text;
      AuthServiceLogin authService = AuthServiceLogin();
      bool isWeb = false;
      if (kIsWeb) {
        isWeb = true;
      }
      RegisterRequest registerRequest = RegisterRequest(email, userName, password, isWeb);
      authService.getRegister(registerRequest).then((loginResponse) {
        if (loginResponse.getResult()) {
          ScoreScreenChangeNotifier().notify();
          goBack();
          isLoading = false;
          setState(() {});
        } else if (!loginResponse.getResult()) {
          showToastMessage(loginResponse.getMessage());
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        isLoading = false;
      });
    }
  }

  String resetEmail = "";
  forgotPassword() {
    if (formKeyReset.currentState!.validate() && !isLoading) {
      _controller.jumpTo(0);
      isLoading = true;
      resetEmail = forgotPasswordEmailController.text;
      AuthServiceLogin authService = AuthServiceLogin();
      authService.getPasswordReset(resetEmail).then((passwordResetResponse) {
        if (passwordResetResponse.getResult()) {
          setState(() {
            passwordResetSend = true;
          });
          isLoading = false;
        } else if (!passwordResetResponse.getResult()) {
          showToastMessage(passwordResetResponse.getMessage());
          resetEmail = "";
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        resetEmail = "";
        isLoading = false;
      });
    }
  }

  loginScreenChangeListener() {
    if (mounted) {
      if (!showLoginScreen && loginScreenChangeNotifier.getLoginScreenVisible()) {
        setState(() {
          showLoginScreen = true;
        });
      }
      if (showLoginScreen && !loginScreenChangeNotifier.getLoginScreenVisible()) {
        setState(() {
          showLoginScreen = false;
          signUpMode = 0;
          passwordResetSend = false;
        });
      }
    }
  }

  Widget loginAlternatives(double loginBoxSize, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: const Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
              signUpMode == 0 ? Text(
                "or login with",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize
                ),
              ) : Container(),
              signUpMode == 1 ? Text(
                "or register with",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize
                ),
              ) : Container(),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: const Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
            ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                children: [
                  InkWell(
                    onTap: () {
                      _handleSignInGoogle();
                    },
                    child: SizedBox(
                      height: loginBoxSize,
                      width: loginBoxSize,
                      child: Image.asset(
                          "assets/images/google_button.png"
                      ),
                    ),
                  ),
                  Text(
                    "Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize
                    ),
                  )
                ]
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    _handleSignInApple();
                  },
                  child: SizedBox(
                    height: loginBoxSize,
                    width: loginBoxSize,
                    child: Image.asset(
                        "assets/images/apple_button.png"
                    ),
                  ),
                ),
                Text(
                  "Apple",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize
                  ),
                )
              ],
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    final Uri url = Uri.parse(githubLogin);
                    _launchUrl(url);
                  },
                  child: SizedBox(
                    height: loginBoxSize,
                    width: loginBoxSize,
                    child: Image.asset(
                        "assets/images/github_button.png"
                    ),
                  ),
                ),
                Text(
                  "Github",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize
                  ),
                )
              ],
            ),
            const SizedBox(width: 10),
            Column(
                children: [
                  InkWell(
                    onTap: () {
                      final Uri url = Uri.parse(redditLogin);
                      _launchUrl(url);
                    },
                    child: SizedBox(
                      height: loginBoxSize,
                      width: loginBoxSize,
                      child: Image.asset(
                          "assets/images/reddit_button.png"
                      ),
                    ),
                  ),
                  Text(
                    "Reddit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize
                    ),
                  )
                ]
            ),
          ],
        ),
      ],
    );
  }

  Widget resetPasswordEmailSend(double width, double fontSize) {
    return Column(
      children: [
        Text(
          "Check your email",
          style: TextStyle(color: Colors.white, fontSize: fontSize*2),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              "Please check the email address $resetEmail for instructions to reset your password. \nThis might take a few minutes",
              style: TextStyle(color: Colors.white70, fontSize: fontSize),
            ),
          ]
        ),
      ],
    );
  }

  Widget resetPassword(double width, double fontSize) {
    return Form(
      key: formKeyReset,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reset your password",
                  style: TextStyle(color: Colors.white, fontSize: fontSize*1.5),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
                children: [
                  Text(
                    "Enter your email address and we will send you instructions to reset your password.",
                    style: TextStyle(color: Colors.white70, fontSize: fontSize),
                  ),
                ]
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                onTap: () {

                },
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Please provide an Email address"
                      : null;
                },
                onFieldSubmitted: (value) {
                  if (!isLoading) {
                    forgotPassword();
                  }
                },
                scrollPadding: const EdgeInsets.only(bottom: 130),
                controller: forgotPasswordEmailController,
                autofillHints: const [AutofillHints.email],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: fontSize,
                    color: Colors.white
                ),
                decoration:
                textFieldInputDecoration("Email adddress"),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 0;
                            });
                          }
                        },
                        child: Text(
                          "Back to login",
                          style: TextStyle(color: Colors.yellowAccent, fontSize: fontSize),
                        )
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  forgotPassword();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Continue',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget register(double width, double fontSize) {
    return Form(
      key: formKeyRegister,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 0;
                            });
                          }
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: fontSize*0.8
                          ),
                        )
                    ),
                    Text(
                        " instead?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize*0.8
                        )
                    )
                  ],
                ),
              ],
            ),
            TextFormField(
              onTap: () {

              },
              validator: (val) {
                if (val != null) {
                  if (!emailValid(val)) {
                    return "Email not formatted correctly";
                  }
                }
                return val == null || val.isEmpty
                    ? "Please provide an Email"
                    : null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 200),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Email"),
            ),
            TextFormField(
              onTap: () {

              },
              validator: (val) {
                if (val != null) {
                  if (emailValid(val)) {
                    return "username cannot be formatted as an email";
                  }
                }
                return val == null || val.isEmpty
                    ? "Please provide a username"
                    : null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 150),
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.username],
              controller: usernameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Username"),
            ),
            TextFormField(
              onTap: () {

              },
              obscureText: true,
              validator: (val) {
                return val == null || val.isEmpty
                    ? "Please provide a password"
                    : null;
              },
              onFieldSubmitted: (value) {
                if (!isLoading) {
                  signUpFlutterFly();
                }
              },
              scrollPadding: const EdgeInsets.only(bottom: 100),
              controller: password2Controller,
              autofillHints: const [AutofillHints.newPassword],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Password"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  signUpFlutterFly();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Create free account',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget login(double width, double fontSize) {
    return Form(
      key: formKeyLogin,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 1;
                            });
                          }
                        },
                        child: Text(
                          "Create new Account",
                          style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: fontSize*0.8
                          ),
                        )
                    ),
                    Text(
                        " instead?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize*0.8
                        )
                    )
                  ],
                ),
              ],
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    onTap: () {

                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Please provide an Email or Username"
                          : null;
                    },
                    focusNode: _focusEmail,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.username
                    ],
                    textInputAction: TextInputAction.next,
                    controller: emailOrUsernameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: fontSize,
                        color: Colors.white
                    ),
                    decoration:
                    textFieldInputDecoration("Email or Username"),
                  ),
                  TextFormField(
                    onTap: () {

                    },
                    onFieldSubmitted: (value) {
                      if (!isLoading) {
                        signInFlutterFly();
                      }
                    },
                    obscureText: true,
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Please provide a password"
                          : null;
                    },
                    scrollPadding: const EdgeInsets.only(bottom: 110),
                    focusNode: _focusPassword,
                    autofillHints: const [AutofillHints.password],
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    controller: password1Controller,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: fontSize,
                        color: Colors.white
                    ),
                    decoration:
                    textFieldInputDecoration("Password"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 2;
                            });
                          }
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.yellowAccent, fontSize: fontSize*0.8),
                        )
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  signInFlutterFly();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Login',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget loginHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          IconButton(
              icon: const Icon(Icons.close),
              color: Colors.orangeAccent.shade200,
              onPressed: () {
                setState(() {
                  goBack();
                });
              }
          ),
        ]
    );
  }

  Widget justPlayTheGame(double width, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: const Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
              Text(
                "or",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize
                ),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: const Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
            ]
        ),
        ElevatedButton(
          onPressed: () {
            goBack();
          },
          style: buttonStyle(false, Colors.blue),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 50,
            child: Text(
              'Just Play The Game',
              style: simpleTextStyle(fontSize),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginScreen(double width, double loginBoxSize, double fontSize) {
    return NotificationListener(
        child: SingleChildScrollView(
          controller: _controller,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                loginHeader(width, 40, fontSize),
                flutterFlyLogo(width, normalMode),
                signUpMode == 0 ? login(width - (30 * 2), fontSize) : Container(),
                signUpMode == 1 ? register(width - (30 * 2), fontSize) : Container(),
                signUpMode == 2 && !passwordResetSend ? resetPassword(width - (30 * 2), fontSize) : Container(),
                signUpMode == 2 && passwordResetSend ? resetPasswordEmailSend(width - (30 * 2), fontSize) : Container(),
                signUpMode != 2 ? loginAlternatives(loginBoxSize, fontSize) : Container(),
                justPlayTheGame(width - (30 * 2), fontSize),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        onNotification: (t) {
          checkTopBottomScroll();
          return true;
        }
    );
  }

  Widget loginOrRegisterBox(double screenWidth, double screenHeight, double fontSize) {
    normalMode = true;
    double loginBoxSize = 100;
    double width = 800;
    double height = (screenHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    if (screenWidth <= 800 || screenHeight > screenWidth) {
      width = screenWidth - 50;
      normalMode = false;
      loginBoxSize = 50;
    }
    return Align(
      alignment: FractionalOffset.center,
      child: showLoginScreen ? SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
              painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
              child: loginScreen(width, loginBoxSize, fontSize))
      ) : Container(),
    );
  }

  Widget loginOrRegisterScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = 16;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  goBack();
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(),
                      loginOrRegisterBox(screenWidth, screenHeight, fontSize),
                    ]
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showLoginScreen ? loginOrRegisterScreen(context) : Container()
    );
  }

  Future<void> _handleSignInApple() async {
    if (!kIsWeb) {
      // We also set the loadingbox, this is to not allow any tapping while the url is loading.
      LoadingBoxChangeNotifier loadingBoxChangeNotifier = LoadingBoxChangeNotifier();
      loadingBoxChangeNotifier.setLoadingBoxVisible(true);

      String appleLogin = "$appleLoginUrl?response_type=code&client_id=$appleClientId&redirect_uri=$appleRedirectUri&scope=email%20name&state=random_generated_state&response_mode=form_post";
      WebViewBoxChangeNotifier webViewBoxChangeNotifier = WebViewBoxChangeNotifier();
      webViewBoxChangeNotifier.setWebViewBoxUrl(appleLogin);
      webViewBoxChangeNotifier.setWebViewBoxVisible(true);

      return;
    } else {
      isLoading = true;
      final AuthorizationCredentialAppleID credential;
      try {
        credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: appleClientId,
            redirectUri: Uri.parse(
              appleRedirectUri,
            ),
          ),
        );
      } catch (error) {
        isLoading = false;
        return;
      }

      AuthServiceLogin().getLoginApple(credential.authorizationCode).then((
          loginResponse) {
        if (loginResponse.getResult()) {
          goBack();
          isLoading = false;
          setState(() {});
        } else if (!loginResponse.getResult()) {
          showToastMessage(loginResponse.getMessage());
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
      });
      isLoading = false;
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (kIsWeb) {
      if (!await launchUrl(
          url,
          webOnlyWindowName: '_self'
      )) {
        throw 'Could not launch $url';
      }
    } else {
      LoadingBoxChangeNotifier loadingBoxChangeNotifier = LoadingBoxChangeNotifier();
      loadingBoxChangeNotifier.setLoadingBoxVisible(true);

      WebViewBoxChangeNotifier webViewBoxChangeNotifier = WebViewBoxChangeNotifier();
      webViewBoxChangeNotifier.setWebViewBoxUri(url);
      webViewBoxChangeNotifier.setWebViewBoxVisible(true);
    }
  }

  Future<void> _handleSignInGoogle() async {

    isLoading = true;
    const List<String> scopes = <String>[
      'email',
    ];

    GoogleSignIn googleSignIn;
    bool fromWeb = false;
    if (kIsWeb) {
      // Web
      fromWeb = true;
      googleSignIn = GoogleSignIn(
        clientId: clientIdLoginWeb,
        scopes: scopes,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // IOS
      googleSignIn = GoogleSignIn(
        clientId: clientIdLoginIOS,
        scopes: scopes,
      );
    } else {
      // Android
      googleSignIn = GoogleSignIn(
        scopes: scopes,
      );
    }

    String? googleAccessToken;
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      googleAccessToken = googleSignInAuthentication.accessToken;

      if (googleAccessToken == null) {
        isLoading = false;
        showToastMessage("Google login failed");
        return;
      }
    } catch (error) {
      isLoading = false;
      return;
    }

    AuthServiceLogin().getLoginGoogle(googleAccessToken, fromWeb).then((
        loginResponse) {
      if (loginResponse.getResult()) {
        ScoreScreenChangeNotifier().notify();
        goBack();
        isLoading = false;
        setState(() {});
      } else if (!loginResponse.getResult()) {
        showToastMessage(loginResponse.getMessage());
      }
    }).onError((error, stackTrace) {
      showToastMessage(error.toString());
    });
    isLoading = false;
  }
}
