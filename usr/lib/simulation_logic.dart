import 'dart:async';
import 'package:flutter/material.dart';

enum SimulationMode { polling, interrupt }

enum ComponentType { app, sysCall, driver, controller, device, cpu }

class LogEntry {
  final DateTime timestamp;
  final String message;
  final ComponentType source;
  final bool isError;

  LogEntry({
    required this.message,
    required this.source,
    this.isError = false,
  }) : timestamp = DateTime.now();
}

class SimulationController extends ChangeNotifier {
  SimulationMode _mode = SimulationMode.polling;
  bool _isSimulating = false;
  ComponentType? _activeComponent;
  final List<LogEntry> _logs = [];
  double _progress = 0.0; // 0.0 to 1.0 for progress bar if needed

  SimulationMode get mode => _mode;
  bool get isSimulating => _isSimulating;
  ComponentType? get activeComponent => _activeComponent;
  List<LogEntry> get logs => List.unmodifiable(_logs);

  void setMode(SimulationMode mode) {
    if (_isSimulating) return;
    _mode = mode;
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  void _addLog(String message, ComponentType source) {
    _logs.insert(0, LogEntry(message: message, source: source));
    notifyListeners();
  }

  void _setActive(ComponentType? component) {
    _activeComponent = component;
    notifyListeners();
  }

  Future<void> startSimulation() async {
    if (_isSimulating) return;
    _isSimulating = true;
    clearLogs();
    notifyListeners();

    try {
      if (_mode == SimulationMode.polling) {
        await _runPollingSimulation();
      } else {
        await _runInterruptSimulation();
      }
    } finally {
      _isSimulating = false;
      _activeComponent = null;
      notifyListeners();
    }
  }

  Future<void> _runPollingSimulation() async {
    // 1. App requests I/O
    _setActive(ComponentType.app);
    _addLog("Application requests I/O operation (Read File)", ComponentType.app);
    await Future.delayed(const Duration(seconds: 1));

    // 2. System Call
    _setActive(ComponentType.sysCall);
    _addLog("System Call: read() invoked. Switching to Kernel Mode.", ComponentType.sysCall);
    await Future.delayed(const Duration(seconds: 1));

    // 3. Driver initiates
    _setActive(ComponentType.driver);
    _addLog("Device Driver receives request.", ComponentType.driver);
    await Future.delayed(const Duration(seconds: 1));

    // Polling Loop
    int checks = 0;
    const maxChecks = 3;

    while (checks < maxChecks) {
      checks++;
      
      // Driver checks Controller
      _setActive(ComponentType.driver);
      _addLog("Driver: Checking status register... (Attempt $checks)", ComponentType.driver);
      await Future.delayed(const Duration(milliseconds: 800));

      // Controller checks Device
      _setActive(ComponentType.controller);
      _addLog("Controller: Device is BUSY processing data.", ComponentType.controller);
      await Future.delayed(const Duration(milliseconds: 800));

      // CPU waits (Busy Wait)
      _setActive(ComponentType.cpu);
      _addLog("CPU: Busy waiting (wasting cycles)...", ComponentType.cpu);
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Data Ready
    _setActive(ComponentType.device);
    _addLog("I/O Device: Data transfer complete. Buffer full.", ComponentType.device);
    await Future.delayed(const Duration(seconds: 1));

    _setActive(ComponentType.controller);
    _addLog("Controller: Status register set to READY.", ComponentType.controller);
    await Future.delayed(const Duration(seconds: 1));

    _setActive(ComponentType.driver);
    _addLog("Driver: Status is READY. Reading data from controller buffer.", ComponentType.driver);
    await Future.delayed(const Duration(seconds: 1));

    _setActive(ComponentType.app);
    _addLog("Application: Data received. Processing continues.", ComponentType.app);
  }

  Future<void> _runInterruptSimulation() async {
    // 1. App requests I/O
    _setActive(ComponentType.app);
    _addLog("Application requests I/O operation (Read File)", ComponentType.app);
    await Future.delayed(const Duration(seconds: 1));

    // 2. System Call
    _setActive(ComponentType.sysCall);
    _addLog("System Call: read() invoked.", ComponentType.sysCall);
    await Future.delayed(const Duration(seconds: 1));

    // 3. Driver initiates
    _setActive(ComponentType.driver);
    _addLog("Driver: Instructs Controller to start I/O.", ComponentType.driver);
    await Future.delayed(const Duration(seconds: 1));

    // 4. Controller starts
    _setActive(ComponentType.controller);
    _addLog("Controller: Starts Device I/O operation.", ComponentType.controller);
    await Future.delayed(const Duration(milliseconds: 500));

    // 5. CPU does other work
    _setActive(ComponentType.cpu);
    _addLog("CPU: Returns to User Mode. Executing other processes...", ComponentType.cpu);
    
    // Simulate parallel work
    for (int i = 0; i < 3; i++) {
       _addLog("CPU: Processing unrelated task ${i+1}...", ComponentType.cpu);
       await Future.delayed(const Duration(milliseconds: 800));
    }

    // 6. Device finishes
    _setActive(ComponentType.device);
    _addLog("I/O Device: Operation complete.", ComponentType.device);
    await Future.delayed(const Duration(milliseconds: 800));

    // 7. Interrupt Signal
    _setActive(ComponentType.controller);
    _addLog("Controller: Sends INTERRUPT signal to CPU.", ComponentType.controller);
    await Future.delayed(const Duration(seconds: 1));

    // 8. CPU Handles Interrupt
    _setActive(ComponentType.cpu);
    _addLog("CPU: Interrupt received! Suspending current process.", ComponentType.cpu);
    await Future.delayed(const Duration(milliseconds: 800));

    _setActive(ComponentType.driver);
    _addLog("ISR (Interrupt Service Routine): Transferring data.", ComponentType.driver);
    await Future.delayed(const Duration(seconds: 1));

    _setActive(ComponentType.app);
    _addLog("Application: Data available. Resuming original process.", ComponentType.app);
  }
}
