import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/items.dart';
import '../models/user.dart';
import '../myConfig.dart';

class ItemDetail extends StatefulWidget {
  final User user;
  final Item item;
  const ItemDetail({super.key, required this.user, required this.item});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  late double screenH, screenW;
  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: Container(
        width: screenW, // Specify the desired width
        height: screenH, // Specify the desired height
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Card(
                      child: Container(
                        width: screenW,
                        child: CachedNetworkImage(
                          width: screenW,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().server}/barterit/assets/items/${widget.item.itemId}_1.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 5),
              Text(
                widget.item.itemName.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                child: Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Table(
                        border: TableBorder.all(
                            color: Theme.of(context).colorScheme.secondary),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(6)
                        },
                        children: [
                          TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  "Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child:
                                  Text(widget.item.itemDescription.toString()),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Item Type",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(widget.item.itemType.toString()),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Quantity Available",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(widget.item.itemQuantity.toString()),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Item Price",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  "RM ${double.parse(widget.item.itemPrice.toString()).toStringAsFixed(2)}"),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Location",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                  "${widget.item.locality}/${widget.item.state}"),
                            ))
                          ]),
                          TableRow(children: [
                            const TableCell(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Date",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  df.format(DateTime.parse(
                                      widget.item.date.toString())),
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
