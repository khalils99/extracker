import 'package:expense_management/core/widgets/back_button.dart';
import 'package:expense_management/features/expenses/data/repositories/expense_repo.dart';
import 'package:expense_management/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:qofi_comp/qofi_comp.dart';
import 'package:sizer/sizer.dart';

import '../bloc/add_expense_bloc.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseBloc(id)..add(InitAddExpense()),
      child: Scaffold(
        appBar: AppBar(
          leading: ButtonBack(),
        ),
        body: BlocConsumer<AddExpenseBloc, AddExpenseState>(
          listener: (context, state) {
            if (state is AddExpenseSuccess) {
              (id == null
                      ? "expense_added_successfully"
                      : "expense_updated_successfully")
                  .trs(context)
                  .showSnackBar(Theme.of(context).primaryColor, context);
              context.read<HomeBloc>().add(FetchAllData());
              context.pop();
              return;
            } else if (state is AddExpenseFailure) {
              state.message
                  .showSnackBar(Theme.of(context).colorScheme.error, context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
              ),
              child: SingleChildScrollView(
                  child: Form(
                key: context.read<AddExpenseBloc>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    2.high,
                    Text(
                      'add_New\nExpense'.trs(context),
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 21.5.ft,
                        fontWeight: 500.wt,
                      ),
                    ),
                    5.high,
                    ...List.from([
                      {
                        "title": "category",
                        "validator": (value) {
                          if (value?.isEmpty ?? true) {
                            return "category_cannot_be_empty".trs(context);
                          }
                          return null;
                        },
                        "onChanged": (value) {
                          context
                              .read<AddExpenseBloc>()
                              .add(PickCategory(value.toString()));
                        },
                        "type": "dropdown",
                        "value": ExpenseRepository()
                            .expenseCategories
                            .firstWhere(
                                (element) => element['name'] == state.category,
                                orElse: () => ExpenseRepository()
                                    .expenseCategories
                                    .first)['id'],
                        "items": ExpenseRepository().expenseCategories
                      },
                      {
                        "title": "title",
                        "hint": "enter_a_title".capitalizeAll,
                        "validator": (value) {
                          if (value.isEmpty) {
                            return "title_cannot_be_empty".trs(context);
                          }
                          return null;
                        },
                        "keyboardType": TextInputType.text,
                        "controller":
                            context.read<AddExpenseBloc>().titleController
                      },
                      {
                        "title": "amount",
                        "hint": "enter_an_amount".capitalizeAll,
                        "prefix": Container(
                          width: 25.w,
                          margin: EdgeInsets.only(right: 4.w),
                          child: Qofi.authTextField(e: {
                            "title": "currency",
                            "border": "none",
                            "validator": (value) {
                              if (value.isEmpty) {
                                return "currency_cannot_be_empty".trs(context);
                              }
                              return null;
                            },
                            "onChanged": (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(PickCurrency(value.toString()));
                            },
                            "value": ExpenseRepository().currencies.firstWhere(
                                (element) => element['name'] == state.currency,
                                orElse: () =>
                                    ExpenseRepository().currencies.first)['id'],
                            "type": "dropdown",
                            "items": ExpenseRepository().currencies
                          }),
                        ),
                        "validator": (value) {
                          if (value.isEmpty) {
                            return "amount_cannot_be_empty".trs(context);
                          }
                          if (double.tryParse(value) == null) {
                            return "amount_must_be_a_number".trs(context);
                          }
                          return null;
                        },
                        "inputFormatters": [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        "keyboardType":
                            TextInputType.numberWithOptions(decimal: true),
                        "controller":
                            context.read<AddExpenseBloc>().amountController
                      },
                      {
                        "title": "date",
                        "hint": "select_a_date".capitalizeAll,
                        "controller":
                            context.read<AddExpenseBloc>().dateController,
                        "readOnly": true,
                        "validator": (value) {
                          if (state.date == null) {
                            return "date_cannot_be_empty".trs(context);
                          }
                          return null;
                        },
                        'onTap': () {
                          context.read<AddExpenseBloc>().add(PickDateEvent(
                              context: context, selectedDate: state.date));
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
                        title: "add_expense".trs(context),
                        loading: state is AddExpenseLoading,
                        onPressed: () {
                          if (context
                                  .read<AddExpenseBloc>()
                                  .formKey
                                  .currentState
                                  ?.validate() !=
                              true) return;
                          context.read<AddExpenseBloc>().add(AddExpense(
                              title: context
                                  .read<AddExpenseBloc>()
                                  .titleController
                                  .text,
                              currency: state.currency!,
                              amount: double.parse(context
                                  .read<AddExpenseBloc>()
                                  .amountController
                                  .text),
                              category: state.category!,
                              date: state.date!));
                        }),
                  ],
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}
