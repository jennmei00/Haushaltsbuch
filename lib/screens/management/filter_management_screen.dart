import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';
import 'package:intl/intl.dart';
// import 'package:haushaltsbuch/models/all_data.dart';

class FilterManagementScreen extends StatefulWidget {
  static final routeName = '/filter_management_screen';
  final List<Object?> filters;

  const FilterManagementScreen({Key? key, this.filters = const []})
      : super(key: key);

  @override
  _FilterManagementScreenState createState() => _FilterManagementScreenState();
}

class _FilterManagementScreenState extends State<FilterManagementScreen> {
  List<Account> _filterAccounts = [];
  List<Category> _filterCategories = [];
  bool _filterSO = false;
  DateTimeRange? _filterDate;
  String _selectedAccounts = 'Keine Konten ausgewählt';

  @override
  void initState() {
    AllData.categories.sort((a, b) {
      return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
    });

    if (widget.filters.length != 0) {
      _filterAccounts = widget.filters[0] as List<Account>;
      _filterCategories = widget.filters[1] as List<Category>;
      _filterDate = widget.filters[2] as DateTimeRange?;
      _filterSO = widget.filters[3] as bool;

      if (_filterAccounts.length != 0) _selectedAccounts = '';

      _filterAccounts.forEach((e) {
        if (_filterAccounts.last == e)
          _selectedAccounts += '${e.title}';
        else
          _selectedAccounts += '${e.title}, ';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottomSheetSize = MediaQuery.of(context).size.height * 0.09;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verwaltungsfilter'),
      ),
      bottomSheet: BottomSheet(
        enableDrag: false,
        // backgroundColor: Colors.red,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
        // ),
        onClosing: () {},
        builder: (context) => Container(
          // color: Colors.transparent,
          height: bottomSheetSize,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(30),
          //   // color: Colors.red,
          // ),
          //  decoration: new BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: new BorderRadius.only(
          //                   topLeft: const Radius.circular(30.0),
          //                   topRight: const Radius.circular(30.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, []),
                child: Text('Zurücksetzen'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, [
                    _filterAccounts,
                    _filterCategories,
                    _filterDate,
                    _filterSO
                  ]);
                },
                child: Text('Übernehmen'),
              )
            ],
          ),
        ),
      ),
      //Container(
      //color: Colors.yellow,
      // decoration: BoxDecoration(
      //     //color: Theme.of(context).colorScheme.surface,
      //     // boxShadow: [
      //     //   BoxShadow(
      //     //     color: Colors.black54,
      //     //     blurRadius: 15.0,
      //     //     offset: Offset(0.0, 3),
      //     //   ),
      //     // ],
      //     border: Border.all(
      //       color: Colors.red,
      //     ),
      // borderRadius: BorderRadius.all(Radius.circular(20))
      //     //borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      // ),
      // height: MediaQuery.of(context).size.height * 0.1, //60,
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     ElevatedButton(
      //       onPressed: () => Navigator.pop(context, []),
      //       child: Text('Zurücksetzen'),
      //       // style: ButtonStyle(
      //       //     backgroundColor: MaterialStateProperty.all(
      //       //         Theme.of(context).primaryColor)
      //       //         ),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         Navigator.pop(context, [
      //           _filterAccounts,
      //           _filterCategories,
      //           _filterDate,
      //           _filterSO
      //         ]);
      //       },
      //       child: Text('Übernehmen'),
      //       // style: ButtonStyle(
      //       //     backgroundColor: MaterialStateProperty.all(
      //       //         Theme.of(context).primaryColor)),
      //     )
      //   ],
      // ),
      //),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: bottomSheetSize + 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Datum',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Text(_filterDate == null
                            ? 'Zum Auswählen klicken'
                            // : '${_filterDate!.start.day}. ${_filterDate!.start.month}. ${_filterDate!.start.year} bis ' +
                            //     '${_filterDate!.end.day}. ${_filterDate!.end.month}. ${_filterDate!.end.year}'),
                            : '${DateFormat.yMMMd().format(_filterDate!.start)} - ' +
                                '${DateFormat.yMMMd().format(_filterDate!.end)}'),
                        IconButton(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: AllData.postings.first.date!,
                              lastDate: DateTime.now().add(Duration(days: 30)),
                            );

                            setState(() {
                              _filterDate = picked;
                            });
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 5,
                child: SwitchListTile(
                  activeColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    'Dauerauftrag',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: _filterSO,
                  onChanged: (val) => setState(() => _filterSO = val),
                  // activeColor: Theme.of(context).primaryColor,
                ),
              ),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16, top: 18),
                      width: double.infinity,
                      child: Text(
                        'Kategorien',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        //child: Text('Kategorieeen'),
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.5),
                          padding: EdgeInsets.all(10),
                          crossAxisCount: 3,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * 0.04,
                          mainAxisSpacing: 12,
                          children: AllData.categories
                              .map((item) => CategoryItem(
                                    categoryItem: item,
                                    selectedCatList: _filterCategories,
                                    multiSelection: true,
                                    onTapFunction: () => setState(() {
                                      final isSelected =
                                          _filterCategories.contains(item);
                                      isSelected
                                          ? _filterCategories.remove(item)
                                          : _filterCategories.add(item);
                                    }),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Konten',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              Card(
                elevation: 5,
                child: ExpansionTile(
                  //textColor: Colors.black,
                  //iconColor: Colors.black,
                  title: Text(
                    'Konten',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_selectedAccounts),
                  children: AllData.accounts
                      .map((e) => ListTile(
                            title: Text('${e.title}'),
                            trailing: Checkbox(
                              // fillColor: MaterialStateProperty.all(
                              //     Theme.of(context).primaryColor),
                              value: _filterAccounts.contains(e),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true)
                                    _filterAccounts.add(e);
                                  else
                                    _filterAccounts.remove(e);

                                  if (_filterAccounts.length == 0)
                                    _selectedAccounts =
                                        'Keine Konten ausgewählt';
                                  else
                                    _selectedAccounts = '';

                                  _filterAccounts.forEach((e) {
                                    if (_filterAccounts.last == e)
                                      _selectedAccounts += '${e.title}';
                                    else
                                      _selectedAccounts += '${e.title}, ';
                                  });
                                });
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              // SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
