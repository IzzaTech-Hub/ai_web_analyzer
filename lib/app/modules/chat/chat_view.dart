import 'package:ai_web_analyzer/app/fire_base/fire_base.dart';
import 'package:ai_web_analyzer/app/models/ai_handler.dart';
import 'package:ai_web_analyzer/app/models/current_content.dart';
import 'package:ai_web_analyzer/app/models/url_handler.dart';
import 'package:ai_web_analyzer/app/utills/remoteconfig_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_markdown/flutter_markdown.dart'; // For Markdown
import 'package:ai_web_analyzer/app/utills/size_config.dart'; // Assuming you still need this

class Message {
  final String text;
  final MessageType type;
  RxBool isReporeted = false.obs;

  Message({required this.text, required this.type});
}

enum MessageType { user, ai, note }

class ChatController extends GetxController {
  final FeedbackService feedbackService = FeedbackService();

  final RxList<Message> messages = <Message>[].obs;
  final TextEditingController textController = TextEditingController();
  submited(int index, BuildContext context) {
    messages[index].isReporeted.value = true;

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Thanks for your feedback!',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

// void reportMessage(BuildContext context, String message) {
  Future<void> reportMessage(
      BuildContext context, String message, int index) async {
    // String uniqueid = '1';
    // String uniqueid = await Purchases.appUserID;
    final TextEditingController customReasonController =
        TextEditingController();
    List<String> reasons = [
      "harmful/Unsafe",
      "Sexual Explicit Content",
      'Repetitive',
      'Hate and harrasment',
      'Misinformation',
      'Frauds and scam',
      "Spam",
      "Other"
    ];
    RxString selectedReason = "".obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Inappropriate Message"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select a reason:"),
                ...reasons.map((reason) {
                  return Obx(() => RadioListTile(
                        title: Text(reason),
                        value: reason,
                        groupValue: selectedReason.value,
                        onChanged: (value) {
                          selectedReason.value = value!;
                          if (selectedReason != "Other") {
                            customReasonController.clear();
                          }
                        },
                      ));
                }).toList(),
                Obx(() => selectedReason.value == "Other"
                    ? TextField(
                        controller: customReasonController,
                        decoration: const InputDecoration(
                          labelText: "Enter custom reason",
                        ),
                      )
                    : Container()),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Report"),
              onPressed: () async {
                String reportReason = selectedReason.value == "Other"
                    ? customReasonController.text
                    : selectedReason.value;
                print('$reportReason');
                if (reportReason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select or enter a reason.")),
                  );
                  return;
                }

                EasyLoading.show(status: "Please Wait...");
                // print('now easyloading');
                try {
                  // print('now ending easyloading');

                  Navigator.of(context).pop();
                  EasyLoading.dismiss();
                  submited(index, context);
                  await feedbackService.submitFeedback(
                      'FeedBack:$reportReason  Message:$message', false);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Message reported successfully.")),
                  // );
                  // generatedContent[index].isFeedBack.value = true;
                  // generatedContent[index].isGood.value = false;
                } catch (e) {
                  print(e);
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to report message: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Initialize the conversation history.  Make it Rx so the UI rebuilds when the history changes.
  final RxList<Content> history = <Content>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved chat history from local storage here if needed
  }

  @override
  void onClose() {
    // Save chat history to local storage here
    textController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    GenerativeModel aiModel = AiHandler.getAiModel();
    // GenerativeModel aiModel = GenerativeModel(
    //     model: 'gemini-2.0-flash-lite',
    //     // model: RCVariables.geminiModel,
    //     apiKey: 'AIzaSyCj-pkjlMrppk-ZNsPlkFq5U9t9jeUahr8',
    //     // apiKey: RCVariables.apiKey,
    //     // generationConfig: GenerationConfig(maxOutputTokens: 200),
    //     systemInstruction: Content.system('Act as a girl named rosy'));

    if (textController.text.trim().isEmpty) return;

    String userMessage = textController.text.trim();
    textController.clear();

    // Add user message immediately to the UI
    messages.add(Message(text: userMessage, type: MessageType.user));
    update(); // Notify UI to update

    EasyLoading.show(status: 'Thinking...');

    try {
      // print('here0');
      // print('model: ${RCVariables.geminiModel}, key ${RCVariables.apiKey}');

      // Prepare the content for the AI model.
      final content = Content('user', [TextPart(userMessage)]);
      // print('here1');
      // Add the user's message to the history.
      history.add(content);

      // Limit the history to the last 10 messages (5 user + 5 model).
      while (history.length > 20) {
        history.removeAt(0); // Remove the oldest message.
      }
      developer.log('${history.length}');
      // Use the `history` argument in `generateContent`.
      final response = await aiModel
          .generateContent(history.toList()); // Convert RxList to List
      // print('here2');

      if (response != null && response.text != null) {
        // print('here3');

        // Process the response
        String aiResponse = response.text!;

        // Add AI response to history and messages
        history.add(Content('model', [TextPart(aiResponse)]));

        // Limit the history *again* after adding the AI's response, for safety.
        while (history.length > 10) {
          history.removeAt(0);
        }

        messages.add(Message(text: aiResponse, type: MessageType.ai));
        update(); //update UI
      } else {
        // print('here4');

        // Handle no response or null text
        messages.add(Message(
            text: 'AI returned an empty response.', type: MessageType.note));
        update();
        developer.log('AI returned null response');
      }
    } catch (e) {
      // Handle errors during API call
      messages.add(Message(
          text: 'Please Check your Internet Connection',
          type: MessageType.note));
      // messages.add(Message(text: 'Error: $e', type: MessageType.note));
      developer.log('Error during AI response: $e');
    } finally {
      EasyLoading.dismiss();
      update(); // Ensure UI is updated after processing
    }
  }
}

// New Widget for Copying to Clipboard
class CopyToClipboardButton extends StatelessWidget {
  final String text;

