import 'package:ai_web_analyzer/app/utills/remoteconfig_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class ChatViewCTL extends GetxController {
  String apiKey = RCVariables.apiKey;


  final List<
      ({
        Image? image,
        String? text,
        bool fromUser,
        RxBool isFeedBack,
        RxBool isGood
      })> generatedContent = <({
    Image? image,
    String? text,
    bool fromUser,
    RxBool isFeedBack,
    RxBool isGood
  })>[];

  final count = 0.obs;
  @override
  void onInit() {
    // randomPrompts = getRandomPrompts();

    // EasyLoading.init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

// void reportMessage(BuildContext context, String message) {
  void reportMessage(BuildContext context, String message) async {
    String uniqueid = '1';
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
                print('now easyloading');
                try {
                  print('now ending easyloading');

                  Navigator.of(context).pop();
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Message reported successfully.")),
                  );
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

  // void GoodResponse(String message) {
  void GoodResponse(String message, int index) {
    print("GoodResponse reported..");
    // feedbackMessages.add(message);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text("Feedback saved successfully")),
    );
    print("GoodResponse reported....");

    generatedContent[index].isFeedBack.value = true;
    generatedContent[index].isGood.value = true;
  }
}
