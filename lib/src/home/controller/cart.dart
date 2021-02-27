// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:flutter/foundation.dart';

import 'package:stateset_shopper/src/model.dart';

import 'package:stateset_shopper/src/view.dart';

import 'package:stateset_shopper/src/controller.dart';

class CartController {
  CartController(Item item) {
    _item = item;
  }
  Item _item;
  State _state;

  /// Access the Model's fields
  String get name => _item?.name;

  Color get color => _item?.color;

  int get price => _item?.price;

  /// Adds [CartController] to cart. This is the only way to modify the cart from outside.
  void add(State state) {
    _items.add(this);
    // Reference the State object.
    _state = state;
    // ignore: invalid_use_of_protected_member
    state?.setState(() {});
  }

  /// Remove item from the cart
  static void remove(CartController item) {
    _items.removeWhere((cart) => cart._item.id == item._item.id);

    StateSet.rebuild();

    // final index = _itemIds.indexWhere((cart) => cart._item.id == item._item.id);
    //
    // final Cart cart = _itemIds.removeAt(index);
    //
    // // ignore: invalid_use_of_protected_member
    // cart._state?.setState(() {});
  }

  /// The private field backing [catalog].
  static CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  static final List<CartController> _items = [];

  /// The current catalog. Used to construct items from numeric ids.
  static CatalogModel get catalog => _catalog ??= CatalogModel();

  /// Assign the item catalog
  static set catalog(CatalogModel newCatalog) {
    assert(newCatalog != null, 'Cannot assign null to _catalog!');
    assert(_catalog == null, 'Catalog already defined');
    assert(_items.every((cart) => newCatalog.getById(cart._item.id) != null),
        'The catalog $newCatalog does not have one of $_items in it.');
    _catalog = newCatalog;
  }

  /// List of items in the cart.
  static List<CartController> get items => _items;

  /// Get item by its position in the catalog.
  // ignore: prefer_constructors_over_static_methods
  static CartController getByPosition(int position) =>
      CartController(catalog.getByPosition(position));

  /// Item already in the cart?
  static bool contains(CartController item) =>
      CartController._items.contains(item);

  /// The current total price of all items.
  static int get totalPrice =>
      _items.fold(0, (total, current) => total + current.price);
}
