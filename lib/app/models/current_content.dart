import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:html/parser.dart'; // ✅ Import the HTML parser

class WebContentManager {
  static String _currentContent = '';

  static String get currentContent => _currentContent;

  static Future<void> updateContent(String url) async {
    developer.log('updated');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = parse(response.body);
        // _currentContent = response.body;
        _currentContent = extractMainContent(document); // ✅ Extract key text
      } else {
        _currentContent =
            'Error: Failed to fetch content (Status Code: ${response.statusCode})';
      }
    } catch (e) {
      _currentContent = 'Error: $e';
    }

    developer.log('Content updated for: $url');
    // developer.log('URICONTENT $_currentContent');
    developer.log('URICONTENTLength ${_currentContent.length}');
  }
}

String extractMainContent(var document) {
  List<String> contentList = [];

  // Extract Headings & Paragraphs
  var elements = document.body!.querySelectorAll('h1, h2, h3, p, strong, em');
  for (var element in elements) {
    String text = element.text.trim();
    if (text.isNotEmpty) {
      contentList.add(text);
    }
  }

  // Extract Lists (Ordered & Unordered)
  var lists = document.body!.querySelectorAll('ul, ol');
  for (var list in lists) {
    List<String> listItems = [];
    for (var item in list.querySelectorAll('li')) {
      listItems.add('- ${item.text.trim()}');
    }
    if (listItems.isNotEmpty) {
      contentList.add('\nList:\n' + listItems.join('\n'));
    }
  }

  // Extract Tables (Formatted)
  var tables = document.body!.querySelectorAll('table');
  for (var table in tables) {
    List<String> tableData = [];

    // Extract Headers
    var headers = table.querySelectorAll('th');
    if (headers.isNotEmpty) {
      tableData.add('Table:\n' + headers.map((e) => e.text.trim()).join(' | '));
      tableData.add('-' * tableData.last.length); // Separator
    }

    // Extract Rows
    var rows = table.querySelectorAll('tr');
    for (var row in rows) {
      var cells = row.querySelectorAll('td');
      if (cells.isNotEmpty) {
        tableData.add(cells.map((e) => e.text.trim()).join(' | '));
      }
    }

    if (tableData.isNotEmpty) {
      contentList.add(tableData.join('\n'));
    }
  }

  return contentList.join('\n'); // ✅ Well-formatted extraction
}
