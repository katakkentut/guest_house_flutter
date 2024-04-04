import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/screens/admin_edit_delete_price.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../models/hotel_model.dart';
import '../users/screens/hotel_screen.dart';
import 'app_text.dart';
import 'custom_rating.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    Key? key,
    required this.hotel,
    this.option,
  }) : super(key: key);

  final HotelModel hotel;
  final String? option;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (option != null) {
        Get.to(() => EditDeleteHousePrice(hotel: hotel));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailScreen(hotel: hotel),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                child: Image.network(
                  hotel.houseThumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.large(
                      hotel.houseName,
                      fontSize: 18,
                      textAlign: TextAlign.left,
                      maxLine: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Assets.icon.location.svg(
                          color: ColorName.darkGrey,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        AppText.small(hotel.houseLocation),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child:
                          CustomRating(ratingScore: hotel.ratingScore ?? 0.0),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          AppTextSpan.large('\RM ${hotel.housePrice}'),
                          AppTextSpan.medium(' /night'),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
