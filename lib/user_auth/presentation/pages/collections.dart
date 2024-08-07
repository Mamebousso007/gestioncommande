import 'package:flutter/material.dart';
import 'package:gestioncommande/user_auth/presentation/pages/articlefemme.dart';
import 'package:gestioncommande/user_auth/presentation/pages/articlehomme.dart';
import 'package:gestioncommande/user_auth/presentation/pages/produits.dart';
import 'package:remixicon/remixicon.dart';

import 'ajoutcategorie.dart';
import 'articleenfant.dart';
import 'collectionfemme.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFBB9B9)),
        title: Text("Collections",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            )),
        actions: [
          Image(
            image: AssetImage("images/logo.jpg"),
            height: 40,
            width: 40,
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjoutCategorie(),
            ),
          );
        },
        backgroundColor: Color(0xFFFBB9B9), // Couleur WhatsApp
        child: Icon(Remix.add_circle_fill,color: Colors.white,), // Image WhatsApp
      ),
      body: Center(
        child: Container(
          width: 398,
          height: 447,
          decoration: BoxDecoration(
            color: Color(0x07FF18BE),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArticleFemme()));
                },
                child: Container(
                  width: 300,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF68B73),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF68B73)),
                      borderRadius: BorderRadius.circular(5),
                    ),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collections Femmes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArticleHomme()));
                },
                child: Container(
                  width: 300,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF68B73),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF68B73)),
                      borderRadius: BorderRadius.circular(5),
                    ),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collections Hommes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArticleEnfant()));
                },
                child: Container(
                  width: 300,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF68B73),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF68B73)),
                      borderRadius: BorderRadius.circular(5),
                    ),

                  ),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collections Enfants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
