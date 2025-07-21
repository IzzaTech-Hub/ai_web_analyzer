import 'package:ai_web_analyzer/app/models/current_content.dart';
import 'package:ai_web_analyzer/app/models/pdf_handler.dart';
import 'package:ai_web_analyzer/app/models/url_handler.dart';
import 'package:ai_web_analyzer/app/utills/remoteconfig_variables.dart';
import 'package:api_key_pool/api_key_pool.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiHandler {
  static String chattype = '';

  static GenerativeModel getAiModel() {
    if (chattype == 'url') {
      return GenerativeModel(
          model: RCVariables.geminiModel,
          // apiKey: RCVariables.apiKey,
          apiKey: ApiKeyPool.getKey(),
          // generationConfig: GenerationConfig(maxOutputTokens: 200),
          systemInstruction: Content.system(
              'Act as a web data analyzer and professional content analyzer and gather some information about this webpage: ${UrlHandler.url} and the content of this webpage is ${WebContentManager.currentContent} and than answer the queries of user. try your best to answer it accordingly from this webpage and if there is not enough information than return a made of answer but very much accurate as you can. Try your best to make accurate precise and short possible answer.'));
    } else if (chattype == 'pdf') {
      return GenerativeModel(
          model: RCVariables.geminiModel,
          // apiKey: RCVariables.apiKey,
          apiKey: ApiKeyPool.getKey(),

          // generationConfig: GenerationConfig(maxOutputTokens: 200),
          systemInstruction: Content.system(
              'Act as a professional content analyzer and analyze information of this pdf file content: (${PdfHandler.pdfText}) and than answer the queries of user. try your best to answer it accordingly from this pdf and if there is not enough information than return a made of answer but very much accurate as you can. Try your best to make accurate precise and short possible answer.'));
    } else {
      return GenerativeModel(
        model: RCVariables.geminiModel,
        // apiKey: RCVariables.apiKey,
          apiKey: ApiKeyPool.getKey(),

        // generationConfig: GenerationConfig(maxOutputTokens: 200),
      );
    }
  }
}
