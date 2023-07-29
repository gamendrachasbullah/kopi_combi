import 'package:flutter/material.dart';
import 'package:kopi_combi/service/wishlist.dart';
import 'package:kopi_combi/theme.dart';
import 'package:kopi_combi/widgets/image_url.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int totalItem = 0;
  List<dynamic> wishlist = List<dynamic>.empty();

  void getWishtlist() async {
    final myWishlist = await WihslistService().myWishlist();
    wishlist = myWishlist['data'];
    totalItem = myWishlist['total'];
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => setState(() {}));
  }

  void removeWishlist(int productId) async {
    await WihslistService().removeMyWishlist(productId);
    getWishtlist();
  }

  @override
  void initState() {
    super.initState();
    getWishtlist();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        title: Text(
          '$totalItem Produk Favoritmu',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget emptyWishlist() {
      return Expanded(
        child: Container(
          width: double.infinity,
          color: backgroundColor3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 3,
                  child: ListTile(
                      title: Text(wishlist[index]['product']['name'],
                          style: primaryTextStyle.copyWith(
                            fontSize: 18,
                            // fontWeight: semibold,
                          )),
                      subtitle: Text(
                        'Rp ${wishlist[index]['product']['price']}',
                        style: priceTextStyle,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: primaryColor,
                        ),
                        onPressed: () => removeWishlist(wishlist[index]['id']),
                      ),
                      leading: ImageUrl(
                        url: wishlist[index]['product']['galleries'][0]
                                ['url'] ??
                            '',
                        width: 60,
                      )));
            },
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        //emptyWishlist(),
        emptyWishlist(),
      ],
    );
  }
}
