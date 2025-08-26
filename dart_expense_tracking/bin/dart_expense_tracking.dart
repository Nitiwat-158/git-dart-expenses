import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<int?> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();

  if (username == null ||
      password == null ||
      username.isEmpty ||
      password.isEmpty) {
    print("Incomplete input");
    return null;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    print(result["message"]);
    final loginData = jsonDecode(response.body);
    final int userId = loginData['userId'];
    return userId;
  } else if (response.statusCode == 401 || response.statusCode == 500) {
    print(response.body);
    return null;
  } else {
    print("Unknown error: ${response.statusCode}");
    return null;
  }
}

// ---------------- Features ----------------
Future<void> getAllExpenses(int userId) async {
  final url = Uri.parse('http://localhost:3000/expenses/$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final expenses = json.decode(response.body) as List;
    int total = 0;
    print("------------- All Expenses ---------");
    for (var exp in expenses) {
      final dt = DateTime.tryParse(exp['date'].toString());
      final dtLocal = dt?.toLocal();
      print("${exp['id']}. ${exp['item']} : ${exp['paid']}฿ @ ${dtLocal ?? exp['date']}");
      total += int.tryParse(exp['paid'].toString()) ?? 0;
    }
    print("Total expenses = $total฿\n");
  } else {
    print("Failed to fetch all expenses\n");
  }
}

Future<void> getTodayExpenses(int userId) async {
  final url = Uri.parse('http://localhost:3000/expenses/$userId/today');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final expenses = json.decode(response.body) as List;
    int total = 0;
    print("------------- Today's Expenses ---------");
    for (var exp in expenses) {
      final dt = DateTime.tryParse(exp['date'].toString());
      final dtLocal = dt?.toLocal();
      print("${exp['id']}. ${exp['item']} : ${exp['paid']}฿ @ ${dtLocal ?? exp['date']}");
      total += int.tryParse(exp['paid'].toString()) ?? 0;
    }
    print("Total expenses = $total฿\n");
  } else {
    print("Failed to fetch today's expenses\n");
  }
}

Future<void> searchExpenses(int userId) async {
  final url = Uri.parse('http://localhost:3000/expenses/$userId');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Error: ${response.statusCode}");
    return;
  }

  final expenses = json.decode(response.body) as List;
  stdout.write("Item to search: ");
  String? keyword = stdin.readLineSync()?.trim();

  if (keyword == null || keyword.isEmpty) {
    print("No keyword entered\n");
    return;
  }

  final results = expenses.where((e) {
    final item = (e['item'] ?? '').toString().toLowerCase();
    return item.contains(keyword.toLowerCase());
  }).toList();

  if (results.isEmpty) {
    print("No item matched: $keyword\n");
  } else {
    for (var e in results) {
      final dt = DateTime.tryParse(e['date'].toString());
      final dtLocal = dt?.toLocal();
      print("${e['id']}. ${e['item']} : ${e['paid']}฿ @ ${dtLocal ?? e['date']}");
    }
    print("");
  }
}

Future<void> addExpense(int userId) async {
  print("===== Add new item =====");
  stdout.write("Item: ");
  String? item = stdin.readLineSync()?.trim();
  stdout.write("Paid: ");
  String? paidInput = stdin.readLineSync()?.trim();

  if (item == null || item.isEmpty || paidInput == null || paidInput.isEmpty) {
    print("Invalid input\n");
    return;
  }

  final paidAmount = int.tryParse(paidInput);
  if (paidAmount == null) {
    print("Please input a valid number\n");
    return;
  }

  final url = Uri.parse('http://localhost:3000/expenses/add/$userId');
  final body = jsonEncode({
    "user_id": userId,
    "item": item,
    "paid": paidAmount,
  });

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (response.statusCode == 201) {
    print("Inserted!\n");
  } else {
    print("Failed to add expense. Error: ${response.statusCode}\n");
  }
}

Future<void> deleteExpense(int userId) async {
  print("===== Delete an item =====");
  stdout.write("Item id: ");
  String? idInput = stdin.readLineSync()?.trim();

  final expenseId = int.tryParse(idInput ?? '');
  if (expenseId == null) {
    print("Please input a valid number\n");
    return;
  }

  final url = Uri.parse('http://localhost:3000/expenses/delete/$userId/$expenseId');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Deleted!\n");
  } else if (response.statusCode == 404) {
    print("Expense not found\n");
  } else {
    print("Failed to delete expense\n");
  }
}

// ---------------- Menu Loop ----------------
Future<void> menuLoop(int userId) async {
  while (true) {
    print("========= Expense Tracking App ========");
    print("1. All expenses");
    print("2. Today's expenses");
    print("3. Search expenses");
    print("4. Add new expense");
    print("5. Delete an expense");
    print("6. Exit");
    stdout.write("Choose... ");
    String? choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        await getAllExpenses(userId);
        break;
      case '2':
        await getTodayExpenses(userId);
        break;
      case '3':
        await searchExpenses(userId);
        break;
      case '4':
        await addExpense(userId);
        break;
      case '5':
        await deleteExpense(userId);
        break;
      case '6':
        print("----- Bye -----");
        return;
      default:
        print("Invalid choice, please try again.\n");
    }
  }
}

// ---------------- Main ----------------
Future<void> main() async {
  final userId = await login();
  if (userId != null) {
    await menuLoop(userId);
  }
}