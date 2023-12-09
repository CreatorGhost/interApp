import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'qa_page_model.dart';
export 'qa_page_model.dart';
import '../question.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;


class QaPageWidget extends StatefulWidget {
  final List<Question> questions;

  const QaPageWidget({
    Key? key,
    required this.questions,
  }) : super(key: key);

  @override
  _QaPageWidgetState createState() => _QaPageWidgetState();
}

class _QaPageWidgetState extends State<QaPageWidget> {
  late QaPageModel _model;
  int currentQuestionIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isEvaluationComplete = false;
  int? score;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  List<Map<String, String>>? correctAnswers;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QaPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _model.textController?.dispose();
    _model.textFieldFocusNode?.dispose();
    _speech.cancel();
    super.dispose();
  }

Future<void> someAsyncOperation() async {
  // Perform some asynchronous work...
  await Future.delayed(Duration(seconds: 1));

  // Check if the State object is still mounted before trying to access the FocusNode
  if (mounted) {
    // It's safe to access the FocusNode here
    _model.textFieldFocusNode?.requestFocus();
  }
}

  double _confidence = 1.0;
  void startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) {
        print('onError: $errorNotification');
        if (errorNotification.errorMsg == 'error_no_match') {
          // Handle the no match error, possibly by restarting the listener or informing the user
          print('No speech input recognized. Try speaking again.');
          // Optionally, restart listening here or provide a button for the user to try again
        }
      },
    );
    if (available) {
      setState(() {
        _isListening = true;
        _confidence = 1.0; // Reset confidence to the maximum value
      });
      _speech.listen(
        onResult: (result) {
          print('onResult: ${result.recognizedWords}'); // Debug print
          if (result.recognizedWords.isNotEmpty) {
            setState(() {
              _model.textController?.text = result.recognizedWords;
              // If you want to use the confidence level
              if (result.hasConfidenceRating && result.confidence > 0) {
                _confidence = result.confidence;
              }
            });
            print(
                'TextController text: ${_model.textController?.text}'); // Debug print
          }
        },
        listenFor:
            Duration(seconds: 30), // Listen for speech for a longer duration
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void stopListening() async {
    setState(() => _isListening = false);
    await _speech.stop();
  }

  Future<void> evaluateAnswers() async {
    final List<Map<String, String>> qaPairs = widget.questions
        .map((question) => {
              "question": question.text,
              "answer": question.answer ??
                  "", // Use an empty string if the answer is null
            })
        .toList();

    final Map<String, dynamic> requestBody = {"qa_pairs": qaPairs};
    final String apiUrl = "https://questgenix.onrender.com/evaluate_answers/";

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          isEvaluationComplete = true;
          final responseData = json.decode(response.body);
          score = responseData['score'];
          correctAnswers =
              List<Map<String, String>>.from(responseData['correct_answers']);
        });
      } else {
        // Handle error response
        final errorData = json.decode(response.body);
        final errorDetail = errorData['detail'];
        print('Failed to evaluate answers. Error: $errorDetail');
      }
    } catch (error) {
      // Handle network error
      print('Network error occurred: $error');
    }
  }

  void submitAnswer() {
    setState(() {
      // Map the answer to the current question
      widget.questions[currentQuestionIndex].answer =
          _model.textController?.text;
      // Check if there are more questions
      if (currentQuestionIndex < widget.questions.length - 1) {
        // Move to the next question
        currentQuestionIndex++;
        // Clear the answer field
        _model.textController?.clear();
      } else {
        evaluateAnswers();
      }
    });
  }
@override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme-aware background color
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Text(
                'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
                style: theme.textTheme.headline6, // Use theme-aware text style
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Text(
                widget.questions[currentQuestionIndex].text,
                style: theme.textTheme.bodyText2, // Use theme-aware text style
              ),
            ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: theme.iconTheme.color, // Use theme-aware icon color
              ),
              onPressed: _isListening ? stopListening : startListening,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Enter your answer here...',
                  hintStyle: theme.textTheme.bodyLarge, // Use theme-aware text style
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor, // Use theme-aware border color
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.secondary, // Use theme-aware border color
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: theme.textTheme.bodyMedium, // Use theme-aware text style
                minLines: 1,
                maxLines: 3,
                cursorHeight: 20.0,
                validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex < widget.questions.length - 1) {
                    submitAnswer();
                  } else {
                    evaluateAnswers();
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor, // Use theme-aware button color
                  foregroundColor: theme.colorScheme.onPrimary, // Use theme-aware text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}