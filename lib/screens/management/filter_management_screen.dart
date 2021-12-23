import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/all_data.dart';

class FilterManagementScreen extends StatefulWidget {
  static final routeName = '/filter_management_screen';

  const FilterManagementScreen({Key? key}) : super(key: key);

  @override
  _FilterManagementScreenState createState() => _FilterManagementScreenState();
}

class _FilterManagementScreenState extends State<FilterManagementScreen> {
  // String _dateRange = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Filter'),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15.0,
              offset: Offset(0.0, 3),
            ),
          ],
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Abbrechen'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Übernehmen'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Card(
              child: Row(
                children: [
                  Text('Range of the Date...'),
                  IconButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        lastDate: new DateTime(2026),
                        firstDate: new DateTime(2019),
                      );
                      print(picked);
                    },
                    icon: Icon(
                      Icons.calendar_today,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Dauerauftrag',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Card(
              child: SwitchListTile(
                title: Text('Daueraufträge anzeigen'),
                value: false,
                onChanged: (val) {},
              ),
            ),
            Text(
              'Kategorien',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Card(
              // child: GridView(
              //   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: AllData.categories
              //       .map((item) => GestureDetector(
              //             onTap: () => setState(() {
              //               // _selectedCategoryID = '${item.id}';
              //             }),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 4, right: 4),
              //               child: new Container(
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(12),
              //                   border: Border.all(
              //                     // width: _selectedCategoryID == '${item.id}'
              //                     //     ? 2.1
              //                     //     : 1.0,
              //                     // color: _selectedCategoryID == '${item.id}'
              //                     //     ? Theme.of(context).primaryColor
              //                     //     : Colors.grey.shade700,
              //                   ),
              //                   color: Colors.grey.shade200,
              //                 ),
              //                 height: MediaQuery.of(context).size.width * 0.17,
              //                 width: MediaQuery.of(context).size.width * 0.15,
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(
              //                       top: 4, left: 2.5, right: 2.5),
              //                   child: new Column(
              //                     children: [
              //                       CircleAvatar(
              //                           radius:
              //                               MediaQuery.of(context).size.width *
              //                                   0.05,
              //                           backgroundColor: item.color,
              //                           child: FractionallySizedBox(
              //                             widthFactor: 0.3,
              //                             heightFactor: 0.3,
              //                             child: Image.asset(
              //                               item.symbol!,
              //                               color:
              //                                   item.color!.computeLuminance() >
              //                                           0.1
              //                                       ? Colors.black
              //                                       : Colors.white,
              //                             ),
              //                           )),
              //                       SizedBox(height: 4),
              //                       Center(
              //                           child: Text(
              //                         '${item.title}',
              //                         style: TextStyle(
              //                             fontSize: 7,
              //                             fontWeight: FontWeight.bold,
              //                             color: item.color),
              //                         textAlign: TextAlign.center,
              //                       )),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ))

              //       // new CircleAvatar(
              //       //       radius: 40,
              //       //       backgroundColor: item.color,
              //       //       child: Text('${item.title}'),
              //       //     ))
              //       .toList(),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
