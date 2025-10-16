import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NumbersColor extends StatefulWidget {
  const NumbersColor({super.key});

  @override
  State<NumbersColor> createState() => _NumbersColorState();
}

class _NumbersColorState extends State<NumbersColor> {
  int? counter;
  Set blueColor = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('blue numbers : ${blueColor.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: 11,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (blueColor.contains(index)) {
                        blueColor.remove(index);
                      } else {
                        blueColor.add(index);
                      }
                    });
                  },
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: blueColor.contains(index)
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
