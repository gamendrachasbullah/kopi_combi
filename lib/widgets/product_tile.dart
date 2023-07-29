import 'package:flutter/material.dart';
import 'package:kopi_combi/theme.dart';
import 'package:kopi_combi/widgets/image_url.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: item['id']);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ImageUrl(url: item['galleries'][0]['url'])),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['tags'] ?? '',
                  style: secondaryTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  item['name'],
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semibold,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Rp. ${item['price']}',
                  style: priceTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
