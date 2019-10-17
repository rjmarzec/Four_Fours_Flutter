import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:math_expressions/math_expressions.dart';
import 'main.dart';

class ComputeScreen extends StatefulWidget
{
	ComputeScreen({Key key}) : super(key: key);

	@override
	_ComputeScreenState createState()
	=> _ComputeScreenState();
}

class _ComputeScreenState extends State<ComputeScreen>
{
	Parser parser = new Parser();
	List<Widget> computeWidgetList = new List<Widget>();
	Row resultRow = new Row();
	String _submittedText = "";

	int _targetNumber = 0;
	bool _targetGotten = false;

	@override
	Widget build(BuildContext context)
	{
		if (!_targetGotten)
		{
			_getTargetNumber();
		}

		return new Center(
			widthFactor: 1.2,
			child: new Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					new Text(
						"Target Number: " + _targetNumber.toString(),
						style: TextStyle(
							color: Colors.black,
							fontSize: 24.0,
						),
					),
					new TextField(
						textAlign: TextAlign.center,
						style: TextStyle(
							color: Colors.black,
							fontSize: 32.0,
						),
						onChanged: (onChangedText)
						{
							_submittedText = onChangedText;
						},
					),
					resultRow,
					new RaisedButton(
						child: new Text("Compute"),
						onPressed: ()
						{
							_computeSubmitted(_submittedText);
						},
					),
				],
			),
		);
	}

	void _computeSubmitted(String submittedExpression)
	{
		try
		{
			Expression exp = parser.parse(submittedExpression);
			if (_containsNo4s(submittedExpression))
			{
				if (_containsExactly4Fours(submittedExpression))
				{
					double expressionResult = exp.evaluate(EvaluationType.REAL, new ContextModel());
					print(expressionResult);

					setState(()
					{
						if (expressionResult == _targetNumber.toDouble())
						{
							_notifyUser("You got it!");
							_updateCompletedList(_targetNumber);
							resultRow = new Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									new Text(
										"= " + _targetNumber.toString(),
										style: new TextStyle(
											fontSize: 32.0,
										),
									),
									new Icon(
										Icons.check_circle,
										size: 32.0,
									),
								],
							);
							Future.delayed(Duration(seconds: 3)).then((dynamic temp)
							{
								runApp(new MainScreens());
							}, onError: (e)
							{
								runApp(new MainScreens());
							});
						}
						else
						{
							resultRow = new Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									new Text(
										"= " + expressionResult.toString() + "  ",
										style: new TextStyle(
											fontSize: 32.0,
										),
									),
									new Icon(
										Icons.cancel,
										size: 32.0,
									),
								],
							);
						}
					});
				}
				else
				{
					_notifyUser("Exactly 4 4s must be used");
				}
			}
			else
			{
				_notifyUser("Only the number 4 can be used");
			}
		}
		catch (e)
		{
			print(e);
			_notifyUser("Equation not valid");
		}
	}

	void _notifyUser(String message)
	{
		Scaffold.of(context).showSnackBar(new SnackBar(
			content: new Text(message),
		));
	}

	bool _containsNo4s(String inputString)
	{
		return (!(inputString.contains("0") || inputString.contains("1") || inputString
				.contains("2") || inputString.contains("3") || inputString
				.contains("5") || inputString.contains("6") || inputString
				.contains("7") || inputString.contains("8") || inputString.contains("9")));
	}

	bool _containsExactly4Fours(String inputString)
	{
		if (inputString.length - inputString
				.replaceAll(new RegExp(r"4"), "")
				.length == 4)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	void _updateCompletedList(int solvedTargetNumber)
	async
	{
		SharedPreferences prefs = await SharedPreferences.getInstance();
		String currentSolvedListAsString = prefs.getString(("solvedNumbers") ?? "");
		String newSolvedListAsString;
		if (currentSolvedListAsString == null || currentSolvedListAsString.compareTo("") == 0)
		{
			newSolvedListAsString = solvedTargetNumber.toString();
		}
		else if(currentSolvedListAsString.contains(";;"))
		{
			newSolvedListAsString = ";;" + solvedTargetNumber.toString();
		}
		else
		{
			newSolvedListAsString = solvedTargetNumber.toString();
		}

		await prefs.setString("solvedNumbers", newSolvedListAsString);

		print("################################");
		print(solvedTargetNumber);
		print(currentSolvedListAsString);
		print(newSolvedListAsString);
		print("################################");
	}

	void _getTargetNumber()
	async
	{
		SharedPreferences prefs = await SharedPreferences.getInstance();
		int storedTargetNumber = prefs.getInt("targetNumber") ?? 0;
		setState(()
		{
			_targetNumber = storedTargetNumber;
			_targetGotten = true;
		});
	}
}
