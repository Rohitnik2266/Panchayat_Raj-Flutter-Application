import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:panchayat_raj/screens/schemes/pmkisanpage.dart';
import 'package:panchayat_raj/screens/schemes/pmksypage.dart';
import 'package:panchayat_raj/screens/schemes/pmfbypage.dart';
import 'package:panchayat_raj/screens/schemes/kccpage.dart';
import 'package:panchayat_raj/screens/schemes/soilhealthcardpage.dart';
import 'package:panchayat_raj/screens/schemes/enampage.dart';
import 'package:panchayat_raj/screens/schemes/acabcpage.dart';
import 'package:panchayat_raj/screens/schemes/kisansuvidhapage.dart';
import 'package:panchayat_raj/screens/schemes/mkisanpage.dart';
import 'package:panchayat_raj/screens/schemes/pmkusumpage.dart';
import 'package:panchayat_raj/screens/schemes/kayakamitrapage.dart';
import 'package:panchayat_raj/screens/schemes/ShivSanmanPage.dart';
import 'package:panchayat_raj/screens/schemes/MahaDBTMechanizationPage.dart';
import 'package:panchayat_raj/screens/schemes/DbtAgriculturePage.dart';
import 'package:panchayat_raj/screens/schemes/NaifPage.dart';

class SchemeListPage extends StatelessWidget {
  const SchemeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final schemes = [
      {
        'title': t.pmkisanTitle,
        'description': t.pmkisanDescription,
        'page': const PmKisanPage()
      },
      {
        'title': t.pmksyTitle,
        'description': t.pmksyDescription,
        'page': const PmksyPage()
      },
      {
        'title': t.pmfbyTitle,
        'description': t.pmfbyDescription,
        'page': const PmfbYPage()
      },
      {
        'title': t.enamTitle,
        'description': t.enamDescription,
        'page': const ENamPage()
      },
      {
        'title': t.acabcTitle,
        'description': t.acabcDescription,
        'page': const ACABCPage()
      },
      {
        'title': t.naifTitle,
        'description': t.naifDescription,
        'page': const NaifPage()
      },
      {
        'title': t.dbtTitle,
        'description': t.dbtDescription,
        'page': const DbtAgriculturePage()
      },
      {
        'title': t.kisansuvidhaTitle,
        'description': t.kisansuvidhaDescription,
        'page': const KisanSuvidhaPage()
      },
      {
        'title': t.pmkusumTitle,
        'description': t.pmkusumDescription,
        'page': const PmKusumPage()
      },
      {
        'title': t.kccTitle,
        'description': t.kccDescription,
        'page': const KccPage()
      },
      {
        'title': t.soilhealthTitle,
        'description': t.soilhealthDescription,
        'page': const SoilHealthCardPage()
      },
      {
        'title': t.kayakamitraTitle,
        'description': t.kayakamitraDescription,
        'page': const KayakaMitraPage()
      },
      {
        'title': t.mkisanTitle,
        'description': t.mkisanDescription,
        'page': const MKisanPage()
      },
      {
        'title': t.shivsanmanTitle,
        'description': t.shivsanmanDescription,
        'page': const ShivSanmanPage()
      },
      {
        'title': t.mahadbtTitle,
        'description': t.mahadbtDescription,
        'page': const MahaDBTMechanizationPage()
      },
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme['title'] as String,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scheme['description'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => scheme['page'] as Widget,
                            ),
                          );
                        },
                        icon: const Icon(Icons.info),
                        label: Text(t.details),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => scheme['page'] as Widget,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: Text(t.apply),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
