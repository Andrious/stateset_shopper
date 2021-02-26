// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:flutter/foundation.dart';

import 'package:stateset_shopper/src/model.dart';

import 'package:stateset_shopper/src/view.dart';

import 'package:stateset_shopper/src/controller.dart';

class Cart {
  Cart({Item item, State state}) {
    _item = item;
    _state = state;
  }
  Item _item;
  State _state;

  /// Adds [Cart] to cart. This is the only way to modify the cart from outside.
  void add() {
    _itemIds.add(this);
    // ignore: invalid_use_of_protected_member
    _state?.setState(() {});
  }

  static void remove(Item item) {
//    final index = _itemIds.indexWhere((cart) => cart._item.id == item.id);

//    Cart cart = _itemIds[index];

    _itemIds.removeWhere((cart) => cart._item.id == item.id);

    // ignore: invalid_use_of_protected_member
//    cart._state?.setState(() {});

    // ignore: invalid_use_of_protected_member
    StateSet.rebuild();
  }

  /// The static fields preserve the cart's content.

  /// The private field backing [catalog].
  static CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  static final List<Cart> _itemIds = [];

  /// The current catalog. Used to construct items from numeric ids.
  static CatalogModel get catalog => _catalog;

  static set catalog(CatalogModel newCatalog) {
    assert(newCatalog != null, 'Cannot assign null to _catalog!');
    assert(_catalog == null, 'Catalog already defined');
    assert(_itemIds.every((cart) => newCatalog.getById(cart._item.id) != null),
        'The catalog $newCatalog does not have one of $_itemIds in it.');
    _catalog = newCatalog;
  }

  /// List of items in the cart.
  static List<Item> get items =>
      _itemIds.map((cart) => _catalog.getById(cart._item.id)).toList();

  /// The current total price of all items.
  static int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);
}
