import 'package:flutter/material.dart';

class MonthListWidget extends StatefulWidget {
  @override
  _MonthListWidgetState createState() => _MonthListWidgetState();
}

class _MonthListWidgetState extends State<MonthListWidget> {
  final _scrollController = ScrollController();
  int _currentMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Movimiento'),
      ),
      body: Column(
        children: [
          RawScrollbar(
            controller: _scrollController,
            thickness: 8,
            radius: Radius.circular(5),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 35,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = month == _currentMonth;
                    final buttonColor = isSelected
                        ? Colors.blue
                        : Color.fromARGB(255, 211, 206, 206);

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      //width: 120,
                      //height: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentMonth = month;
                          });
                          final year = DateTime.now().year;
                          final monthStr = month.toString().padLeft(2, '0');
                          final dateStr = '$year$monthStr';
                          print(dateStr); // YYYYMM format
                        },
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          _getMonthName(month),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            /*
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Product $index'),
              );
            },
          ),
          */
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
