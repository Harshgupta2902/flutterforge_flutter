import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color primaryColor = Color(0xFF066AC9);
const Color vistaWhite = Color(0xFFFAF9F9);
const Color darkJungleGreen = Color(0xFF212121);
const Color heather = Color(0xFFBCC1CD);
const Color blueGrey = Color(0xFF64748B);

class TimeLineOne extends StatefulWidget {
  const TimeLineOne({super.key});

  @override
  State<TimeLineOne> createState() => _TimeLineOneState();
}

class _TimeLineOneState extends State<TimeLineOne> {
  int? selected;
  int currentIndex = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getDateRange(currentIndex);
    });
    super.initState();
  }

  late int year = 0;
  late String formattedMonth = "";
  late String formattedWeek = "";
  late bool _isFunctionRunning = false;

  DateTime now = DateTime.now();
  final _pageController = PageController();
  int prevData = 0;
  int nextData = 0;

  final dates = [
    "2024-05-21",
    "2024-05-22",
    "2024-05-23",
    "2024-05-24",
    "2024-05-25",
    "2024-05-26",
    "2024-05-27"
  ];

  List<List<ClassData>> classData = [];
  _findTodayIndex() {
    DateTime now = DateTime.now();
    String todayFormatted = DateFormat('yyyy-MM-dd').format(now);
    int todayDateIndex = 0;
    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == todayFormatted) {
        todayDateIndex = i;
        break;
      }
    }
    _pageController.animateToPage(
      todayDateIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      selected = todayDateIndex;
    });
  }

  Future<void> getDateRange(int currentIndex) async {
    if (_isFunctionRunning == true) {
      debugPrint("------------XX-------------- : TRY");
      return;
    }
    try {
      _isFunctionRunning = true;
      debugPrint("here is the value of try _isFunctionRunning : $_isFunctionRunning");
      debugPrint("------------------- currentIndex $currentIndex");

      DateTime today = DateTime.now();
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

      if (currentIndex == 0) {
        startOfWeek = today;
      }

      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      String startDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
      String endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);
      year = today.year;
      formattedMonth = DateFormat.MMM().format(today);
      formattedWeek = DateFormat.EEEE().format(today);

      startOfWeek = startOfWeek.add(Duration(days: currentIndex * 7));
      endOfWeek = startOfWeek.add(const Duration(days: 6));
      startDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
      endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);

      debugPrint("startOfWeek : $startOfWeek -XX-$endOfWeek--: $startDate-- endDate $endDate");

      // Update the dates list with the new range
      List<String> newDates = [];
      for (int i = 0; i < 7; i++) {
        DateTime currentDate = startOfWeek.add(Duration(days: i));
        newDates.add(DateFormat('yyyy-MM-dd').format(currentDate));
      }
      setState(() {
        dates.clear();
        dates.addAll(newDates);
      });
      DateTime startDates = startOfWeek;
      DateTime endDates = endOfWeek;
      generateClassData(startDates, endDates);

      if (currentIndex == 0) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _findTodayIndex();
        });
      }
    } finally {
      _isFunctionRunning = false;
      debugPrint("here is the value of finally _isFunctionRunning : $_isFunctionRunning");
    }
  }

  void generateClassData(DateTime startDate, DateTime endDate) {
    // Clear existing data
    classData.clear();

    // Generate class data for each date in the range
    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      // Dummy class data for the current date
      List<ClassData> classDataForDate = [];

      // Generate random number of classes for the current date (between 1 and 5)
      int numberOfClasses = Random().nextInt(5) + 1;
      for (int i = 0; i < numberOfClasses; i++) {
        // Generate random class data
        ClassData classData = ClassData(
          startDate: DateFormat('d/M/yyyy').format(date),
          className: "Class ${i + 1}",
          classCode: "ABC${Random().nextInt(1000)}",
          classDuration: "${Random().nextInt(4) + 1} hours",
          classMode: Random().nextBool() ? "Online" : "Offline",
        );

        classDataForDate.add(classData);
      }

      classData.add(classDataForDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          topBar(),
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
                    dateRange(),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      color: vistaWhite,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          headingTitle(),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.60,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (value) => setState(() {
                                selected = value;
                              }),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: classData.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return TimeLineContent(
                                  data: classData[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                getCurrentDay(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: darkJungleGreen,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedWeek,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: heather,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    "$formattedMonth $year",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: heather,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    currentIndex = 0;
                  });
                  await getDateRange(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Today",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  getDateRange(--currentIndex);
                },
                child: Row(
                  children: [
                    icon(Icons.arrow_back_ios_new_rounded),
                    const SizedBox(width: 12),
                    Text(
                      "previous",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
              Text(
                DateFormat('MMMM yyyy').format(DateTime.parse(dates.first)),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              GestureDetector(
                onTap: () async {
                  getDateRange(++currentIndex);
                },
                child: Row(
                  children: [
                    Text(
                      "next",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 12),
                    icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget icon(IconData? icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(2),
      child: Icon(
        icon,
        color: Colors.black,
        size: 14,
      ),
    );
  }

  Widget dateRange() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dates.length, (index) {
          final days = dates[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
              });
              _pageController.animateToPage(
                selected!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              debugPrint("selected:::::::::$selected     $index");
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: selected == index ? primaryColor : Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getDayOfWeek(days)[0],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected == index ? Colors.white : heather,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days.split("-").last,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selected == index ? Colors.white : darkJungleGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget headingTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              "Time",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: heather,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              "Course",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: heather,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeLineContent extends StatelessWidget {
  const TimeLineContent({super.key, required this.data});
  final List<ClassData> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final itemData = data[index];
        return timeLineContent(
          classCode: itemData.classCode,
          className: itemData.className,
          classTime: itemData.classDuration,
          startDate: itemData.startDate,
          context: context,
        );
      },
    );
  }

  Widget timeLineContent({
    String? startDate,
    String? classTime,
    String? className,
    String? classCode,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          startDate ?? "-",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: darkJungleGreen,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          classTime ?? "-",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: heather,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(color: vistaWhite, height: 1, thickness: 1)
                  ],
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: SizedBox(
            child: Container(
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          className ?? "-",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 26,
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    classCode ?? "-",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String getDayOfWeek(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String dayOfWeek = DateFormat('EEEE').format(date);
  return dayOfWeek;
}

String getCurrentDay() {
  DateTime now = DateTime.now();
  int day = now.day;
  String dayString = day.toString().padLeft(2, '0');
  return dayString;
}

class ClassData {
  final num? id;
  final String? className;
  final String? startDate;
  final String? classDuration;
  final String? classMode;
  final String? classCode;
  final String? day;
  final String? moduleName;

  ClassData({
    this.id,
    this.className,
    this.startDate,
    this.classDuration,
    this.classMode,
    this.classCode,
    this.day,
    this.moduleName,
  });
}
