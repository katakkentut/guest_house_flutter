// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/widgets/service_card.dart';
import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/providers/service_provider.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminServicesScreen extends StatefulWidget {
  @override
  _AdminServicesScreenState createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.large(
          'Services',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [Container(), Expanded(child: NestedTabBar())],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Pending Services'),
            Tab(text: 'History'),
          ],
          indicatorColor: Colors.blueAccent,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(child: _PendingService()),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(child: _ServiceHistory()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PendingService extends ConsumerWidget {
  const _PendingService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(admminAllServiceProvider('pending'));
    return Consumer(
      builder: (context, ref, child) {
        return services.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
          data: (services) {
            if (services.isEmpty) {
              return Center(child: Text('No service available'));
            }
            return Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  ServiceModel service = services[index];
                  return AdminServiceCard(service: service);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _ServiceHistory extends ConsumerWidget {
  const _ServiceHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final services = ref.watch(admminAllServiceProvider('Completed'));
    return Consumer(
      builder: (context, ref, child) {
        return services.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
          data: (services) {
            if (services.isEmpty) {
              return Center(child: Text('No service available'));
            }
            return Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  ServiceModel service = services[index];
                  return AdminServiceCard(service: service);
                },
              ),
            );
          },
        );
      },
    );
  }
}
