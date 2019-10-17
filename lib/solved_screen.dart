import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

List<Widget> _solvedWidgetList;

class SolvedScreen extends StatefulWidget
{
	SolvedScreen({Key key}) : super(key: key);

	@override
	_SolvedScreenState createState()
	=> _SolvedScreenState();
}

class _SolvedScreenState extends State<SolvedScreen>
{
	List<Widget> solvedNumberList = _getDefaultSolvedDisplay();

	@override
	Widget build(BuildContext context)
	{
		_handleSolvedWidgetsFuture(_getSolvedAsTextWidgets());

		return new Center(
			child: new ListView(
				children: solvedNumberList,
			),
		);
	}

	_handleSolvedWidgetsFuture(Future<List<Widget>> widgetListFuture)
	{
		widgetListFuture.then((List<Widget> solvedAsTextWidgets)
		{
			setState(() {
				solvedNumberList = solvedAsTextWidgets;
			});
		}, onError: (e)
		{
			setState(() {
				solvedNumberList = _getErrorSolvedDisplay();
			});
		});
	}
}

Future<List<Widget>> _getSolvedAsTextWidgets()
async
{
	List<Widget> resultList = _buildInitialDisplayWidgets();
	resultList.add(new Text("testText"));

	return resultList;
}

List<Widget> _getErrorSolvedDisplay()
{
	List<Widget> resultList = _buildInitialDisplayWidgets();
	resultList.add(
		new Text(
			"There was an error getting your numbers. Oops!",
			style: new TextStyle(
				fontSize: 16.0,
				color: Colors.black,
			),
		),
	);
	return resultList;
}

List<Widget> _getDefaultSolvedDisplay()
{
	List<Widget> resultList = _buildInitialDisplayWidgets();
	resultList.add(
		new Text(
			"Getting Numbers, Please Wait",
			style: new TextStyle(
				fontSize: 16.0,
				color: Colors.black,
			),
		),
	);
	return resultList;
}

List<Widget> _buildInitialDisplayWidgets()
{
	List<Widget> resultList = new List<Widget>();
	resultList.add(
		new Text(
			"Solved Numbers:",
			style: new TextStyle(
				fontSize: 24.0,
				color: Colors.black,
			),
		),
	);
	return resultList;
}
