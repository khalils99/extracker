import 'dart:io';

import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

import '../../domain/models/expense_model.dart';

class ExpenseRepository {
  static final ExpenseRepository _instance = ExpenseRepository._internal();
  final Box _box = Hive.box('expenses');

  ExpenseRepository._internal();

  final expenseCategories = [
    {"id": "1", "name": "Food"},
    {"id": "2", "name": "Transport"},
    {"id": "3", "name": "Shopping"},
    {"id": "4", "name": "Bills"},
    {"id": "5", "name": "Others"},
  ];

  ///currencies with conversion rate to usd
  List currencies = [
    {"id": "1", "name": "USD", "conversion": 1, "symbol": "\$"},
    {"id": "2", "name": "AED", "conversion": 3.68, "symbol": "AED"},
    {"id": "3", "name": "PKR", "conversion": 270.6, "symbol": "Rs"},
    {"id": "4", "name": "INR", "conversion": 81.0, "symbol": "₹"},
    {"id": "5", "name": "EUR", "conversion": 0.85, "symbol": "€"},
    {"id": "6", "name": "GBP", "conversion": 0.73, "symbol": "£"},
  ];

  factory ExpenseRepository() => _instance;
 
  Future<bool> addExpense(ExpenseModel expense) async {
    try {
      await _box.put(expense.id, expense.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  List<ExpenseModel> getExpenses() {
    return _box.values
        .where((element) => element["status"] != "deleted")
        .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }

  double calculateTotal(List<ExpenseModel> expenses, String targetCurrency) {
    try {
      final targetCurrencyData = currencies.firstWhere(
        (element) => element["name"] == targetCurrency,
        orElse: () => {"conversion": 1},
      );

      final targetConversionRate =
          double.parse(targetCurrencyData["conversion"].toString());
      double total = expenses.fold(0.0, (sum, item) {
        final sourceCurrencyData = currencies.firstWhere(
          (element) => element["name"] == item.currency,
          orElse: () => {"conversion": 1},
        );

        final sourceConversionRate =
            double.parse(sourceCurrencyData["conversion"].toString());
        final convertedAmount =
            (item.amount / sourceConversionRate) * targetConversionRate;

        return sum + convertedAmount;
      }).toDouble();

      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> deleteExpense(String id) async {
    Map existingExpense = _box.get(id);
    await _box.put(id, {...existingExpense, "status": "deleted"});
  }

  Future<void> generateExpensePdf() async {
    final expenses = getExpenses().map((e) => e.toJson()).toList();
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Expense Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: [
                  'Title',
                  'Amount',
                  'Category',
                  'Date',
                  'Currency',
                  'Created at'
                ],
                data: expenses.map((e) {
                  return [
                    e['title'],
                    e['amount'].toString(),
                    e['category'],
                    e['createdAt'],
                    e['date'],
                    e['currency'],
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> generateAndSaveExpenseExcel() async {
    final expenses = getExpenses().map((e) => e.toJson()).toList();
    final excel = Excel.createExcel();
    final sheet = excel['Expenses'];
    sheet.appendRow([
      'Title',
      'Amount',
      'Category',
      'Date',
      'Currency',
      'Created at'
    ].map((e) => TextCellValue(e)).toList());

    for (var expense in expenses) {
      sheet.appendRow([
        expense['title'],
        expense['amount'].toString(),
        expense['category'],
        expense['date'],
        expense['currency'],
        expense['createdAt'],
      ].map((e) => TextCellValue(e)).toList());
    }
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }

    Directory? directory;
    if (Platform.isAndroid) {
      directory =
          Directory('/storage/emulated/0/Download'); // Save to Downloads folder
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      directory =
          await getApplicationDocumentsDirectory(); // iOS Documents directory
    }

    final filePath = '${directory!.path}/expense_report.xlsx';
    final file = File(filePath);

    await file.writeAsBytes(excel.encode()!);
    await OpenFilex.open(filePath);
  }
}
