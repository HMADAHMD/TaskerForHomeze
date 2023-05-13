import 'package:flutter/material.dart';
import 'package:homezetasker/screens/make_offer.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:provider/provider.dart';
import '../provider/tasker_provider.dart';
import 'package:homezetasker/models/tasker.dart' as model;

class JobsCard extends StatefulWidget {
  final snap;
  const JobsCard({super.key, required this.snap});

  @override
  State<JobsCard> createState() => _JobsCardState();
}

class _JobsCardState extends State<JobsCard> {
  @override
  Widget build(BuildContext context) {
    model.Tasker tasker = Provider.of<TaskerProvider>(context).getTasker;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
            color: grayclr, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10))),
                    child: Center(
                      child: Text(
                        widget.snap['fullname'].toString(),
                        style: TextStyle(
                            color: orangeclr,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Center(
                        child: Text(
                          widget.snap['address'].toString(),
                          style: TextStyle(
                            color: blueclr,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10))),
                    child: Center(
                      child: Text(
                        'Rs. ' + widget.snap['price'],
                        style: TextStyle(
                            color: blueclr, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Title: " + widget.snap['title'],
                  style: TextStyle(
                      color: blueclr,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Divider(
              color: orangeclr,
              height: 2,
            ),
            Container(
              width: double.infinity,
              height: 148,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "Details: " + widget.snap['description'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(color: blueclr),
                          ),
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Image.network(
                            widget.snap['postURL'].toString(),
                            fit: BoxFit.fill,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      )),
                      height: 60,
                      child: Center(
                        child: Text(
                            widget.snap['date'] + '\n' + widget.snap['time'],
                            style: TextStyle(color: blueclr)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: darkgray,
                      ),
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Message',
                          style: TextStyle(
                              color: blueclr, fontWeight: FontWeight.bold),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakeOffer(
                                    taskId: widget.snap['taskId'].toString())));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: orangeclr,
                        ),
                        height: 50,
                        child: const Center(
                          child: Text(
                            'Make Offer',
                            style: TextStyle(
                                color: blueclr, fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }
}
