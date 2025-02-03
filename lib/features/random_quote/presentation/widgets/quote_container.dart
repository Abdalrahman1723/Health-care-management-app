import 'package:flutter/material.dart';
import 'package:quotes/core/utils/app_colors.dart';

class QuoteContainer extends StatelessWidget {
  const QuoteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.container, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          //the quote
          const Text(
            "احفر بإبرة ولا تطلب من العلق فاس.",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl, // for arabic
          ),
          //the author
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "- Abdalrahman",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }
}
