import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

import '../bloc/image_bloc.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ImageBloc>(context).add(SyncImages());
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        BlocProvider.of<ImageBloc>(context).add(SyncImages());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ImageBloc, ImageState>(
              builder: (context, state) {
                if (state is ImageUploading) {
                  return CircularProgressIndicator();
                } else if (state is ImageUploadedSuccess) {
                  return Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  );
                } else if (state is ImageUploadedFailure) {
                  return Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => BlocProvider.of<ImageBloc>(context)
                  .add(SelectAndUploadImage()),
              icon: Icon(Icons.add_a_photo),
              label: Text('Select and Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
