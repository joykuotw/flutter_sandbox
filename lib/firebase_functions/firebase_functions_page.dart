import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/pageNavigatorCustom.dart';
import 'package:provider/provider.dart';

class FirebaseFunctionsPage extends StatefulWidget {
  static const id = 'firebase_functions_page';
  @override
  _FirebaseFunctionsPageState createState() => _FirebaseFunctionsPageState();
}

class _FirebaseFunctionsPageState extends State<FirebaseFunctionsPage> {
  FirebaseFunctions functions;
  String cloudFunctionData = "";

  Future<String> showErrorAlertDialog({
    @required BuildContext context,
    @required String titleText,
    @required String messageText,
  }) async {
    // set up the buttons
    final Widget gotItButton = TextButton(
      onPressed: () => Navigator.pop(context, 'Got it'),
      child: const Text('Got it'),
    );

    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(titleText),
      content: Text(messageText),
      actions: [
        gotItButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  @override
  void initState() {
    functions = FirebaseFunctions.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageNavigatorCustom _pageNavigator =
        Provider.of<PageNavigatorCustom>(context);
    _pageNavigator.setCurrentPageIndex =
        _pageNavigator.getPageIndex("Cloud Functions");
    _pageNavigator.setFromIndex = _pageNavigator.getCurrentPageIndex;

    Future<void> getGeoJSON() async {
      setState(() {
        cloudFunctionData = "-----LOADING-----";
      });
      HttpsCallable callable = functions.httpsCallable('getGeoJSON');
      try {
        final results = await callable();
        setState(() {
          cloudFunctionData = results.data.toString();
        });
      } catch (error) {
        setState(() {
          cloudFunctionData = "";
        });
        await showErrorAlertDialog(
          context: context,
          titleText: 'Uh Oh!',
          messageText: error.message,
        );
      }
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue.shade50,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  cloudFunctionData,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              getGeoJSON();
            },
            child: Text('Fetch geoJSON'),
          ),
        ),
      ],
    );
  }
}