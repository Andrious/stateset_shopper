// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:stateset_shopper/src/view.dart';

import 'package:stateset_shopper/src/controller.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key key}) : super(key: key);
  @override
  State createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> with StateSet {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Cart', style: Theme.of(context).textTheme.headline1),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.yellow,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: _CartList(),
                ),
              ),
              const Divider(height: 4, color: Colors.black),
              _CartTotal(),
            ],
          ),
        ),
      );
}

class _CartList extends StatelessWidget {
  _CartList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: Cart.items.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.done),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              Cart.remove(Cart.items[index]);
              final _MyCartState state = StateSet.to<_MyCartState>();
              // ignore: invalid_use_of_protected_member
              state?.setState(() {});
            },
          ),
          title: Text(
            Cart.items[index].name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
}

class _CartTotal extends StatelessWidget {
  _CartTotal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${Cart.totalPrice}',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 48)),
            const SizedBox(width: 24),
            FlatButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text('Buying not supported yet.')));
              },
              color: Colors.white,
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
