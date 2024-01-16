/* import 'package:in_app_update/in_app_update.dart';

class UpdateHandler {
  Future<void> checkForUpdate() async {
    final InAppUpdate inAppUpdate = InAppUpdate();
    final result = await inAppUpdate.checkForUpdate();

    if (result.updateAvailable) {
      // Show a notification or dialog to inform the user about the update.
      // You can customize this based on your UI/UX design.
      final bool isUpdateAllowed = await inAppUpdate.promptUser();
      if (isUpdateAllowed) {
        // Start the update process
        await inAppUpdate.performImmediateUpdate();
      }
    } else {
      // No update available
      // You can add your own logic here if needed
      print('No update available');
    }
  }
}
 */