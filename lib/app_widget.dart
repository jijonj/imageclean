import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/application/bloc/image_bloc.dart';
import 'features/home/application/page/home_page.dart';
import 'injection.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<ImageBloc>(),
        child: HomePage(title: 'Image Uploader'));
  }
}
