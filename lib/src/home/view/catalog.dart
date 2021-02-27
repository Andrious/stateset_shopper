// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:stateset_shopper/src/view.dart';

import 'package:stateset_shopper/src/controller.dart';

class MyCatalog extends StatefulWidget {
  const MyCatalog({Key key}) : super(key: key);
  @override
  State createState() => _MyCatalogState();
}

class _MyCatalogState extends State<MyCatalog> with StateSet {
  @override
  Widget builder(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            _MyAppBar(),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index),
              ),
            ),
          ],
        ),
      );
}

class _AddButton extends StatefulWidget {
  const _AddButton({Key key, @required this.item}) : super(key: key);
  final CartController item;
  @override
  State createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> with StateSet {
  @override
  Widget build(BuildContext context) {
    //
    final item = widget.item;

    final isInCart = CartController.contains(item);

    // Rebuilds if 'root' State object is rebuilt.
    attachStateSet(context);

    return FlatButton(
      onPressed: isInCart ? null : () => item.add(this),
      splashColor: Theme.of(context).primaryColor,
      child: isInCart
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverAppBar(
        title: Text('Catalog', style: Theme.of(context).textTheme.headline1),
        floating: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      );
}

class _MyListItem extends StatelessWidget {
  const _MyListItem(this.index, {Key key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    //
    final cartItem = CartController.getByPosition(index);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: cartItem.color,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                cartItem.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(width: 24),
            _AddButton(item: cartItem),
          ],
        ),
      ),
    );
  }
}
