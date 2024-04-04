import 'package:flutter/material.dart';
import 'package:guest_house_app/widgets/app_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/hotel_model.dart';
import '../../providers/all_hotels_provider.dart';
import '../../widgets/hotel_card.dart';

class FavouriteHouseScreen extends StatefulWidget {
  const FavouriteHouseScreen({Key? key}) : super(key: key);

  @override
  _FavouriteHouseScreenState createState() => _FavouriteHouseScreenState();
}

class _FavouriteHouseScreenState extends State<FavouriteHouseScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AppText.large(
          'Favourite House',
          fontSize: 20,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // backgroundColor: Colors.blue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.only(top: size.height * 0.25),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // HeaderSection(),
                    SizedBox(height: 20),
                    _NearbyHotelSection(),
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

final loadingProvider = StateProvider<bool>((ref) => false);

class _NearbyHotelSection extends ConsumerWidget {
  const _NearbyHotelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotels = ref.watch(favHotelsProvider);
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.large(
                  'All House',
                  fontSize: 18,
                  textAlign: TextAlign.left,
                  maxLine: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 4),
            hotels.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 5.0,
                backgroundColor: Colors.white,
              )),
              error: (err, stack) => Text('Error: $err'),
              data: (hotels) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: hotels.length,
                  itemBuilder: (BuildContext context, int index) {
                    HotelModel hotel = hotels[index];
                    return HotelCard(hotel: hotel);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
