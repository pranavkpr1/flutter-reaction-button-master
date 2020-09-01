import 'package:audioplayers/audio_cache.dart';

class SoundService{

  AudioCache audioCache = new AudioCache();
  Future playSound(String nameSound) async {
    await audioCache.play('sounds/$nameSound');
  }
  static final SoundService _soundSingleton = new SoundService._internal();
  factory SoundService() {
    return _soundSingleton;
  }
  SoundService._internal();

}
SoundService SoundUtility=new SoundService();