import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:location_tracker/theme/theme.dart';
import 'package:go_router/go_router.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final loc.Location location = loc.Location();
  @override
  void initState() {
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final _number = FirebaseAuth.instance.currentUser!.phoneNumber;
  User? user = FirebaseAuth.instance.currentUser;
  String? findAddres;
  String _address = "";

//GETING LOCTAION
  void getUserLocation(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    var place = placemarks[0];
    String? name = place.name;
    String? subLocality = place.subLocality;
    String? locality = place.locality;
    String? administrativeArea = place.administrativeArea;
    String? postalCode = place.postalCode;
    String? country = place.country;
    var address =
        "$name, $subLocality, $locality, $administrativeArea, $postalCode, $country";

    setState(() {
      _address = address; // update _address
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              currenttheme.toggleTheme();
            },
            icon: const Icon(Icons.brightness_4_rounded),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await _auth.signOut();
                  GoRouter.of(context).go('/logout');
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Loginscreen()));
                },
                icon: const Icon(Icons.logout_outlined))
          ],
          title: Text('Welcome $_number'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // CAMERA UPLOAING PROCESS
              Padding(
                padding: const EdgeInsets.only(right: 90),
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 80, bottom: 20),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 2,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Image(
                        image: AssetImage('assets/images/camera.png'),
                      ),
                    ),
                    onTap: () {
                      GoRouter.of(context).go('/camera');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CameraUpload(
                      //             userId: FirebaseAuth.instance.currentUser!
                      //                 .uid)));
                      ////CameraUpload class is defined in camera_upload
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 2,
              ),
              const Text(
                'Photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
                width: MediaQuery.of(context).size.width / 6,
                child: const Image(
                  image:
                      AssetImage('assets/images/icons8-google-photos-480.png'),
                ),
              ),

              // RENDERING DATA ON HOMEPAGE
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('images')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return (const Center(child: Text('no images')));
                    } else {
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 9,
                                childAspectRatio: 1.6),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, int index) {
                          String url = snapshot.data!.docs[index]
                              ["downloadUrl"]; // IMAGE
                          double latitude =
                              snapshot.data!.docs[index]["latitude"]; // ADDRESS
                          double longitude =
                              snapshot.data!.docs[index]["longitude"]; //ADDRESS
                          String date =
                              snapshot.data!.docs[index]["date"]; //DATE
                          String number =
                              snapshot.data!.docs[index]["number"]; //NUMBER

                          getUserLocation(latitude, longitude);

                          if (snapshot.hasData) {
                            return Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 4,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  Expanded(
                                      //UPDATING IMAGES
                                      flex: 4,
                                      child: Image.network(url)),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: const Color.fromRGBO(
                                                37, 211, 102, 0.9),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                //UPDATING ADDRESS
                                                _address,
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(date, //UPDATING DATE
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(height: 3),
                                              Text(number, //UPDATING NUMBER
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
