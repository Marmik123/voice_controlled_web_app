import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/r.g.dart';

class HomeContentView extends GetView {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            h(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                ),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 25,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, itemIndex) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      scale: 20,
                      image: AssetImage(R.image.asset.fruit_jpg.assetName),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.primaryColorDark
                      ],
                    ),
                  ),
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Vegetable'),
                    ],
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
