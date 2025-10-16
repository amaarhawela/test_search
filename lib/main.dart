import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/views/home_screen.dart';
import 'cubit/search_cubit.dart';

void main() {
  runApp(BlocProvider(create: (_) => SearchCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Demo',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
