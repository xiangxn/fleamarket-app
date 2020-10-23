import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:flutter/material.dart';

class AddressSelectCard extends StatelessWidget {
  AddressSelectCard({Key key, this.address, this.onTap, this.noDataHints}) : super(key: key);

  final ReceiptAddress address;
  final Function onTap;
  final String noDataHints;

  @override
  Widget build(BuildContext context) {
    assert(noDataHints != null || address != null, 'Give a Address or give an no data of hints');
    return InkWell(
      onTap: this.onTap,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: address == null
                      ? Center(
                          child: Text(noDataHints ?? 'no data'),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[Text(address.name), Text(address.phone)],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                '${address.province}${address.city}${address.district} ${address.address} （${address.postcode}）',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400])
            ],
          ),
        ),
      ),
    );
  }
}
