import 'package:flutter/material.dart';
import 'package:kopi_combi/dto/cart.dart';
import 'package:kopi_combi/providers/auth.dart';
import 'package:kopi_combi/providers/product.dart';
import 'package:kopi_combi/theme.dart';
import 'package:kopi_combi/widgets/image_url.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  final TextEditingController _address = TextEditingController();

  CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    void redirectCheckoutSuccess() {
      Navigator.pushNamed(context, '/home');
    }

    Future<void> showAddressIsEmpty() async {
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
                  Text(
                    'Alamat Kosong :)',
                    style: primaryTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semibold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Silahkan masukan alamat untuk pengiriman',
                    style: secondaryTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: subtitleColor,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _address,
                              style: primaryTextStyle,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Input Alamat Pengiriman',
                                hintStyle: subtitleTextStyle,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 154,
                    height: 44,
                    child: TextButton(
                      onPressed: () async {
                        bool checkout = await Provider.of<ProductProvider>(
                                context,
                                listen: false)
                            .checkout(_address.text);
                        if (checkout) {
                          redirectCheckoutSuccess();
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: medium,
                          color: backgroundColor1,
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

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        title: Text(
          'Checkout List',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget checkoutList() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor3,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  // height: 200,
                  height: 450,
                  child: Consumer<ProductProvider>(
                      builder: (context, provider, child) {
                    List<ProductCartDTO> cart = provider.checkoutProducts;
                    if (cart.isEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.all_inbox,
                            size: 45,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            'Checkout produk kosong',
                            style: purpleTextStyle.copyWith(
                                fontSize: 18, color: Colors.blueGrey),
                          )
                        ],
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 3,
                              child: ListTile(
                                  title: Text(cart[index].name.toString(),
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: semibold,
                                      )),
                                  subtitle: Text(
                                    'Qty ${cart[index].quantity}',
                                    style: secondaryTextStyle,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: primaryColor,
                                    ),
                                    onPressed: () =>
                                        Provider.of<ProductProvider>(context,
                                                listen: false)
                                            .deleteFromCart(index),
                                  ),
                                  leading: ImageUrl(
                                    url: cart[index].image ?? '',
                                    width: 60,
                                  )));
                        },
                      );
                    }
                  }),
                ),
              ),
              // Image.asset(
              //   'assets/icon_headset.png',
              //   width: 80,
              // ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                child: Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                  return Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Total Rp.${provider.totalPrice}',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 44,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    String? address =
                        Provider.of<AuthProvider>(context, listen: false)
                            .user
                            ?.address;

                    if (address == null) {
                      showAddressIsEmpty();
                    } else {
                      bool checkout = await Provider.of<ProductProvider>(
                              context,
                              listen: false)
                          .checkout(address);
                      if (checkout) {
                        redirectCheckoutSuccess();
                      } else {
                        debugPrint('=================Reject=================');
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                      color: backgroundColor1,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        checkoutList(),
      ],
    );
  }
}
