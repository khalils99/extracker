import 'package:expense_management/features/expenses/data/repositories/expense_repo.dart';
import 'package:expense_management/features/expenses/domain/models/expense_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:qofi_comp/qofi_comp.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/assets/app_images.dart';
import '../../../../core/theme/theme_bloc.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> lightColors = [
      Color(0xFF84FFFF),
      Color(0xFFFF8A80),
      Color(0xFFFFF59D),
      Color(0xFFA5D6A7),
      Color(0xFFCE93D8),
      Color(0xFFFFCC80),
      Color(0xFF80DEEA),
      Color(0xFFFFAB91),
      Color(0xFFE6EE9C),
      Color(0xFFB39DDB),
    ];

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LoggedOutUser) {
          context.replace('/login');
        }
      },
      builder: (context, state) {
        String s = state is HomeLoaded
            ? ExpenseRepository()
                .currencies
                .firstWhere((e) => e['name'] == state.currency)['symbol']
            : "AED";
        double total = state is HomeLoaded
            ? state.data['graph'].fold(0, (sum, item) => sum + item['total'])
            : 0;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: boxShadow(6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.sp),
                    bottomRight: Radius.circular(24.sp),
                  ),
                ),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 4.w,
                    right: 4.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Welcome'.trs(context),
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 14.5.ft,
                              fontWeight: 500.wt,
                            ),
                          ),
                        ),
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return IconButton(
                                onPressed: () {
                                  context.read<ThemeBloc>().add(ToggleTheme());
                                },
                                icon: AnimatedSize(
                                  duration: Duration(milliseconds: 300),
                                  child: SvgPicture.asset(
                                    state.dark
                                        ? AppImages.daySvg
                                        : AppImages.darkSvg,
                                    color: Theme.of(context).hintColor,
                                    width: 2.5.h,
                                  ),
                                ));
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(LogoutEvent());
                            },
                            icon: SvgPicture.asset(
                              AppImages.logoutSvg,
                              width: 2.5.h,
                            )),
                      ],
                    ),
                    2.high,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "total_expense".trs(context),
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 13.5.ft,
                              ),
                            ),
                            Spacer(),
                            if (state is HomeLoaded)
                              DropdownButton(
                                  value: state.currency,
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontSize: 13.5.ft,
                                      fontWeight: 500.wt),
                                  dropdownColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(12.sp),
                                  items: List.from(
                                      ExpenseRepository().currencies.map((e) {
                                    return DropdownMenuItem(
                                        value: e['name'],
                                        child: Text(e['name']));
                                  })),
                                  onChanged: (val) {
                                    context
                                        .read<HomeBloc>()
                                        .add(ChangeCurrency(val.toString()));
                                  })
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                child: RichText(
                                    text: TextSpan(
                                        text: "$s ",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontSize: 19.ft,
                                            fontFamily: "Poppins",
                                            fontWeight: 200.wt),
                                        children: [
                                      TextSpan(
                                        text: state is HomeLoaded
                                            ? state.data['total']
                                                .toString()
                                                .formatCurrency(decimal: 2)
                                            : "0.00",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontSize: 19.ft,
                                            fontWeight: 500.wt),
                                      )
                                    ])),
                              ),
                            ),
                            2.wide,
                            RichText(
                              text: TextSpan(
                                text:
                                    "${state is HomeLoaded ? state.expenses.length : 0}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.ft,
                                    fontWeight: 600.wt),
                                children: [
                                  TextSpan(
                                    text: " ${"transactions".trs(context)}",
                                    style: TextStyle(
                                        color: Theme.of(context).dividerColor,
                                        fontSize: 14.ft,
                                        fontWeight: 400.wt),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    3.high,
                    Qofi.primaryButton(
                        title: 'add_expense',
                        onPressed: () {
                          context.push("/add-expense");
                        }),
                    1.75.high,
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is HomeLoaded &&
                          List.from(state.data['graph'] ?? [])
                              .where((e) => e['total'] > 0)
                              .isNotEmpty) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: state.data['graph'].length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 0.5.h),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 1.5.w,
                                            backgroundColor: lightColors[
                                                index % lightColors.length],
                                          ),
                                          3.wide,
                                          Text(
                                            state.data['graph'][index]['name'],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontSize: 13.5.ft,
                                                fontWeight: 500.wt),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 30.h,
                              width: 60.w,
                              child: PieChart(
                                curve: Curves.bounceInOut,
                                duration: Duration(milliseconds: 800),
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 00,
                                  sections: List<PieChartSectionData>.from(state
                                      .data['graph']
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    var data = entry.value;

                                    double percentage =
                                        (data['total'] / total) * 100;
                                    return PieChartSectionData(
                                      color: lightColors[
                                          index % lightColors.length],
                                      value: data['total'].toDouble(),
                                      title:
                                          "${percentage.toStringAsFixed(1)}%",
                                      radius: 27.w,
                                      titleStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  })),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (state is HomeLoaded) ...[
                        2.high,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("recent_transactions".trs(context),
                                    style: TextStyle(fontSize: 14.5.ft)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    context.push("/expenses");
                                  },
                                  child: Text(
                                    "view_all".trs(context),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14.ft,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        1.high,
                        if (state.expenses.isNotEmpty)
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: state.expenses.take(5).length,
                              itemBuilder: (context, index) {
                                ExpenseModel expense = state.expenses[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.2.h),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.6.h),
                                  decoration: BoxDecoration(
                                      boxShadow: boxShadow(6),
                                      borderRadius:
                                          BorderRadius.circular(12.sp),
                                      color: Theme.of(context).cardColor),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                                vertical: 0.4.h),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .elevatedButtonTheme
                                                  .style
                                                  ?.backgroundColor
                                                  ?.resolve({})?.withOpacity(
                                                      0.7),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
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
                                                color:
                                                    Theme.of(context).hintColor,
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
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 14.5.ft,
                                                )),
                                          ),
                                          Text(
                                              "${expense.currency} ${expense.amount.formatCurrency(decimal: 2)}",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
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
                                                  color: Theme.of(context)
                                                      .canvasColor,
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
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                          3.wide,
                                          TextButton(
                                              onPressed: () {
                                                context.read<HomeBloc>().add(
                                                    DeleteExpense(expense.id));
                                              },
                                              style: iconButtonStyle,
                                              child: SvgPicture.asset(
                                                AppImages.deleteSvg,
                                                width: 4.25.w,
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              })
                        else
                          SizedBox(
                            height: 30.h,
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
                          )
                      ]
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
