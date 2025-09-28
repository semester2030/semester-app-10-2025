import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class ResetPasswordView extends HookConsumerWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    var currentPasswordController = useTextEditingController();
    var newPasswordController = useTextEditingController();
    var confirmNewPasswordController = useTextEditingController();

    // Add state variables for form validation
    final isLoading = useState(false);
    final currentPasswordError = useState<String?>(null);
    final newPasswordError = useState<String?>(null);
    final confirmPasswordError = useState<String?>(null);

    // Function to show success dialog
    void showPasswordChangeSuccessDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: whiteColor,
          title: Text(
            l10n.success,
            style: montserrat(14, accentPurple, FontWeight.w600),
          ),
          content: Text(
            l10n.passwordChangedSuccessfully,
            style: montserrat(12, accentPurple, FontWeight.w500),
          ),
          actions: [
            NormalCustomButton(
              label: l10n.ok,
              syncCallback: () => Navigator.pop(context),
              width: 100,
              height: 30,
              titleStyle: montserrat(12, whiteColor, FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // Function to validate and change password
    Future<void> changePassword() async {
      // Reset error states
      currentPasswordError.value = null;
      newPasswordError.value = null;
      confirmPasswordError.value = null;

      // Validate fields
      bool isValid = true;

      if (currentPasswordController.text.isEmpty) {
        currentPasswordError.value = l10n.currentPasswordRequired;
        isValid = false;
      }

      if (newPasswordController.text.isEmpty) {
        newPasswordError.value = l10n.newPasswordRequired;
        isValid = false;
      } else if (newPasswordController.text.length < 8) {
        newPasswordError.value = l10n.passwordMinLength;
        isValid = false;
      } else if (!validatePassword(newPasswordController.text)) {
        newPasswordError.value = l10n.passwordComplexityError;
        isValid = false;
      }

      if (confirmNewPasswordController.text.isEmpty) {
        confirmPasswordError.value = l10n.confirmPasswordRequired;
        isValid = false;
      } else if (newPasswordController.text !=
          confirmNewPasswordController.text) {
        confirmPasswordError.value = l10n.passwordsDoNotMatch;
        isValid = false;
      }

      if (!isValid) return;

      try {
        isLoading.value = true;
        showLoadingDialog(context, l10n.changingPassword);

        // Get current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception(l10n.noUserLoggedIn);
        }

        // Get current user email
        final email = user.email;
        if (email == null) {
          throw Exception(l10n.userEmailNotAvailable);
        }

        // Re-authenticate user with current password
        final credential = EmailAuthProvider.credential(
          email: email,
          password: currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Update password in Firebase Authentication
        await user.updatePassword(newPasswordController.text);

        // Update password in Firestore (if your app stores passwords there)
        // await userCollection
        //     .doc(user.uid)
        //     .update({'password': newPasswordController.text});

        // Close loading dialog
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Clear form fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        // Show success dialog
        if (context.mounted) {
          showPasswordChangeSuccessDialog();
        }
      } on FirebaseAuthException catch (e) {
        // Close loading dialog
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Handle different error cases
        switch (e.code) {
          case 'wrong-password':
            currentPasswordError.value = l10n.currentPasswordIncorrect;
            break;
          case 'requires-recent-login':
            showErrorFlushBar(
                message: l10n.recentLoginRequired, context: context);
            break;
          default:
            showErrorDialog(context, l10n.passwordChangeFailedTitle,
                l10n.passwordChangeFailedMessage);
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        showErrorFlushBar(
            message: 'An error occurred: ${e.toString()}', context: context);
      } finally {
        isLoading.value = false;
      }
    }

    Widget buildRequirement(String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 20.h,
                width: 20.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: accentPurple),
                child: Icon(Icons.check, color: whiteColor, size: 15)),
            12.horizontalSpace,
            Expanded(
              child: Text(
                text,
                style: montserrat(14, grey36, FontWeight.w400),
              ),
            ),
          ],
        ),
      );
    }

    return ScreenWithTopAppbar(
      title: l10n.resetPassword,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 160.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  25.verticalSpace,
                  Text(
                    l10n.resetPasswordDescription,
                    style: montserrat(12, grey36, FontWeight.w400)
                        .copyWith(letterSpacing: 0.4),
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.passwordMustContain,
                      style: montserrat(16, grey36, FontWeight.w500),
                    ),
                  ),
                  10.verticalSpace,
                  buildRequirement(l10n.atLeast8Characters),
                  buildRequirement(l10n.atLeastOneUppercase),
                  buildRequirement(l10n.atLeastOneLowercase),
                  buildRequirement(l10n.atLeastOneNumber),
                  buildRequirement(l10n.atLeastOneSpecialChar),
                  22.verticalSpace,
                  20.verticalSpace,
                  PasswordTextField(
                      controller: currentPasswordController,
                      titleText: l10n.password),
                  if (currentPasswordError.value != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
                        children: [
                          Text(
                            currentPasswordError.value!,
                            style: montserrat(12, Colors.red, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  15.verticalSpace,
                  PasswordTextField(
                      controller: newPasswordController,
                      titleText: l10n.newPassword),
                  if (newPasswordError.value != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              newPasswordError.value!,
                              style:
                                  montserrat(12, Colors.red, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  15.verticalSpace,
                  PasswordTextField(
                      controller: confirmNewPasswordController,
                      titleText: l10n.confirmNewPassword),
                  if (confirmPasswordError.value != null)
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              confirmPasswordError.value!,
                              style:
                                  montserrat(12, Colors.red, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Spacer(),
          NormalCustomButton(
            width: 300,
            label: l10n.updatePassword,
            syncCallback: isLoading.value ? null : changePassword,
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}
