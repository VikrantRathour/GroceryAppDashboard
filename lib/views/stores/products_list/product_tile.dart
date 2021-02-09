import 'package:flutter/material.dart';
import 'package:grocery_app_dashboard/models/product.dart';

class ProductTile extends StatefulWidget {
  final Product product;

  const ProductTile({Key key, this.product}) : super(key: key);
  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0)],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Image(
                image: NetworkImage(widget.product.image),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                      ),
                      Text(
                        widget.product.name,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '₹ ${widget.product.price}',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFD11A),
                              size: 25.0,
                            ),
                            Text(
                              '4.9',
                              style: TextStyle(
                                  color: Color(0xFFFFD11A), fontSize: 25.0),
                            )
                          ],
                        ),
                        Text(
                          '250 reviews',
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        )
                      ],
                    )
                  ]),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(20.0),
            //         bottomRight: Radius.circular(20.0)),
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   child: Center(
            //     child: Text(
            //       'View Details',
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           fontSize: 20.0),
            //     ),
            //   ),
            //   height: 50.0,
            // ),
          ],
        ),
      ),
    );
  }
}
