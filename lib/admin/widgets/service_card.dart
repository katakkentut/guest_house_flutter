import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:guest_house_app/admin/screens/admin_service_detail_screen.dart';
import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:get/get.dart';

class AdminServiceCard extends StatefulWidget {
  const AdminServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  final ServiceModel service;

  @override
  State<AdminServiceCard> createState() => _AdminServiceCardState();
}

class _AdminServiceCardState extends State<AdminServiceCard> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AdminServiceDetail(service: widget.service));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      widget.service.serviceStatus == 'Completed'
                          ? 'assets/icon/check-mark.png'
                          : 'assets/icon/clock.png',
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.large(
                            "Service Id: ${widget.service.serviceId}",
                            fontSize: 15,
                            textAlign: TextAlign.left,
                            maxLine: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          AppText.medium(
                            "Date: ${widget.service.serviceDate}",
                            fontSize: 14,
                            textAlign: TextAlign.left,
                            maxLine: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
