import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_prefrence_model.dart';
export 'user_prefrence_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPrefrenceWidget extends StatefulWidget {
  const UserPrefrenceWidget({Key? key}) : super(key: key);

  @override
  _UserPrefrenceWidgetState createState() => _UserPrefrenceWidgetState();
}

class _UserPrefrenceWidgetState extends State<UserPrefrenceWidget> {
  late UserPrefrenceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
  String? _selectedLevel;
  @override
  void initState() {
    super.initState();
    _selectedLevel = _levels.first; // Initialize with the first value
    _model = createModel(context, () => UserPrefrenceModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    // Dispose of text controllers and focus nodes
    _model.textController1?.dispose();
    _model.textFieldFocusNode1?.dispose();
    _model.textController2?.dispose();
    _model.textFieldFocusNode2?.dispose();
    _model.textController3?.dispose();
    _model.textFieldFocusNode3?.dispose();

    // Dispose of any other resources or listeners the model might hold
    _model.dispose();

    // Always call super.dispose() at the end of the dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Post',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Urbanist',
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: TextFormField(
                  controller: _model.textController1,
                  focusNode: _model.textFieldFocusNode1,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    hintText: 'Enter topic',
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
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator:
                      _model.textController1Validator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: TextFormField(
                  controller: _model.textController2,
                  focusNode: _model.textFieldFocusNode2,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Languages',
                    hintText: 'Enter languages',
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
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator:
                      _model.textController2Validator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLevel = newValue;
                    });
                  },
                  items: _levels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Level',
                    hintText: 'Select level',
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
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a level' : null,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    final topic = _model.textController1.text;
                    final languages = _model.textController2.text
                        .split(',') // Split the string into a list
                        .map((language) => language.trim()) // Trim whitespace
                        .where((language) =>
                            language.isNotEmpty) // Remove any empty strings
                        .toList(); // Convert to a List
                    final level = _selectedLevel;

                    // Construct the request body
                    final body = json.encode({
                      "topic": topic,
                      "languages": languages,
                      "level": level,
                    });

                    // Set headers for the request
                    final headers = {
                      'Content-Type': 'application/json',
                    };

                    // Make the POST request
                    try {
                      final response = await http.post(
                        Uri.parse(
                            'https://questgenix.onrender.com/generate_questions'),
                        headers: headers,
                        body: body,
                      );

                      // Check if the request was successful
                      if (response.statusCode == 200) {
                        // Parse the response body
                        final responseData = json.decode(response.body);
                        print('Response data: $responseData');
                      } else {
                        // If the server did not return a 200 OK response,
                        // throw an exception.
                        throw Exception(
                            'Failed to load data. Status code: ${response.statusCode}');
                      }
                    } catch (e) {
                      print('Caught exception: $e');
                    }
                  },
                  text: 'Submit',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 55.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                            ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
