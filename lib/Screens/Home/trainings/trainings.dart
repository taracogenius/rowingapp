import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Screens/Home/trainings/workoutView.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:scrolling_day_calendar/scrolling_day_calendar.dart';
import 'package:rowingapp/Screens/Home/trainings/createWorkout.dart';
import 'package:intl/intl.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Screens/wrapper.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  // Just so I can run it here.
  initializeDateFormatting('en_NZ').then((_) => runApp(Training()));
}

class Training extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trainings',
      home: MyHomePage(title: 'Trainings'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _rowingEvents; //events
  List _eventsSelected; //SelectedEvents
  AnimationController _animationController;
  CalendarController _calendarController;
  List<Workout> _workoutList;

  @override
  void initState() {
    super.initState();

    final _daySelected = DateTime.now();

    //this is where the admin will add in events using the button
    //These are random so we need to just make a section for adding them in
//    _rowingEvents = {
//      _daySelected.subtract(Duration(days: 30)): ['Rowing Practice', 'Rowing Practice 2', 'Rowing Practice 3'],
//      _daySelected.subtract(Duration(days: 27)): ['Rowing Team 1 Practice'],
//      _daySelected.subtract(Duration(days: 20)): ['Rowing Example', 'Break Today', 'Rowing Test', 'Rowing Practice 4'],
//      _daySelected.subtract(Duration(days: 16)): ['Rowing Event', 'Rowing Championships'],
//    };

    _rowingEvents = <DateTime, List>{};

    _eventsSelected = _rowingEvents[_daySelected] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationController.forward();

    _workoutList = <Workout>[];
  }

  @override
  void disposeControllers() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _theDaySelected(DateTime day, List rowingEvents) {
    print('Date selected: _theDaySelected');
    setState(() {
      _eventsSelected = rowingEvents;
    });
  }

  void _thevisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('Visible Day Changed: _thevisibleDayChanged');
  }

  void _theCalandarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('Calandar Created _theCalandarCreated');
  }

  @override
  Widget build(BuildContext context) {
    final bool _admin = Provider.of<AdminModel>(context).getAdmin();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: activeColourScheme.navbarGeneral,
          centerTitle: true,
          actions: <Widget>[
            //Workout Creation from app bar.
            Visibility(
              visible: true, //_admin,
              child: IconButton(
                icon: Icon(Icons.add),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateWorkout()),
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: activeColourScheme.backgroundColour,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text(
                "Current Schedule",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 25,
                    color: activeColourScheme.headerColor,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 0, top: 0),
              child: Divider(
                thickness: 4.0,
                indent: 85.0,
                endIndent: 85.0,
              ),
            ),
            _builderForCalendar(),
            const SizedBox(height: 8.0),
            _buttonBuilder(),
            const SizedBox(height: 8.0),
            Expanded(child: _eventBuilder()),
          ],
        ));
  }

  Widget _builderForCalendar() {
    final club = Provider.of<Club>(context);
    final user = Provider.of<UserData>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: Database('workout')
            .streamDataCollectionWithAtr('clubId', club?.clubId ?? ""),
        //query Workout data to firestore via stream
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          //make sure list and map are empty to avoid the duplicate
          _workoutList.clear();
          _rowingEvents.clear();

          //convert firestore Workout Documents into Workout class List
          snapshot.data.documents.forEach((result) => (_workoutList
              .add(Workout.fromMap(result.data, result.documentID))));

          //map all workout titles with key of date(no time element)
          for (Workout _workout in _workoutList) {
            DateTime _date = new DateTime(_workout.startTime.year,
                _workout.startTime.month, _workout.startTime.day);

            //if date key exists, then append a title to the list, otherwise, create a new list with a new key
            _rowingEvents.update(_date, (value) {
              value.add(_workout);
              return value;
            }, ifAbsent: () => [_workout]);
          }

          //sort by startTime. (might be changed better sort)
          _rowingEvents.forEach((key, value) => _rowingEvents.update(key, (_) {
                value.sort((a, b) => a.startTime.compareTo(b.startTime));
                return value;
              }));

          return TableCalendar(
            calendarController: _calendarController,
            events: _rowingEvents,
            initialCalendarFormat: CalendarFormat.month,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.all,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
              CalendarFormat.week: '',
            },
            calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekdayStyle: TextStyle()
                    .copyWith(color: activeColourScheme.buttonBackgrounds)),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle().copyWith(color: activeColourScheme.headerColor),
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false,
            ),
            builders: CalendarBuilders(selectedDayBuilder: (context, date, _) {
              return FadeTransition(
                opacity:
                    Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: activeColourScheme.currentDayColor,
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                ),
              );
            }, todayDayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.only(top: 5.0, bottom: 6.0),
                color: Colors.grey[400],
                width: 100,
                height: 100,
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              );
            }, markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];
              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                      right: 1,
                      bottom: 1,
                      child: _eventMarkerBuilder(date, events, user)),
                );
              }
              return children;
            }),
            onDaySelected: (date, events) {
              _theDaySelected(date, events);
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: _thevisibleDaysChanged,
            onCalendarCreated: _theCalandarCreated,
          );
        });
  }

  Widget _eventMarkerBuilder(DateTime date, List events, UserData user) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: events.any((item) => item.attendingUser.contains(user.uid))
              ? Colors.greenAccent[700]
              : _calendarController.isSelected(date)
                  ? activeColourScheme.headerColor
                  : _calendarController.isToday(date)
                      ? activeColourScheme.eventSelected
                      : activeColourScheme.eventUnselected),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.amberAccent,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buttonBuilder() {
    //final dateTime = _rowingEvents.keys.elementAt(_rowingEvents.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GFButton(
                color: activeColourScheme.buttonBackgrounds,
                shape: GFButtonShape.pills,
                size: GFSize.LARGE,
                child: Text('Month'),
                onPressed: () {
                  setState(() {
                    _calendarController.setCalendarFormat(CalendarFormat.month);
                  });
                }),
            GFButton(
              color: activeColourScheme.buttonBackgrounds,
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            GFButton(
              color: activeColourScheme.buttonBackgrounds,
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget _eventBuilder() {
    if (_eventsSelected.isEmpty) {
      return ListView(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'No events today.',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        )
      ]);
    }

    return ListView(
      children: _eventsSelected
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${event.title}',
                        textAlign: TextAlign.left,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${DateFormat('EEEE kk:mm').format(event.startTime)}',
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${DateFormat('EEEE kk:mm').format(event.endTime)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutView(workout: event)),
                    );
                  },
                ),
              ))
          .toList(),
    );
  }
}
