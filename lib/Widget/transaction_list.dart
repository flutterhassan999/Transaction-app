import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transc;
  final deleteTx;
  TransactionList(this.transc,this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return  transc.isEmpty
          ? LayoutBuilder(builder:(context,constraints){
            return Column(
              children: [
                const Text('No Transaction added yet!!!'),
                SizedBox(
                  height: constraints.maxHeight*0.6,
                ),
                Image.asset('assets/images/pensive.png'),
              ],
            );
          })
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transc[index].amount.toStringAsFixed(2)}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(transc[index].title),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transc[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width>350 ?
                    TextButton.icon(
                      onPressed: () {
                        deleteTx(transc[index].id);
                      },
                      label:const Text('Delete'),
                      icon: const Icon(Icons.delete),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).errorColor,
                      ),
                      )
                     :IconButton(
                      onPressed: () {
                        deleteTx(transc[index].id);
                      },
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              },
              itemCount: transc.length,
    );
  }
}
