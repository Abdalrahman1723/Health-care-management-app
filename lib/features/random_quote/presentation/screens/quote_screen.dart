import 'package:flutter/material.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/app_strings.dart';
import 'package:quotes/features/random_quote/presentation/widgets/quote_container.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  //body widget
  Widget _buildBodyContent() {
    return Column(
      children: [
        const QuoteContainer(),
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.container, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              color: Colors.black,
              onPressed: () {},
              icon: const Icon(Icons.refresh),
            ))
      ],
    );
  }

  //---------------

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text(AppStrings.appName),
      // backgroundColor: Colors.black,
    );

    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
