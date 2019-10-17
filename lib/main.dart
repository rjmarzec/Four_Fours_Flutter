import 'package:flutter/material.dart';

import 'solved_screen.dart';
import 'target_screen.dart';
import 'compute_screen.dart';

void main()
{
	runApp(MainScreens());
}

class MainScreens extends StatefulWidget
{
	MainScreens({Key key}) : super(key: key);

	@override
	_MainScreensState createState()
	=> _MainScreensState();
}

class _MainScreensState extends State<MainScreens>
{
	int _selectedIndex = 1;
	final _widgetOptions = [
		new SolvedScreen(),
		new TargetScreen(),
		new ComputeScreen(),
	];

	@override
	Widget build(BuildContext context)
	{
		return MaterialApp(
			home: Scaffold(
				appBar: AppBar(
					//title: Text('BottomNavigationBar Sample'),
				),
				body: Center(
					child: _widgetOptions.elementAt(_selectedIndex),
				),
				bottomNavigationBar: BottomNavigationBar(
					items: <BottomNavigationBarItem>[
						BottomNavigationBarItem(icon: Icon(Icons.done_all), title: Text('Solved')),
						BottomNavigationBarItem(icon: Icon(Icons.flag), title: Text('Target')),
						BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Compute')),
					],
					currentIndex: _selectedIndex,
					fixedColor: Colors.deepPurple,
					onTap: _onItemTapped,
				),
			),
		);
	}

	void _onItemTapped(int index)
	{
		setState(()
		{
			_selectedIndex = index;
		});
	}
}
