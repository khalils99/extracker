import 'package:expense_management/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/assets/app_images.dart';
import '../../../../core/widgets/back_button.dart';
import '../../domain/models/expense_model.dart';

class AllExpenseView extends StatelessWidget {
  const AllExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("all_expenses".trs(context)),
              leading: ButtonBack(),
              actions: [
                if (state is HomeLoaded && state.expenses.isNotEmpty)
                  PopupMenuButton(
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      onSelected: (value) {
                        if (value == "pdf") {
                          context.read<HomeBloc>().add(DownloadPdfEvent());
                        } else {
                          context.read<HomeBloc>().add(DownloadExcelEvent());
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: "pdf",
                            child: Text("print_pdf".trs(context)),
                          ),
                          PopupMenuItem(
                            value: "excel",
                            child: Text("download_excel".trs(context)),
                          ),
                        ];
                      },
                      child: SvgPicture.asset(
                        AppImages.downloadSvg,
                      )),
                4.wide,
              ],
            ),
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                context.push("/add-expense");
              },
              child: Icon(Icons.add),
            ),
            body: Builder(builder: (context) {
              if (state is HomeLoaded) {
                if (state.expenses.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 2.h),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        ExpenseModel expense = state.expenses[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.2.h),
                          margin: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                              boxShadow: boxShadow(6),
                              borderRadius: BorderRadius.circular(12.sp),
                              color: Theme.of(context).cardColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 0.4.h),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .elevatedButtonTheme
                                          .style
                                          ?.backgroundColor
                                          ?.resolve({})?.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: Text(expense.category,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .elevatedButtonTheme
                                                .style
                                                ?.textStyle
                                                ?.resolve({})?.color,
                                            fontSize: 13.ft,
                                            fontWeight: 700.wt)),
                                  ),
                                  Spacer(),
                                  Text(
                                      DateFormat("MMM dd, yyyy")
                                          .format(expense.date),
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 13.ft,
                                      )),
                                ],
                              ),
                              1.high,
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(expense.title,
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 14.5.ft,
                                        )),
                                  ),
                                  Text(
                                      "${expense.currency} ${expense.amount.formatCurrency(decimal: 2)}",
                                      style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 15.5.ft,
                                      )),
                                ],
                              ),
                              Divider(
                                color: Theme.of(context).dividerColor,
                                thickness: 0.5,
                              ),
                              1.high,
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "${"created".trs(context)}: ${DateFormat("MMM dd, yyyy").format(expense.createdAt)} ${DateFormat("hh:mm aa").format(expense.createdAt)}",
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 13.5.ft,
                                        )),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        context.push(
                                            "/add-expense?id=${expense.id}");
                                      },
                                      style: iconButtonStyle,
                                      child: SvgPicture.asset(
                                        AppImages.editSvg,
                                        color: Theme.of(context).dividerColor,
                                      )),
                                  3.wide,
                                  TextButton(
                                      onPressed: () {
                                        context
                                            .read<HomeBloc>()
                                            .add(DeleteExpense(expense.id));
                                      },
                                      style: iconButtonStyle,
                                      child: SvgPicture.asset(
                                        AppImages.deleteSvg,
                                        width: 4.25.w,
                                        color: Theme.of(context).dividerColor,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return SizedBox(
                    height: 80.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppImages.emptySvg,
                            width: 30.w,
                          ),
                          2.high,
                          Text(
                            "no_expenses_added".trs(context),
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 14.ft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return SizedBox();
            }));
      },
    );
  }
}
