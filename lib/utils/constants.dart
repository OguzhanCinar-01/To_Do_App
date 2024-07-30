import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:hive_todo/main.dart';
import 'package:hive_todo/utils/app_str.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';

/// Empty Title or Subtitle Textfield Warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: AppStr.emptyWarningsubMsg,
    corner: 20,
    duration: 1800,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: AppStr.updateTaskWarningsubMsg,
    corner: 20,
    duration: 5000,
    padding: const EdgeInsets.all(20),
  );
}

/// No Task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message: AppStr.noTaskWarningMsg,
    buttonText: 'Okay',
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// Delete All Task from DB Dialog
dynamic deleteAllTaskDialog(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message:
        'Do you really want to delete all tasks? You will no be able to recover them.',
    confirmButtonText: 'Yes',
    cancelButtonText: 'No',
    onTapConfirm: () {
      /// This line delete all tasks from Hive DB
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
