import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/management/filter_management_screen.dart';
import 'package:haushaltsbuch/screens/management/manage_postings.dart';
import 'package:haushaltsbuch/screens/management/manage_transfers.dart';
import 'package:haushaltsbuch/widgets/app_drawer.dart';

class ManagementScreen extends StatefulWidget {
  static final routeName = '/management_screen';

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Object?> _filters = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verwaltung',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
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
              text: 'Buchungen',
            ),
            Tab(text: 'Umbuchungen')
          ],
          controller: _tabController,
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        children: [ManagePostings(filters: _filters), ManageTransfers(filters: _filters)],
        controller: _tabController,
      ),
    );
  }
}
