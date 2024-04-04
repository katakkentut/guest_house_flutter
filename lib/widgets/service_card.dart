import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:guest_house_app/models/service_model.dart';
import 'package:guest_house_app/widgets/app_text.dart';

class ServiceCard extends StatefulWidget {
  const ServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  final ServiceModel service;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: ExpansionTileCard(
        borderRadius: BorderRadius.circular(20.0),
        baseColor: Colors.white,
        leading: Image.asset(
          widget.service.serviceStatus == 'Completed'
              ? 'assets/icon/check-mark.png'
              : 'assets/icon/clock.png',
          height: 35,
          width: 35,
          fit: BoxFit.cover,
        ),
        title: AppText.large(
          "Service Id: ${widget.service.serviceId}",
          fontSize: 15,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        subtitle: AppText.medium(
          "Date: ${widget.service.serviceDate}",
          fontSize: 14,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        children: <Widget>[
          const Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.large(
                    "Service requested by user",
                    fontSize: 15,
                    textAlign: TextAlign.left,
                    maxLine: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.black,
                  ),
                  Text(
                    widget.service.userServiceNotes,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16.0),
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  SizedBox(height: 16.0),
                  AppText.large(
                    "Service Note",
                    fontSize: 15,
                    textAlign: TextAlign.left,
                    maxLine: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.black,
                  ),
                  Text(
                    widget.service.adminServiceNotes,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
