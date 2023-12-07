import 'dart:convert';
import 'dart:typed_data';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start FastAPI Group Code

class FastAPIGroup {
  static String baseUrl = 'https://questgenix.onrender.com';
  static Map<String, String> headers = {};
  static GeneratequestionsCall generatequestionsCall = GeneratequestionsCall();
  static EvaluateAnswersEvaluateAnswersPostCall
      evaluateAnswersEvaluateAnswersPostCall =
      EvaluateAnswersEvaluateAnswersPostCall();
}

class GeneratequestionsCall {
  Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "topic": "",
  "languages": [
    ""
  ],
  "level": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'generatequestions',
      apiUrl: '${FastAPIGroup.baseUrl}/generate_questions',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class EvaluateAnswersEvaluateAnswersPostCall {
  Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "qa_pairs": [
    {
      "question": "",
      "answer": ""
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'evaluate_answers_evaluate_answers__post',
      apiUrl: '${FastAPIGroup.baseUrl}/evaluate_answers/',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

/// End FastAPI Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
