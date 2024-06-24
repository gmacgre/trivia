import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isFull = false;

  @override
  void initState() {
    super.initState();
    _setFullData();
  }

  void _setFullData() async {
    bool toSet = await WindowManager.instance.isFullScreen();
    setState(() {
      isFull = toSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).focusColor),
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextButton(
                      onPressed: () => { Navigator.of(context).pop()},
                      child: const Text('Return to Home')
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(constraints.maxWidth * 0.3, 0, 0, 0),
                          child: Text(
                            'FullScreen',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,0,constraints.maxWidth * 0.3, 0),
                          child: Switch(
                            // This bool value toggles the switch.
                            value: isFull,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                // For some reason, doing this once leaves the flutter sizing in a weird state
                                // Doubling it seems to fix it, so leave alone for now.
                                WindowManager.instance.setFullScreen(!isFull);
                                WindowManager.instance.setFullScreen(!isFull);
                                _setFullData();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}