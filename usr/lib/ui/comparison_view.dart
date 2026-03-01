import 'package:flutter/material.dart';

class ComparisonView extends StatelessWidget {
  const ComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, "Polling vs Interrupt Mechanism"),
          const SizedBox(height: 16),
          _buildComparisonTable(context),
          const SizedBox(height: 24),
          _buildHeader(context, "Interrupt Handling Flowchart"),
          const SizedBox(height: 16),
          _buildFlowchart(context),
          const SizedBox(height: 24),
          _buildHeader(context, "Key Concepts"),
          const SizedBox(height: 8),
          _buildConceptCard(
            context,
            "Polling (Programmed I/O)",
            "The CPU periodically checks the status of the I/O device to see if it is ready. This wastes CPU cycles (Busy Waiting) but is simple to implement.",
            Icons.loop,
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildConceptCard(
            context,
            "Interrupt Driven I/O",
            "The CPU initiates the I/O and then continues with other tasks. The I/O device sends an interrupt signal when it is ready. This is efficient as CPU time is not wasted waiting.",
            Icons.flash_on,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    return Card(
      elevation: 2,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
        },
        children: [
          _buildTableRow(context, "Feature", "Polling", "Interrupt", isHeader: true),
          _buildTableRow(context, "CPU Usage", "High (Busy Waiting)", "Low (Efficient)"),
          _buildTableRow(context, "Efficiency", "Low", "High"),
          _buildTableRow(context, "Hardware Support", "Not required", "Interrupt Controller needed"),
          _buildTableRow(context, "Response Time", "Determined by polling interval", "Immediate (upon interrupt)"),
          _buildTableRow(context, "Implementation", "Simple", "Complex (ISR needed)"),
        ],
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, String feature, String polling, String interrupt, {bool isHeader = false}) {
    final style = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? Colors.white : Colors.black87,
    );
    final bg = isHeader ? Colors.indigo : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: [
        Padding(padding: const EdgeInsets.all(12), child: Text(feature, style: style)),
        Padding(padding: const EdgeInsets.all(12), child: Text(polling, style: style)),
        Padding(padding: const EdgeInsets.all(12), child: Text(interrupt, style: style)),
      ],
    );
  }

  Widget _buildFlowchart(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _buildFlowBox("I/O Request", Colors.blue),
            _buildFlowArrow(),
            _buildFlowBox("CPU Initiates Device", Colors.purple),
            _buildFlowArrow(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildFlowBox("CPU Executes Other Tasks", Colors.amber)),
                const SizedBox(width: 16),
                Expanded(child: _buildFlowBox("Device Processes Data", Colors.red)),
              ],
            ),
            _buildFlowArrow(),
            _buildFlowBox("Device Sends Interrupt", Colors.redAccent),
            _buildFlowArrow(),
            _buildFlowBox("CPU Saves State", Colors.grey),
            _buildFlowArrow(),
            _buildFlowBox("Execute ISR (Interrupt Service Routine)", Colors.green),
            _buildFlowArrow(),
            _buildFlowBox("Restore State & Resume", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color.withOpacity(1.0), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFlowArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Icon(Icons.arrow_downward, size: 20, color: Colors.grey),
    );
  }

  Widget _buildConceptCard(BuildContext context, String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
