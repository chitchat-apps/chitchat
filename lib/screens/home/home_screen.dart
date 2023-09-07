import "package:chitchat/screens/home/add_tab_screen.dart";
import "package:chitchat/screens/home/channel/channel_screen.dart";
import "package:chitchat/screens/settings/settings_screen.dart";
import "package:chitchat/stores/channel_store.dart";
import "package:chitchat/stores/tab_store.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ChannelStore _channelStore;
  late TabStore _tabStore;
  late List<String> _tabs;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _channelStore = context.read<ChannelStore>();
    _tabStore = context.read<TabStore>();
    if (_tabStore.tabs.isEmpty) {
      _tabStore.tabIndex = 0;
    } else {
      _tabStore.tabIndex =
          _tabStore.tabIndex.clamp(0, _tabStore.tabs.length - 1);
    }
    _tabController = _getController();
    _tabs = _tabStore.tabs;

    _channelStore.initialize(channels: _tabStore.tabs);
  }

  Future<void> addTab(String channelName) async {
    _tabStore.addTab(channelName: channelName);
    await _channelStore.join(channelName);
    updateTabs();
  }

  void removeTab(String channelName) {
    _tabStore.removeTab(channelName: channelName);
    _channelStore.part(channelName);
    _tabController.index = _tabStore.tabIndex;
    updateTabs();
  }

  void updateTabs() {
    _tabs = _tabStore.tabs;
    _tabController = _getController();
    _updatePage();
  }

  TabController _getController() {
    return TabController(
      initialIndex: _tabStore.tabIndex,
      length: _tabStore.tabs.length,
      vsync: this,
    );
  }

  void _updatePage() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          onTap: (value) {
            _tabStore.tabIndex = value;
          },
          tabs: _tabs.map((e) => Tab(child: Text(e))).toList(),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.25),
            width: 1,
          ),
        ),
        toolbarHeight: 48,
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add tab",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTabScreen(onAdd: addTab)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs
            .map((e) => ChannelScreen(
                channelName: e,
                onClose: () {
                  removeTab(e);
                }))
            .toList(),
      ),
    );
  }
}
