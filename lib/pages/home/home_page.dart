import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/providers/product.dart';
import 'package:kopi_combi/theme.dart';
import 'package:kopi_combi/widgets/product_card.dart';
import 'package:kopi_combi/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Consumer<AuthProvider>(builder: ((context, auth, child) {
          String? avatarUrl = auth.user?.photoUrl ?? 'assets/image_profile.png';
          if (avatarUrl.contains('ui-avatars.com')) {
            avatarUrl = '$avatarUrl&size=100';
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hallo, ${auth.user?.name}',
                      style: primaryTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: semibold,
                      ),
                    ),
                    Text(
                      auth.user?.email ?? '',
                      style: subtitleTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: avatarUrl != 'assets/image_profile.png'
                            ? NetworkImage(avatarUrl)
                            : AssetImage(
                                'assets/image_profile.png',
                              ) as ImageProvider,
                        fit: BoxFit.cover)),
              )
            ],
          );
        })),
      );
    }

    // Widget categories() {
    //   return Container(
    //     margin: EdgeInsets.only(
    //       top: defaultMargin,
    //     ),
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Row(
    //         children: [
    //           SizedBox(
    //             width: defaultMargin,
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 10,
    //             ),
    //             margin: EdgeInsets.only(right: 16),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               color: primaryColor,
    //             ),
    //             child: Text(
    //               'Semua Kopi',
    //               style: primaryTextStyle.copyWith(
    //                 fontSize: 13,
    //                 fontWeight: medium,
    //                 color: backgroundColor1,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 10,
    //             ),
    //             margin: EdgeInsets.only(right: 16),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               border: Border.all(
    //                 color: subtitleColor,
    //               ),
    //               color: transparentColor,
    //             ),
    //             child: Text(
    //               'Arabica',
    //               style: subtitleTextStyle.copyWith(
    //                 fontSize: 13,
    //                 fontWeight: medium,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 10,
    //             ),
    //             margin: EdgeInsets.only(right: 16),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               border: Border.all(
    //                 color: subtitleColor,
    //               ),
    //               color: transparentColor,
    //             ),
    //             child: Text(
    //               'Robusta',
    //               style: subtitleTextStyle.copyWith(
    //                 fontSize: 13,
    //                 fontWeight: medium,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 10,
    //             ),
    //             margin: EdgeInsets.only(right: 16),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               border: Border.all(
    //                 color: subtitleColor,
    //               ),
    //               color: transparentColor,
    //             ),
    //             child: Text(
    //               'Liberica',
    //               style: subtitleTextStyle.copyWith(
    //                 fontSize: 13,
    //                 fontWeight: medium,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.symmetric(
    //               horizontal: 12,
    //               vertical: 10,
    //             ),
    //             margin: EdgeInsets.only(right: 16),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               border: Border.all(
    //                 color: subtitleColor,
    //               ),
    //               color: transparentColor,
    //             ),
    //             child: Text(
    //               'Excelsa',
    //               style: subtitleTextStyle.copyWith(
    //                 fontSize: 13,
    //                 fontWeight: medium,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    Widget popularProductsTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Text(
          'Produk Terlaris',
          style: primaryTextStyle.copyWith(
            fontSize: 19,
            fontWeight: semibold,
          ),
        ),
      );
    }

    Widget popularProducts() {
      return Container(
        margin: EdgeInsets.only(top: 14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: defaultMargin,
              ),
              FutureBuilder(
                  future: productProvider.getPopularProducts(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<dynamic> productsPopular =
                          snapshot.data as List<dynamic>;
                      return Row(
                        children: productsPopular
                            .map((item) => ProductCard(
                                  item: item,
                                ))
                            .toList(),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      );
    }

    Widget newArrivalTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: defaultMargin,
          left: defaultMargin,
          right: defaultMargin,
        ),
        child: Text(
          'Produk Baru',
          style: primaryTextStyle.copyWith(
            fontSize: 19,
            fontWeight: semibold,
          ),
        ),
      );
    }

    Widget newArrivals() {
      return FutureBuilder(
          future: productProvider.getProducts(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<dynamic> products = snapshot.data as List<dynamic>;
              return Container(
                margin: EdgeInsets.only(top: 14),
                child: Column(
                    children: products
                        .map((item) => ProductTile(
                              item: item,
                            ))
                        .toList()),
              );
            } else {
              return CircularProgressIndicator();
            }
          });
    }

    return ListView(
      children: [
        header(),
        // categories(),
        popularProductsTitle(),
        popularProducts(),
        newArrivalTitle(),
        newArrivals(),
      ],
    );
  }
}
