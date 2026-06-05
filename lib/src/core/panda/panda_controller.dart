import 'package:rive/rive.dart';
import 'panda_state.dart';

class PandaController {
  StateMachineController? _riveController;

  SMINumber? energyLevel;
  SMINumber? moodIndex;
  SMIBool? isPlaying;
  SMIBool? isBuffering;
  SMIBool? hasError;
  SMITrigger? beatDrop;

  void init(Artboard artboard) {
    _riveController = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (_riveController != null) {
      artboard.addController(_riveController!);

      energyLevel = _riveController!.findSMI('energyLevel') as SMINumber?;
      moodIndex = _riveController!.findSMI('moodIndex') as SMINumber?;
      isPlaying = _riveController!.findSMI('isPlaying') as SMIBool?;
      isBuffering = _riveController!.findSMI('isBuffering') as SMIBool?;
      hasError = _riveController!.findSMI('hasError') as SMIBool?;
      beatDrop = _riveController!.findSMI('beatDrop') as SMITrigger?;

      // Default state
      energyLevel?.value = 0.0;
      moodIndex?.value = PandaMood.neutral.index.toDouble();
      isPlaying?.value = false;
      isBuffering?.value = false;
      hasError?.value = false;
    }
  }

  void onAmplitudeUpdate(double amplitude) {
    if (energyLevel != null) {
      energyLevel!.value = amplitude;
      if (amplitude > 0.85) {
        beatDrop?.fire();
      }
    }
  }

  void onMoodChange(PandaMood mood) {
    moodIndex?.value = mood.index.toDouble();
  }

  void onPlaybackStateChange(PlaybackMood state) {
    isPlaying?.value = state == PlaybackMood.playing;
    isBuffering?.value = state == PlaybackMood.buffering;
    hasError?.value = state == PlaybackMood.error;
  }

  void dispose() {
    _riveController?.dispose();
  }
}
