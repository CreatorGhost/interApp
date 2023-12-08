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
    // Dispose of the text controller and focus node
    _model.textController?.dispose();
    _model.textFieldFocusNode?.dispose();

    // Stop the speech recognition if it's currently active
    _speech.cancel();

    super.dispose();
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
          print('TextController text: ${_model.textController?.text}'); // Debug print
        }
      },
      listenFor: Duration(seconds: 30), // Listen for speech for a longer duration
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
    // Check if the evaluation is complete and display the score if it is
    if (isEvaluationComplete) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF7F8385),
        body: SafeArea(
          top: true,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Evaluation Complete!',
                  style: FlutterFlowTheme.of(context).headlineMedium,
                ),
                SizedBox(height: 24),
                Text(
                  'Your Score: $score',
                  style: FlutterFlowTheme.of(context).titleLarge,
                ),
                // Optionally display correct answers or provide a button to view them
                // ...
              ],
            ),
          ),
        ),
      );
    }

    // If the evaluation is not complete, display the current question
    final currentQuestion = widget.questions[currentQuestionIndex];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
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
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Urbanist',
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Text(
                currentQuestion.text,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Manrope',
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
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
                  hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primaryText,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Manrope',
                      letterSpacing: 1.0,
                    ),
                minLines: 1,
                maxLines: 3, // Limit the max lines to reduce text area size
                cursorHeight: 20.0, // Adjust cursor height
                validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: FFButtonWidget(
                onPressed: () {
                  if (currentQuestionIndex < widget.questions.length - 1) {
                    // Submit the current answer and move to the next question
                    submitAnswer();
                  } else {
                    // No more questions, evaluate the answers
                    evaluateAnswers();
                  }
                },
                text: 'Submit',
                options: FFButtonOptions(
                  width: 150.0,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Manrope',
                        color: Colors.white,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
