import 'package:flutter/material.dart';
import 'package:iptv_player/data/models/quick_source.dart';

/// Tutorial state manager to track progress through the guided onboarding
class TutorialState extends ChangeNotifier {
  static final TutorialState _instance = TutorialState._internal();
  factory TutorialState() => _instance;
  TutorialState._internal();

  bool _isActive = false;
  TutorialStep _currentStep = TutorialStep.none;
  QuickSource? _selectedSource;
  GlobalKey? _targetKey;

  bool get isActive => _isActive;
  TutorialStep get currentStep => _currentStep;
  QuickSource? get selectedSource => _selectedSource;
  GlobalKey? get targetKey => _targetKey;

  void startTutorial(QuickSource source) {
    _isActive = true;
    _selectedSource = source;
    _currentStep = TutorialStep.pressAddButton;
    notifyListeners();
  }

  void setTargetKey(GlobalKey key) {
    _targetKey = key;
    notifyListeners();
  }

  void nextStep() {
    switch (_currentStep) {
      case TutorialStep.pressAddButton:
        _currentStep = TutorialStep.selectInputUrl;
      case TutorialStep.selectInputUrl:
        _currentStep = TutorialStep.pasteUrl;
      case TutorialStep.pasteUrl:
        _currentStep = TutorialStep.savePlaylist;
      case TutorialStep.savePlaylist:
        _currentStep = TutorialStep.completed;
        _isActive = false;
      default:
    }
    notifyListeners();
  }

  void reset() {
    _isActive = false;
    _currentStep = TutorialStep.none;
    _selectedSource = null;
    _targetKey = null;
    notifyListeners();
  }

  String getInstructionText() {
    switch (_currentStep) {
      case TutorialStep.pressAddButton:
        return 'Tap the + button to add your first playlist';
      case TutorialStep.selectInputUrl:
        return 'Select "Input Playlist URL"';
      case TutorialStep.pasteUrl:
        return 'Paste the URL here (already in clipboard!)';
      case TutorialStep.savePlaylist:
        return 'Tap Save to add your playlist';
      case TutorialStep.completed:
        return 'Great! Your playlist is ready!';
      default:
        return '';
    }
  }
}

enum TutorialStep {
  none,
  pressAddButton,
  selectInputUrl,
  pasteUrl,
  savePlaylist,
  completed,
}
