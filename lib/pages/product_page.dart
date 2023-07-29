import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/product.dart';
import 'package:kopi_combi/service/wishlist.dart';
import 'package:kopi_combi/theme.dart';
import 'package:kopi_combi/widgets/image_url.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _qty = TextEditingController();
  List images = [
    'assets/kopi_kombi1.png',
    'assets/kopi_kombi1.png',
    'assets/kopi_kombi1.png',
  ];

  int currentIndex = 0;
  bool isWishlist = false;

  late Map<String, dynamic> product = {
    'name': '',
    'price': 0,
    'tags': '',
    'description': ''
  };
  late List<dynamic> galleries = [];
  late List<dynamic> popularProduct = [];
  String imageMainUrl = '';
  @override
  void initState() {
    // int productId = ModalRoute.of(context)!.settings.arguments as int; //cocok untuk stateleswidget
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    Future.wait([
      productProvider.getDetailProduct(widget.productId),
      productProvider.getPopularProducts(),
      WihslistService().productOnWishlist(widget.productId)
    ]).then((value) {
      final image = value[0]['galleries']
          .firstWhere((element) => element['main_image'] == 1);
      setState(() {
        product = value[0];
        galleries = value[0]['galleries'];
        popularProduct = value[1];
        imageMainUrl = image['url'];
        isWishlist = value[2];
      });
    });
    // callApi(widget.args["name"], widget.args["id"]);
    super.initState();
  }

  void onHandleWishlist(int productId) async {
    await WihslistService().addToWishlist(productId);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showSuccessDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width - (2 * defaultMargin),
          child: AlertDialog(
            backgroundColor: backgroundColor3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icon_success.png',
                    width: 100,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Hurray :)',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semibold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Item added successfully',
                    style: secondaryTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 154,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home', arguments: 1);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View My Cart',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget indicator(int index) {
      return Container(
        width: currentIndex == index ? 16 : 4,
        height: 4,
        margin: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? primaryColor : Color(0xffC4C4C4),
        ),
      );
    }

    Widget kopiTerlarisCard(String imageUrl) {
      return Container(
        width: 54,
        height: 54,
        margin: EdgeInsets.only(
          right: 16,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  imageUrl.replaceAll('localhost:8080', '192.168.1.17:8080')),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    Widget header() {
      int index = -1;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.chevron_left,
                  ),
                ),
              ],
            ),
          ),
          CarouselSlider(
            items: galleries
                .map((image) => ImageUrl(
                    url: image['url'],
                    width: MediaQuery.of(context).size.width,
                    height: 310,
                    fit: BoxFit.cover))
                .toList(),
            options: CarouselOptions(
              initialPage: 0,
              onPageChanged: ((index, reason) {
                setState(
                  () {
                    currentIndex = index;
                  },
                );
              }),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: galleries.map((e) {
              index++;
              return indicator(index);
            }).toList(),
          )
        ],
      );
    }

    Widget content() {
      int index = -1;

      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          color: backgroundColor1,
        ),
        child: Column(
          children: [
            //NOTE: HEADER
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: primaryTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semibold,
                          ),
                        ),
                        Text(
                          product['tags'],
                          style: secondaryTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWishlist = !isWishlist;
                      });

                      onHandleWishlist(product['id']);

                      if (isWishlist) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: secondaryColor,
                            content: Text(
                              'Berhasil ditambahkan ke favorit',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: alertColor,
                            content: Text(
                              'Data dihapus dari favorit',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: Image.asset(
                      isWishlist
                          ? 'assets/button_wishlist_blue.png'
                          : 'assets/button_wishlist.png',
                      width: 46,
                    ),
                  )
                ],
              ),
            ),

            //NOTE: PRICE
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 20,
                left: defaultMargin,
                right: defaultMargin,
              ),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor2,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga',
                    style: primaryTextStyle,
                  ),
                  Text(
                    'Rp. ${product['price']}',
                    style: priceTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semibold,
                    ),
                  )
                ],
              ),
            ),

            //NOTE: DESCRIPTION
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
                left: defaultMargin,
                right: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi Produk',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    product['description'],
                    style: subtitleTextStyle.copyWith(
                      fontWeight: light,
                    ),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),

            //NOTE: FAMILIAR SHOES
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin,
                    ),
                    child: Text(
                      'Kopi Terlaris',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: popularProduct.map((item) {
                        index++;
                        return Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? defaultMargin : 0),
                          child: kopiTerlarisCard(
                              item['product']['galleries'][0]['url']),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),

            //NOTE: BUTTONS
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(defaultMargin),
              child: Row(
                children: [
                  Container(
                      width: 100,
                      height: 54,
                      margin: EdgeInsets.only(right: 5),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _qty,
                        // controller: _emailController,
                        decoration: InputDecoration(
                            hintText: 'Qty',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1.5, color: primaryColor))),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: TextButton(
                        onPressed: () {
                          Provider.of<ProductProvider>(context, listen: false)
                              .addToCart(
                                  widget.productId,
                                  product['name'],
                                  int.parse(_qty.text),
                                  product['price'],
                                  imageMainUrl);
                          showSuccessDialog();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        child: Text(
                          'Pesan Sekarang',
                          style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semibold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor6,
      body: ListView(
        children: [
          header(),
          content(),
        ],
      ),
    );
  }
}
