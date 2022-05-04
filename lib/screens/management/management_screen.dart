import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/management/filter_management_screen.dart';
import 'package:haushaltsbuch/screens/management/manage_postings.dart';
import 'package:haushaltsbuch/screens/management/manage_transfers.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';
import 'package:localization/localization.dart';

class ManagementScreen extends StatefulWidget {
  static final routeName = '/management_screen';

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Object?> _filters = [];
  bool _search = false;
  TextEditingController _searchController = TextEditingController(text: '');
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_search
            ? Text(
                'management-filter'.i18n(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
            : TextField(
                onChanged: (query) {
                  setState(() {});
                },
                autofocus: true,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'serach'.i18n(),
                  hintStyle: TextStyle(color: Colors.white30),
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          _search
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.text = '';
                      _search = false;
                    });
                  },
                  icon: Icon(Icons.clear))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _search = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                  FilterManagementScreen.routeName,
                  arguments: _filters);

              if (result != null) {
                setState(() {
                  _filters = result as List<Object?>;
                });
              }
            },
            icon: Icon(Icons.filter_list),
            tooltip: 'Filter',
          )
        ],
        bottom: TabBar(
          tabs: [
            Tab(
              text: 'posting'.i18n(),
            ),
            Tab(text: 'transfer'.i18n())
          ],
          controller: _tabController,
        ),
      ),
      drawer: AppDrawer(selectedMenuItem: 'management',),
      body: TabBarView(
        children: [
          ManagePostings(
            filters: _filters,
            search: _search,
            searchQuery: _searchController.text,
          ),
          ManageTransfers(
            filters: _filters,
            search: _search,
            searchQuery: _searchController.text,
          )
        ],
        controller: _tabController,
      ),
    );
  }
}
