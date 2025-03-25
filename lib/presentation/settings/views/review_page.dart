import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_app_review/in_app_review.dart';

class CustomRatingBottomSheet {
  CustomRatingBottomSheet._();

  static Future<void> showFeedBackBottomSheet({
    required BuildContext context,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet<void>(
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                width: width,
                height: height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    RatingBar.builder(
                      glow: false,
                      allowHalfRating: true,
                      unratedColor: Colors.grey[400],
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) async => {
                        if (value.toInt() >= 4)
                          {
                            if (await InAppReview.instance.isAvailable())
                              {
                                // Shows Google's in-app review popup
                                InAppReview.instance.requestReview()
                              }
                            else
                              {
                                // Opens Google Play Store page
                                InAppReview.instance.openStoreListing()
                              }
                          }
                        else
                          {Navigator.of(context).pop()}
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Tap the star',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))
                  ],
                ),
              ));
        });
  }
}