  const CopyToClipboardButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 16),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied to clipboard')),
        );
      },
    );
  }
}

class ChatView extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return ChatBubble(message: message, index: index);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.textController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.red.shade400],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: controller.sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final int index;

  const ChatBubble({Key? key, required this.message, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.type == MessageType.user
            ? MainAxisAlignment.end
            : message.type == MessageType.ai
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.ai)
            CircleAvatar(
              radius: SizeConfig.blockSizeHorizontal * 4,
              backgroundColor: Colors.blueGrey.shade300,
              child: Icon(
                Icons.memory,
                color: Colors.amber,
                size: SizeConfig.blockSizeHorizontal * 5,
              ),
            ),
          const SizedBox(width: 8),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.type == MessageType.user
                        ? Colors.blue.shade600
                        : message.type == MessageType.ai
                            ? Colors.blueGrey.shade50
                            : Colors.red.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: message.type == MessageType.user
                          ? Radius.circular(12)
                          : message.type == MessageType.ai
                              ? Radius.circular(4)
                              : Radius.circular(12),
                      topRight: message.type == MessageType.user
                          ? Radius.circular(4)
                          : Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: message.type == MessageType.ai
                      ? MarkdownBody(
                          data: message.text,
                          styleSheet: MarkdownStyleSheet.fromTheme(
                                  Theme.of(context))
                              .copyWith(
                                  p: TextStyle(color: Colors.grey.shade800)),
                        )
                      : message.type == MessageType.user
                          ? Text(message.text,
                              style: const TextStyle(color: Colors.white))
                          : Text(message.text,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                ),
                Row(
                  children: [
                    if (message.type == MessageType.ai)
                      IconButton(
                        icon: const Icon(Icons.content_copy,
                            size: 16, color: Colors.grey),
                        onPressed: () => Clipboard.setData(
                            ClipboardData(text: message.text)),
                      ),
                    if (!message.isReporeted.value &&
                        message.type == MessageType.ai)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.thumb_up,
                                  size: 16, color: Colors.grey),
                              onPressed: () {
                                ChatController ctl = Get.find();
                                ctl.feedbackService
                                    .submitFeedback(message.text, true);
                                ctl.submited(index, context);
                              }),
                          IconButton(
                              icon: Icon(Icons.thumb_down,
                                  size: 16, color: Colors.grey),
                              onPressed: () async {
                                ChatController ctl = Get.find();
                                await ctl.reportMessage(
                                    context, message.text, index);
                              }),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
