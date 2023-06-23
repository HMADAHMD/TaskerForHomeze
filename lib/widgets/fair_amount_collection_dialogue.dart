import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homezetasker/utils/constants.dart';

class FairAmountCollectionDialogue extends StatefulWidget {
  double? totalFareAmount;
  FairAmountCollectionDialogue({this.totalFareAmount});

  @override
  State<FairAmountCollectionDialogue> createState() =>
      _FairAmountCollectionDialogueState();
}

class _FairAmountCollectionDialogueState
    extends State<FairAmountCollectionDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: skyclr,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: skyclr,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Total Task Amount ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueclr,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 4,
              color: darkgray,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.totalFareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: blueclr,
                fontSize: 50,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Total task amount, Please Collect it",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blueclr,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: orangeclr),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    SystemNavigator.pop();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Collect Cash",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$  " + widget.totalFareAmount!.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
