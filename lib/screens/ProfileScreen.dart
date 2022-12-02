import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/themes.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ProfileEditScreen.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';

class ProfileScreen extends StatefulWidget {
  final DataBase db;

  ProfileScreen({
    @required this.db,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Future<UserModel> futureUser;

  Future<List<ReviewModel>> futureReviews;

  //List<Widget> reviewWidgetList = [];
  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  var lightBlueColor = Colors.blue;

  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);

  List<Widget> reviewCardsWidgetsFromList(List<ReviewModel> reviews) {
    List<Widget> reviewWidgetList = [];
    if (reviews.isEmpty || reviews == null) {
      reviewWidgetList.add(
        Text('You have no reviews yet'),
      );
    } else {
      for (var item in reviews) {
        reviewWidgetList.add(ReviewCard(reviewModel: item));
      }
    }
    return reviewWidgetList;
  }

  getnumber() async {
    var phone = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('UserModel')
        .where('phone', isEqualTo: phone.toString())
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users.name = element['name'];
        users.carinfo = element['carInfo'];
        users.phone = element['phone'];
        users.email = element['email'];
        users.gender = element['gender'] as Gender;
        users.rating = element['rating'];
      });
    });
    // setState(() {});
  }

  double getRatingAverage(List<ReviewModel> reviewsList) {
    if (reviewsList.isEmpty) {
      return 0.0;
    } else {
      double sum = 0;
      for (var item in reviewsList) {
        var currentRating = item.rating;
        sum = sum + currentRating;
      }
      return sum / reviewsList.length;
    }
  }

  void getDataFromDb() {
    futureUser = widget.db.getCurrentUserModel();
    futureReviews = widget.db.getCurrentUserReviews();
  }

  void printReviewList() async {
    List reviews = await widget.db.getCurrentUserReviews();
    print('!!!!REVIEWS IN DB:   $reviews');
  }

  @override
  void initState() {
    getnumber();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    printReviewList();
    getDataFromDb();
    UserModel initialUser = UserModel(
      name: 'waiting...',
      gender: null,
      phone: 'waiting...',
      email: 'waiting...',
      rating: 0.0,
      carInfo: 'waiting...',
    );
    UserModel errorUser = UserModel(
      name: users.name,
      gender: users.gender,
      phone: users.phone,
      email: users.email,
      rating: users.rating,
      carInfo: users.carinfo,
    );

    Widget userScreen(
        UserModel userModel, Future<List<ReviewModel>> futureReviews) {
      //addReviewCards(reviews);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: themes.lighttheme,
        darkTheme: themes.darktheme,
        title: 'HopIn',
        // theme: ThemeData(
        //         scaffoldBackgroundColor: Colors.white,
        //         primaryColor: darkBlueColor,
        //         secondaryHeaderColor: lightBlueColor,
        //         //cardColor: lightGreyBackground,
        //         textTheme: TextTheme(
        //           bodyText1: TextStyle(
        //             color: darkBlueColor,
        //             fontFamily: 'fira',
        //             fontSize: 14.0,
        //           ),
        //           headline2: TextStyle(
        //             color: darkBlueColor,
        //             fontFamily: 'fira',
        //             fontSize: 16.0,
        //           ),
        //         ),
        //       )

        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen(
                                          db: this.widget.db,
                                          isNewUser: false,
                                        )),
                              );
                            }),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: new NetworkImage(
                      userModel.getUrlFromNameHash(
                          genderInput: userModel.gender),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 0.0),
                    child: Text(
                      userModel.name,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          'My Rating:',
                          style: GoogleFonts.oswald(
                              textStyle: TextStyle(
                            fontSize: 15.0,
                          )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FutureBuilder<List<ReviewModel>>(
                                future: futureReviews,
                                initialData: [],
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ReviewModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    print('We have rating!!!');
                                    return Text(
                                      getRatingAverage(snapshot.data)
                                          .toString()
                                          .substring(0, 3),
                                      style: GoogleFonts.oswald(
                                          textStyle: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                    );
                                  } else if (snapshot.hasError) {
                                    print('error');
                                    return Text(
                                      'error',
                                      style: GoogleFonts.oswald(
                                          textStyle: TextStyle(
                                        fontSize: 15.0,
                                      )),
                                    );
                                  } else {
                                    //waiting...
                                    print('waiting for rating');
                                    return Column(
                                      children: <Widget>[
                                        Center(
                                          child: SizedBox(
                                            child: CircularProgressIndicator(),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                            Icon(
                              Icons.star,
                              size: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                        child: Text(
                          'Personal Info',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(userModel.phone),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: Text(userModel.email),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                        child: Text(
                          'Car Info',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    child: ListTile(
                      leading: Icon(Icons.directions_car),
                      title: Text(userModel.carInfo),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                        child: Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<ReviewModel>>(
                    future: futureReviews,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReviewModel>> snapshot) {
                      if (snapshot.hasData) {
                        print('We have reviews!!!');
                        return Column(
                          children: reviewCardsWidgetsFromList(snapshot.data),
                        );
                      } else if (snapshot.hasError) {
                        print('error in review list');
                        print('error data: ${snapshot.data}');
                        return Column(
                          children: reviewCardsWidgetsFromList([]),
                        );
                      } else {
                        //waiting...
                        print('waiting reviews');
                        return Column(
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FutureBuilder<UserModel>(
        //TODO add second future with wait
        //futureReviews
        future: futureUser,
        initialData: initialUser,
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            print('we have profile data!!!');
            return userScreen(snapshot.data, this.futureReviews);
          } else if (snapshot.hasError) {
            print('error');
            return userScreen(errorUser, this.futureReviews);
          } else {
            //waiting...
            print('waiting');
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 100,
                height: 100,
              ),
            );
          }
        });
  }
}
