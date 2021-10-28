import 'dart:developer';

import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxInt tabIndex = 0.obs;
  final SpeechToText _speechToText = SpeechToText();
  //GETTER TO RETURN INSTANCE OF SPEECH TO TEXT.
  SpeechToText get speechToText => _speechToText;
  //FUNCTION GETTERS.
  get startListening => _startListening();
  get stopListening => _stopListening();

  RxBool speechEnabled = false.obs;
  RxString lastWords = ''.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _initSpeech(); // FUNCTION TO CALL ONLY ONCE AN APP IS INITIALIZED.
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled(await _speechToText.initialize());
    print('SPEECH ENABLED BOOL : $speechEnabled');
    //setState(() {});
    update();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      pauseFor: const Duration(seconds: 5),
      listenFor: const Duration(seconds: 20),
      //cancelOnError: ,
    );
    update();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    // setState(() {});
    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords(result.recognizedWords);
    update();
    print('LIST OF WORDS: ${result.alternates}');
    log(lastWords());
  }

  @override
  void onClose() {}
}
