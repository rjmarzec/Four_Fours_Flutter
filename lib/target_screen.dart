import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TargetScreen extends StatefulWidget
{
	TargetScreen({Key key}) : super(key: key);

	@override
	_TargetScreenState createState()
	=> _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen>
{
	List<Widget> targetWidgetList = new List<Widget>();
	Icon _completedIcon = Icon(Icons.turned_in_not);

	String _enteredText = "Getting Number...";
	double _enteredTextSize = 12.0;
	bool _targetGotten = false;

	@override
	Widget build(BuildContext context)
	{
		TextEditingController targetTextController = new TextEditingController();

		if (!_targetGotten)
		{
			_getTargetNumber();
		}
		else
		{
			_enteredTextSize = 52.0;
		}

		return new Center(
			widthFactor: 1.2,
			child: new Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					new Text(
						"Enter a Target Number",
						style: TextStyle(
							color: Colors.black,
							fontSize: 24.0,
						),
					),
					new Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							new Text(
								_enteredText,
								textAlign: TextAlign.center,
								overflow: TextOverflow.ellipsis,
								style: TextStyle(
									color: Colors.black,
									fontSize: _enteredTextSize,
								),
							),
							_completedIcon,
						],
					),
					new TextField(
						textAlign: TextAlign.center,
						maxLength: 10,
						keyboardType: TextInputType.numberWithOptions(),
						style: TextStyle(
							color: Colors.black,
							fontSize: 32.0,
						),
						controller: targetTextController,
						onSubmitted: (_submittedText)
						{
							targetTextController.clear();
							setState(()
							{
								_enteredTextSize = 52.0;
								_enteredText = double.parse(_submittedText).toInt().toString();
								_completedIcon = Icon(Icons.turned_in_not);
								_checkIfGotten(_submittedText);
								_updateTargetNumber(double.parse(_submittedText).toInt());
							});
						},
					),
				],
			),
		);
	}

	void _checkIfGotten(String submittedText)
	async
	{
		SharedPreferences prefs = await SharedPreferences.getInstance();
		String currentSolvedListAsString = prefs.getString(("solvedNumbers") ?? "");
		if (currentSolvedListAsString.compareTo("") == 0)
		{
			setState(()
			{
				_completedIcon = Icon(Icons.turned_in_not);
			});
		}
		else if (!currentSolvedListAsString.contains(";;"))
		{
			setState(()
			{
				if (currentSolvedListAsString.compareTo(_enteredText) == 0)
				{
					_completedIcon = Icon(Icons.turned_in);
				}
				else
				{
					_completedIcon = Icon(Icons.turned_in_not);
				}
			});
		}
		else
		{
			List<String> solvedNumbersAsList = currentSolvedListAsString.split(";;");
			setState(()
			{
				if (solvedNumbersAsList.contains(submittedText))
				{
					_completedIcon = Icon(Icons.turned_in);
				}
				else
				{
					_completedIcon = Icon(Icons.turned_in_not);
				}
			});
		}
	}

	void _getTargetNumber()
	async
	{
		SharedPreferences prefs = await SharedPreferences.getInstance();
		int targetNumber = (prefs.getInt("targetNumber") ?? 0);
		setState(()
		{
			_enteredText = targetNumber.toString();
			_targetGotten = true;
		});
	}

	void _updateTargetNumber(int inputTargetNumber)
	async
	{
		SharedPreferences prefs = await SharedPreferences.getInstance();
		await prefs.setInt("targetNumber", inputTargetNumber);
	}
}
