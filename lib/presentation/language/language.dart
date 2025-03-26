import 'package:flutter/material.dart';
import 'package:iptv_player/common/constants/language_constants.dart';
import 'package:iptv_player/common/widgets/native_ad.dart';
import 'package:iptv_player/main.dart';
import 'package:iptv_player/presentation/home/home_page.dart';
import 'package:iptv_player/presentation/language/language_card.dart';

class LanguageWidget extends StatefulWidget {
  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  String? selectedLocale = '';
  setSelectedLocale(String locale) {
    setState(() {
      selectedLocale = locale;
    });
  }

  @override
  void initState() {
    getLocale().then((value) => {
          setState(() {
            selectedLocale = value.languageCode;
          })
        });
    super.initState();
  }

  final List<Map<String, String>> supportedLocales = [
    {'code': 'en', 'name': 'English', 'flag': 'assets/flags/us.png'},
    {'code': 'vi', 'name': 'Vietnamese', 'flag': 'assets/flags/vn.png'},
    {'code': 'es', 'name': 'Spanish', 'flag': 'assets/flags/es.png'},
    {'code': 'fr', 'name': 'French', 'flag': 'assets/flags/fr.png'},
    {'code': 'hi', 'name': 'Hindi', 'flag': 'assets/flags/in.png'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': 'assets/flags/pt.png'},
    {'code': 'de', 'name': 'German', 'flag': 'assets/flags/de.png'},
    {'code': 'zh', 'name': 'Chinese', 'flag': 'assets/flags/cn.png'},
    {'code': 'ar', 'name': 'Arabic', 'flag': 'assets/flags/sa.png'},
  ];

  Widget buildLanguageList() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
          child: Column(
              children: supportedLocales.map((locale) {
        return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: LanguageSelector(
              localeCode: locale['code']!,
              languageName: locale['name']!,
              flagAsset: locale['flag']!,
              selectedLocale: selectedLocale,
              onLocaleSelected: setSelectedLocale,
            ));
      }).toList())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Language'),
          backgroundColor: Colors.white,
          actions: [
            selectedLocale != ''
                ? IconButton(
                    onPressed: () {
                      MyApp.setLocale(context, Locale(selectedLocale!));
                      setLocale(selectedLocale!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    icon: Icon(Icons.check),
                    color: Theme.of(context).primaryColor,
                  )
                : SizedBox(),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: buildLanguageList(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: selectedLocale == ''
                    ? NativeAdWidget(
                        adUnitId: 'ca-app-pub-1009785731919817/6048331771',
                        fallbackAdUnitId:
                            'ca-app-pub-1009785731919817/1238055891')
                    : NativeAdWidget(
                        adUnitId: 'ca-app-pub-1009785731919817/2444731328',
                        fallbackAdUnitId:
                            'ca-app-pub-1009785731919817/1857837146'),
              )
            ],
          ),
        ));
  }
}
