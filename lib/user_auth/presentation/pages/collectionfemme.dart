import 'package:flutter/material.dart';

import 'ajoutprod.dart';

class Collectionfemme extends StatefulWidget {
  const Collectionfemme({Key? key}) : super(key: key);

  @override
  State<Collectionfemme> createState() => _CollectionfemmeState();
}

class _CollectionfemmeState extends State<Collectionfemme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.pink),
        title: Text("Collections Femmes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            )),
        actions: [
          Text("Logo", style: TextStyle(color: Colors.black),)
        ],
        centerTitle: true,
        backgroundColor: Color(0xFFFAF7F7),
        elevation: 0,
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              width: 149,
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Color(0xFF49D726),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AjouterProduit()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ajouter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]

        ),
      ),
    );
  }
}
