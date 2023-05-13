import 'package:flutter/material.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/resources/firestore_methods.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/utils.dart';
import 'package:homezetasker/widgets/small_widgets.dart';
import 'package:provider/provider.dart';
import 'package:homezetasker/models/tasker.dart' as model;

class MakeOffer extends StatefulWidget {
  final taskId;
  const MakeOffer({super.key, required this.taskId});

  @override
  State<MakeOffer> createState() => _MakeOfferState();
}

class _MakeOfferState extends State<MakeOffer> {
  final _offerController = TextEditingController();
  bool _isLoading = false;

  makeYourOffer(
    String fullname,
    String profession,
    String photoURL,
    String uid,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().makeOffer(
        fullname,
        _offerController.text,
        profession,
        photoURL,
        uid,
        widget.taskId,
      );
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Posted!', context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    model.Tasker tasker = Provider.of<TaskerProvider>(context).getTasker;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: orangeclr,
            )),
        elevation: 0,
        backgroundColor: skyclr,
        title: const Text(
          'Make Your Offer',
          style: TextStyle(
              color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 130,
          color: skyclr,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: TextField(
                            controller: _offerController,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: grayclr,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: darkgray)),
                                errorBorder: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: orangeclr)),
                                hintText: 'make your offer'))),
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500),
                                  color: darkgray,
                                ),
                                height: 50,
                                child: const Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: blueclr,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                makeYourOffer(
                                  tasker.fullname,
                                  tasker.profession,
                                  tasker.photoURL,
                                  tasker.uid,
                                );
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500),
                                  color: orangeclr,
                                ),
                                height: 50,
                                child: const Center(
                                  child: Text(
                                    'Send',
                                    style: TextStyle(
                                        color: blueclr,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   flex: 1,
                          //   child: Icon(
                          //     Icons.delete,
                          //     color: Colors.red,
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
