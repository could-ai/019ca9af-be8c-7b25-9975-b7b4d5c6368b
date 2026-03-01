import 'package:flutter/material.dart';
import 'package:couldai_user_app/simulation_logic.dart';

class SimulationView extends StatelessWidget {
  final SimulationController controller;

  const SimulationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Column(
          children: [
            // Control Panel
            _buildControlPanel(context),
            
            const Divider(height: 1),

            // Visual Diagram
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: Center(child: null).crossAxisAlignment, // Default
                          children: [
                            _buildComponentNode(
                              "Application",
                              Icons.apps,
                              ComponentType.app,
                              controller.activeComponent,
                              Colors.blue,
                            ),
                            _buildArrow(),
                            _buildComponentNode(
                              "System Call",
                              Icons.settings_applications,
                              ComponentType.sysCall,
                              controller.activeComponent,
                              Colors.orange,
                            ),
                            _buildArrow(),
                            _buildComponentNode(
                              "Device Driver",
                              Icons.memory,
                              ComponentType.driver,
                              controller.activeComponent,
                              Colors.purple,
                            ),
                            _buildArrow(),
                            _buildComponentNode(
                              "I/O Controller",
                              Icons.developer_board,
                              ComponentType.controller,
                              controller.activeComponent,
                              Colors.teal,
                            ),
                            _buildArrow(),
                            _buildComponentNode(
                              "I/O Device",
                              Icons.storage,
                              ComponentType.device,
                              controller.activeComponent,
                              Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // CPU Status (Special indicator)
            if (controller.activeComponent == ComponentType.cpu)
              Container(
                width: double.infinity,
                color: Colors.amber[100],
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("CPU Active (Waiting or Processing)", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            const Divider(height: 1),

            // Logs / Timeline
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Event Timeline & Logs",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: controller.logs.length,
                        itemBuilder: (context, index) {
                          final log = controller.logs[index];
                          return Card(
                            elevation: 0,
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getColorForComponent(log.source).withOpacity(0.2),
                                child: Icon(
                                  _getIconForComponent(log.source),
                                  color: _getColorForComponent(log.source),
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                log.message,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                "${log.timestamp.hour}:${log.timestamp.minute}:${log.timestamp.second}.${log.timestamp.millisecond}",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<SimulationMode>(
              segments: const [
                ButtonSegment(
                  value: SimulationMode.polling,
                  label: Text("Polling"),
                  icon: Icon(Icons.loop),
                ),
                ButtonSegment(
                  value: SimulationMode.interrupt,
                  label: Text("Interrupt"),
                  icon: Icon(Icons.flash_on),
                ),
              ],
              selected: {controller.mode},
              onSelectionChanged: (Set<SimulationMode> newSelection) {
                if (!controller.isSimulating) {
                  controller.setMode(newSelection.first);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: controller.isSimulating
                ? null
                : () => controller.startSimulation(),
            icon: controller.isSimulating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(controller.isSimulating ? "Running..." : "Start"),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentNode(
    String label,
    IconData icon,
    ComponentType type,
    ComponentType? activeType,
    Color color,
  ) {
    final isActive = type == activeType;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isActive ? Colors.white : color,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.arrow_forward, color: Colors.grey),
    );
  }

  Color _getColorForComponent(ComponentType type) {
    switch (type) {
      case ComponentType.app: return Colors.blue;
      case ComponentType.sysCall: return Colors.orange;
      case ComponentType.driver: return Colors.purple;
      case ComponentType.controller: return Colors.teal;
      case ComponentType.device: return Colors.red;
      case ComponentType.cpu: return Colors.amber;
    }
  }

  IconData _getIconForComponent(ComponentType type) {
    switch (type) {
      case ComponentType.app: return Icons.apps;
      case ComponentType.sysCall: return Icons.settings_applications;
      case ComponentType.driver: return Icons.memory;
      case ComponentType.controller: return Icons.developer_board;
      case ComponentType.device: return Icons.storage;
      case ComponentType.cpu: return Icons.computer;
    }
  }
}
