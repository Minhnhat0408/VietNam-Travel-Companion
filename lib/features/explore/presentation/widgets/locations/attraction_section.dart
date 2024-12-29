import 'package:flutter/material.dart';
import 'package:vn_travel_companion/features/explore/domain/entities/attraction.dart';
import 'package:vn_travel_companion/features/explore/presentation/widgets/attractions/attraction_big_card.dart';

class AttractionsSection extends StatelessWidget {
  final List<Attraction> attractions;
  final String locationName;
  const AttractionsSection({
    super.key,
    required this.attractions,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Địa điểm du lịch',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/attractions');
                    },
                    child: Text(
                      'Xem tất cả',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Những địa điểm tham quan, hoạt động khám phá và trải nghiệm đặc trưng của $locationName',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 390, // Height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: attractions.length, // Number of items
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0
                      ? 20.0
                      : 4.0, // Extra padding for the first item
                  right: index == attractions.length - 1
                      ? 20.0
                      : 4.0, // Extra padding for the last item
                ),
                child: AttractionBigCard(
                  attraction: attractions[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}