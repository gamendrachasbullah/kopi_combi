import 'package:flutter/material.dart';
import 'package:kopi_combi/providers/product.dart';
import 'package:kopi_combi/theme.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Orders List',
            style: primaryTextStyle.copyWith(
              fontSize: 23,
              fontWeight: semibold,
            ),
          ),
        ),
      );
    }

    ListTile makeListTile(Map<String, dynamic> invoice) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${invoice['items'].length}', style: primaryTextStyle),
                Text(
                  'items',
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
            // child: Icon(Icons.autorenew, color: Colors.blue[800]),
          ),
          title: Text(
            invoice['invoice_number'],
            style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              // Expanded(
              //     flex: 1,
              //     child: LinearProgressIndicator(
              //         backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
              //         value: invoice['indicatorValue'],
              //         valueColor: AlwaysStoppedAnimation(Colors.green))),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    // padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('bayar ${invoice['payment']}',
                            style: secondaryTextStyle.copyWith(
                                fontSize: 11.0, fontWeight: FontWeight.w700)),
                        Text('Rp.${invoice['total_price']}',
                            style: priceTextStyle),
                      ],
                    )),
              )
            ],
          ),
          trailing: Text(
            invoice['status'] == "PENDING"
                ? "Belum dibayar"
                : invoice['status'] == "SHIPPING"
                    ? "Dikemas"
                    : invoice['status'] == "SHIPPED"
                        ? "Dikirim"
                        : "Diterima",
            style: primaryTextStyle.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: invoice['status'] == 'PENDING' ||
                        invoice['status'] == 'SHIPPING' ||
                        invoice['status'] == 'SHIPPED'
                    ? Colors.amber[700]
                    : invoice['status'] == 'CANCELLED' ||
                            invoice['status'] == 'FAILED'
                        ? Colors.red[700]
                        : Colors.green),
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => DetailPage(invoice: invoice)));
          },
        );

    Card makeCard(Map<String, dynamic> invoice) => Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(invoice),
          ),
        );

    Expanded invoiceList() => Expanded(
        child: FutureBuilder(
            future: productProvider.transactions(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> invoices = snapshot.data['data']['data'];
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: invoices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return makeCard(invoices[index]);
                    });
              } else {
                return CircularProgressIndicator();
              }
            }));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor3,
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: [header(), invoiceList()],
        ),
      )),
    );
  }
}
