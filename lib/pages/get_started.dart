import 'package:amethyst_app/pages/login_page.dart';
import 'package:amethyst_app/pages/sign_up_sequence.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:amethyst_app/styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getstart(context),
    );
  }

  Widget getstart(BuildContext context) {
    return Stack(children: <Widget>[
      slide_show(context),
      Container(
        color: Color(0xbf000000),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                ),
                Image.asset(
                  "assets/logo.png",
                  height: 175,
                  width: 175,
                ),
                Container(
                  height: 20,
                ),
                Text(
                  "Welcome to",
                  style: TextStyles()
                      .headerTextStyle()
                      .copyWith(fontSize: 40, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 200.0),
                  child: Text(
                    "Amethyst",
                    style: TextStyles()
                        .headerTextStyle()
                        .copyWith(fontSize: 50, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                GradientButton(
                    gradient: TextStyles().baseGrad(),
                    increaseHeightBy: 30,
                    increaseWidthBy: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Get Started",
                        textAlign: TextAlign.center,
                        style: TextStyles()
                            .headerTextStyle()
                            .copyWith(fontSize: 30.0),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    callback: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new SignUp()));
                    }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: FlatButton(
                    child: Text(
                      "Already have an account?",
                      style: TextStyles()
                          .subheaderTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new LoginForm(
                                    auth: new Auth(),
                                    isLogin: true,
                                  )));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget slide_show(BuildContext context) {
    List<String> imUrls = [
      "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80",
      "https://images.unsplash.com/photo-1525362081669-2b476bb628c3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
      "https://images.unsplash.com/photo-1484876065684-b683cf17d276?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
      "https://images.unsplash.com/photo-1471614654469-512ee6a4397a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"
    ];
    List<Widget> ims = [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imUrls[0]), fit: BoxFit.cover)),
      ),
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imUrls[1]), fit: BoxFit.cover)),
      ),
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imUrls[2]), fit: BoxFit.cover)),
      ),
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imUrls[3]), fit: BoxFit.cover)),
      ),
    ];

    return CarouselSlider(
      viewportFraction: 1.0,
      aspectRatio: 16 / 9,
      height: MediaQuery.of(context).size.height,
      items: ims,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 4),
      autoPlayCurve: Curves.fastLinearToSlowEaseIn,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
    );
  }
}
