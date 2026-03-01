import 'package:flutter/material.dart';
import 'package:couldai_user_app/simulation_logic.dart';
import 'package:couldai_user_app/ui/simulation_view.dart';
import 'package:couldai_user_app/ui/comparison_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SimulationController _simulationController = SimulationController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _simulationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I/O System & Interrupts'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.play_circle_outline), text: 'Simulation'),
            Tab(icon: Icon(Icons.compare_arrows), text: 'Comparison'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SimulationView(controller: _simulationController),
          const ComparisonView(),
        ],
      ),
    );
  }
}
