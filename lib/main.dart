import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

//Local imports
import 'save_file_mobile.dart' if (dart.library.html) 'save_file_web.dart';

void main() {
  runApp(CreatePdfWidget());
}

/// Represents the PDF widget class.
class CreatePdfWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreatePdfStatefulWidget(),
    );
  }
}

/// Represents the PDF stateful widget class.
class CreatePdfStatefulWidget extends StatefulWidget {
  /// Initalize the instance of the [CreatePdfStatefulWidget] class.
  const CreatePdfStatefulWidget({Key? key}) : super(key: key);

  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdfStatefulWidget> {
  Map<String, String> as = {};
  List<String> qs = [
    "A cara cara navel is a type of orange",
    "There are five different blood groups",
    "Cinderella was the first Disney princess",
    "ASOS stands for As Seen On Screen",
  ];
  bool loading = false;

  String savedFile = '';

  Future openFile() async {
    // try {
    //   await OpenFile.open(savedFile);
    // } catch (e) {
    //   // error
    //   print('[ERROR] Failed to open file: $savedFile');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf app"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            loading
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ))
                : SizedBox.shrink(),
            for (int i = 0; i < qs.length; i++)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(qs[i]),
                    RadioListTile(
                      title: Text("Yes"),
                      value: "yes",
                      groupValue: as[qs[i]],
                      onChanged: (value) {
                        setState(() {
                          as[qs[i]] = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("No"),
                      value: "no",
                      groupValue: as[qs[i]],
                      onChanged: (value) {
                        setState(() {
                          as[qs[i]] = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            TextButton(
              onPressed: () async => await generateInvoice1(),
              child: Text('Generate docx file'),
            ),
            SizedBox(height: 30),
            Divider(
              thickness: 2,
              height: 1,
            ),
            SizedBox(height: 30),
            Text('Generated word document saved to:'),
            SizedBox(height: 5),
            Text(
              savedFile,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Divider(
              thickness: 2,
              height: 1,
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () async => await openFile(),
              child: Text('Open generated file'),
            ),
            SizedBox(height: 30),
            Divider(
              thickness: 2,
              height: 1,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> generateInvoice1() async {
    //Create a PDF document.
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();

    double top = 0.0;
    int number = 1;
    for (int i = 0; i < qs.length; i++) {
      page.graphics.drawString(
          "$number. ${qs[i]}", PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(
              0, top, page.getClientSize().width, page.getClientSize().height));
      top += 20;
      page.graphics.drawRectangle(
          brush: as[qs[i]] == 'yes' ? PdfBrushes.pink : PdfBrushes.black,
          bounds: Rect.fromLTWH(15, top, 10, 10));
      page.graphics.drawString(
          "Yes", PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(35, top, page.getClientSize().width,
              page.getClientSize().height));
      top += 20;
      page.graphics.drawRectangle(
          brush: as[qs[i]] == 'no' ? PdfBrushes.pink : PdfBrushes.black,
          bounds: Rect.fromLTWH(15, top, 10, 10));
      page.graphics.drawString(
          "No", PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(35, top, page.getClientSize().width,
              page.getClientSize().height));
      top += 20;
      number += 1;
    }
// Create a PDF ordered list.
//     final PdfOrderedList orderedList = PdfOrderedList(
//       items: PdfListItemCollection(qs),
//       marker: PdfOrderedMarker(
//           style: PdfNumberStyle.numeric,
//           font: PdfStandardFont(PdfFontFamily.helvetica, 12)),
//       markerHierarchy: true,
//       format: PdfStringFormat(lineSpacing: 10),
//       textIndent: 10,
//     );
// // Create a un ordered list and add it as a sublist.
//     for (int i = 0; i < qs.length; i++) {
//       orderedList.items[i].subList = PdfUnorderedList(
//         marker: PdfUnorderedMarker(
//             font: PdfStandardFont(PdfFontFamily.helvetica, 10),
//             style: PdfUnorderedMarkerStyle.square)
//           ..brush = as[qs[i]] == 'yes' ? PdfBrushes.red : PdfBrushes.black,
//         items: PdfListItemCollection(<String>['Yes', 'No']),
//         textIndent: 10,
//         indent: 20,
//       );
//     }
// // Draw the list to the PDF page.
//     orderedList.draw(
//         page: page,
//         bounds: Rect.fromLTWH(
//             0, 0, page.getClientSize().width, page.getClientSize().height));

    final List<int> bytes = document.saveSync();
// Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }
}
