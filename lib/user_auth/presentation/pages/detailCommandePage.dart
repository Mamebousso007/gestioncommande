import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DetailCommande.dart';
import 'commande.dart';

class DetailCommandePage extends StatelessWidget {
  final Commande commande;

  DetailCommandePage({required this.commande});

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(imageUrl, fit: BoxFit.contain),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommandeInfo(BuildContext context, String title, String value) {
    bool isPhone = title.toLowerCase() == "téléphone";
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          isPhone
              ? InkWell(
            onTap: () async {
              final phoneUrl = 'tel:$value';
              if (await canLaunch(phoneUrl)) {
                await launch(phoneUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Impossible de lancer l\'appel')),
                );
              }
            },
            child: Row(
              children: [
                Text(value, style: TextStyle(color: Colors.blue)),
                SizedBox(width: 8),
                Icon(Icons.phone_in_talk, color: Colors.green)
              ],
            ),
          )
              : Text(value),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFBB9B9)),
        title: Text("Détails Commande ${commande.id}",style: TextStyle(fontSize: 14),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informations de Commande",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      _buildCommandeInfo(context, "Date", commande.date.toLocal().toString()),
                      _buildCommandeInfo(context, "Total", "${commande.montantTotal} FCFA"),
                      _buildCommandeInfo(context,"Livraison", commande.modeDeLivraison),
                      _buildCommandeInfo(context,"Paiement", commande.modeDePaiement),
                      _buildCommandeInfo(context,"Client", commande.nomClient),
                      //_buildCommandeInfo(context,"Téléphone", commande.telephoneCli),
                      _buildCommandeInfo(context,"Adresse", commande.adresseCli),
                      _buildCommandeInfo(context, "Téléphone", commande.telephoneCli),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Articles de la Commande:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: commande.details.length,
                itemBuilder: (context, index) {
                  DetailCommande detail = commande.details[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => _showImageDialog(context, detail.imageUrl),
                        child: Image.network(
                          detail.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(detail.nomProduit, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantité: ${detail.quantite}"),
                          Text("Prix unitaire: ${detail.prixUnitaire} FCFA", style: TextStyle(color: Color(0xFFFBB9B9))),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFFBB9B9)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
