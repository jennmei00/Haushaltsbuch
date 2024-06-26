import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Credits extends StatelessWidget {
  const Credits({Key? key}) : super(key: key);
  static final routeName = '/credits_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('credits'.i18n()),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(
            'Icons:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Icons made by Freepik, Uniconlabs, Smashicons, Google, rukanicon, andinur, Pixel perfect, Ayub Irawan, fjstudio, amonrat rungreangfangsai, Those Icons, Prosymbols Premium, Gregor Cresnar, kerismaker, dDara, setiawanap, monkik, Eucalyp, smashingstocks, iconixar, azmianshori, srip, bqlqn, Pixelmeetup, Rizki Ahmad Fauzi and kerismaker from www.flaticon.com.',
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${'images'.i18n()}:",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Photos by Visual Stories || Micheile, Josh Appel and Steve Johnson on Unsplash.',
            textAlign: TextAlign.justify,
          ),
           SizedBox(
            height: 20,
          ),
          Text(
            'Applogo:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'NIKmigg',
            textAlign: TextAlign.justify,
          ),
        ]),
      ),
    );
  }
}
