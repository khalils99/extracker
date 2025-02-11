import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:qofi_comp/qofi_comp.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/assets/app_images.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'expense_management'.trs(context),
      )),
      body: BlocConsumer<AuthBloc, AuthState>(
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    4.high,
                    Text(
                      "login".trs(context),
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 18.5.ft,
                        fontWeight: 600.wt,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "please_sign_in_to_your_account".trs(context),
                      style: TextStyle(
                        color: Theme.of(context).dividerColor,
                        fontWeight: 500.wt,
                        fontSize: 14.ft,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    ...List.from([
                      {
                        "title": "username",
                        "prefix": AppImages.profileSvg,
                        "hint": "email_or phone".capitalizeAll,
                        "validator": (value) {
                          if (value.isEmpty) {
                            return "username_cannot_be_empty".trs(context);
                          }
                          return null;
                        },
                        "controller": emailController,
                        "keyboardType": TextInputType.emailAddress
                      },
                      {
                        "title": "password",
                        "prefix": AppImages.lockSvg,
                        "hint": "**********",
                        "controller": passwordController,
                        "validator": (value) {
                          if (value.isEmpty) {
                            return "password_cannot_be_empty".trs(context);
                          }
                          return null;
                        },
                        "obscure": !(state).passwordVisible,
                        "keyboardType": TextInputType.visiblePassword,
                        "suffix": AppImages.eyeSvg,
                        "onSuffixPressed": () {
                          context
                              .read<AuthBloc>()
                              .add(TogglePasswordVisibilityEvent());
                        }
                      },
                    ].map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${e['title']}".trs(context),
                            style: TextStyle(
                                fontSize: 14.ft,
                                color: Theme.of(context).canvasColor,
                                fontWeight: 400.wt),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Qofi.authTextField(e: e),
                          SizedBox(
                            height: 2.h,
                          )
                        ],
                      );
                    })),
                    3.high,
                    Qofi.primaryButton(
                      title: "login",
                      loading: state is AuthLoading,
                      onPressed: () {
                        if (formKey.currentState?.validate() == true) {
                          FocusScope.of(context).unfocus();
                          context.read<AuthBloc>().add(SignInEvent(
                              emailController.text, passwordController.text));
                        }
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    3.high,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "${"dont_have_an_account?".trs(context)}",
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
                            context.replace('/signup');
                          },
                          child: Text("register".trs(context),
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
            ),
          );
        },
      ),
    );
  }
}
