// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? subscription;
  RemoteConfigUpdate? update;
  bool bannerType = false;

  @override
  void initState() {
    super.initState();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      setState(() {
        bannerType = remoteConfig.getBool("banner_type");
        update = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Example'),
      ),
      body: Column(
        children: [
          _ButtonAndText(
            defaultText: 'Not initialized',
            buttonText: 'Set as default values in remote config',
            onPressed: () async {
              final FirebaseRemoteConfig remoteConfig =
                  FirebaseRemoteConfig.instance;
              await remoteConfig.setConfigSettings(
                RemoteConfigSettings(
                  fetchTimeout: const Duration(seconds: 10),
                  minimumFetchInterval: const Duration(hours: 1),
                ),
              );
              await remoteConfig.setDefaults(<String, dynamic>{
                'banner_type': false,
                'hello': 'default hello',
              });
              RemoteConfigValue(null, ValueSource.valueStatic);
              return 'Initialized';
            },
          ),
          Text("data call hear values $bannerType")
        ],
      ),
    );
  }
}

class _ButtonAndText extends StatefulWidget {
  const _ButtonAndText({
    Key? key,
    required this.defaultText,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  final String defaultText;
  final String buttonText;
  final Future<String> Function() onPressed;

  @override
  State<_ButtonAndText> createState() => _ButtonAndTextState();
}

class _ButtonAndTextState extends State<_ButtonAndText> {
  String? _text;

  // Update text when widget is updated.
  @override
  void didUpdateWidget(covariant _ButtonAndText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultText != oldWidget.defaultText) {
      setState(() {
        _text = widget.defaultText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(_text ?? widget.defaultText),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final result = await widget.onPressed();
              setState(() {
                _text = result;
              });
            },
            child: Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
