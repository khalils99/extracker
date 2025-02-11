import 'package:expense_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:qofi_comp/qofi_comp.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/assets/app_images.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.replace("/home");
              return;
            }
            if (state is AuthError) {
              state.message
                  .showSnackBar(Theme.of(context).colorScheme.error, context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "create_an_account".trs(context),
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 18.5.ft,
                        fontWeight: 600.wt,
                      ),
                    ),
                    SizedBox(
                      height: 0.8.h,
                    ),
                    Text(
                      "register_with_social_or_fill_the_form_to_continue"
                          .trs(context),
                      style: TextStyle(
                        color: Theme.of(context).dividerColor,
                        fontWeight: 500.wt,
                        letterSpacing: -0.1,
                        fontSize: 14.ft,
                      ),
                    ),
                    3.high,
                    ...List.from([
                      {
                        "title": "email",
                        "prefix": AppImages.emailSvg,
                        "keyboardType": TextInputType.emailAddress,
                        "hint": "albertstefano@gmail.com",
                        "controller": emailController,
                        "required": true,
                      },
                      {
                        "title": "password",
                        "prefix": AppImages.lockSvg,
                        "hint": "**********",
                        "required": true,
                        "obscure": !state.passwordVisible,
                        "controller": passwordController,
                        "keyboardType": TextInputType.visiblePassword,
                        "validator": (value) {
                          if (value.length < 6) {
                            return "password_must_be_at_least_6_characters"
                                .trs(context);
                          }
                          return null;
                        },
                        "suffix": AppImages.eyeSvg,
                        "onSuffixPressed": () {
                          context
                              .read<AuthBloc>()
                              .add(TogglePasswordVisibilityEvent());
                        }
                      },
                      {
                        "title": "confirm_password",
                        "prefix": AppImages.lockSvg,
                        "obscure": !state.confirmPasswordVisible,
                        "controller": confirmPasswordController,
                        "hint": "confirm_password",
                        "validator": (value) {
                          if (value != passwordController.text) {
                            return "passwords_do_not_match".trs(context);
                          }
                          return null;
                        },
                        "keyboardType": TextInputType.visiblePassword,
                        "suffix": AppImages.eyeSvg,
                        "onSuffixPressed": () {
                          context
                              .read<AuthBloc>()
                              .add(ToggleConfirmPasswordVisibilityEvent());
                        }
                      }
                    ].map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e['title'] != null) ...[
                            RichText(
                                text: TextSpan(
                                    text: "${e['title']}".trs(context),
                                    style: TextStyle(
                                        fontSize: 14.ft,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.fontFamily,
                                        color: Theme.of(context).canvasColor,
                                        fontWeight: 400.wt),
                                    children: [
                                  if (e['required'] == true ||
                                      e['validator'] != null)
                                    TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ))
                                ])),
                          ],
                          1.high,
                          Qofi.authTextField(e: e),
                          SizedBox(
                            height: 1.5.h,
                          )
                        ],
                      );
                    })),
                    4.high,
                    Qofi.primaryButton(
                      title: "continue",
                      loading: state is AuthLoading,
                      onPressed: () {
                        if (formKey.currentState?.validate() != true) return;
                        FocusScope.of(context).unfocus();
                        context.read<AuthBloc>().add(SignUpEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text));
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "already_have_an_account?".trs(context),
                            style: TextStyle(
                              color: Theme.of(context).dividerColor,
                              fontSize: 14.5.ft,
                              fontWeight: 400.wt,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(2.w),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero),
                          onPressed: () {
                            context.replace('/login');
                          },
                          child: Text("login".trs(context),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14.5.ft,
                                fontWeight: 400.wt,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
