import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/account.dart';
import 'package:haushaltsbuch/models/all_data.dart';
import 'package:haushaltsbuch/models/category.dart';
import 'package:haushaltsbuch/services/help_methods.dart';
import 'package:haushaltsbuch/widgets/category_item.dart';

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
    double bottomSheetSize = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verwaltungsfilter'),
      ),
      bottomSheet: BottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableDrag: false,
        onClosing: () {},
        builder: (context) => Container(
          height: bottomSheetSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, []),
                child: Text('Zurücksetzen'),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: bottomSheetSize + 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Datum',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Text(
                            _filterDate == null
                                ? 'Zum Auswählen klicken'
                                : '${formatDate(_filterDate!.start)} - ' +
                                    '\n ${formatDate(_filterDate!.end)}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                            textAlign: TextAlign.end,
                          ),
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: AllData.postings.length == 0
                                  ? DateTime.now().subtract(Duration(days: 30))
                                  : AllData.postings.last.date!,
                              lastDate: DateTime.now().add(Duration(days: 30)),
                            );

                            setState(() {
                              _filterDate = picked;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: AllData.postings.length == 0
                                ? DateTime.now().subtract(Duration(days: 30))
                                : AllData.postings.last.date!,
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
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 5,
                child: SwitchListTile(
                  activeColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    'Dauerauftrag',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  value: _filterSO,
                  onChanged: (val) => setState(() => _filterSO = val),
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
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          childAspectRatio: 0.7,
                          padding: EdgeInsets.all(4),
                          crossAxisCount: 4,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * 0.02,
                          mainAxisSpacing: 2,
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
              Card(
                elevation: 5,
                child: ExpansionTile(
                  title: Text(
                    'Konten',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_selectedAccounts),
                  children: AllData.accounts
                      .map((e) => ListTile(
                            title: Text('${e.title}'),
                            trailing: Checkbox(
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
            ],
          ),
        ),
      ),
    );
  }
}
