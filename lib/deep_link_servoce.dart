import 'dart:developer';

import 'package:alarm_app/pages/page1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import 'pages/page2.dart';

class ContextUtility {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'ContextUtilityNavigatorKey');
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static bool get hasNavigator => navigatorKey.currentState != null;
  static NavigatorState? get navigator => navigatorKey.currentState;

  static bool get hasContext => navigator?.overlay?.context != null;
  static BuildContext? get context => navigator?.overlay?.context;
}

class UniLinksService {
  static String _promoId = '';
  static String get promoId => _promoId;
  static bool get hasPromoId => _promoId.isNotEmpty;

  static void reset() => _promoId = '';

  static Future<void> init({checkActualVersion = false}) async {
    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();
      log('Initial URI: $uri');
      navLinkRouteHandler(uri: uri);
    } on PlatformException {
      if (kDebugMode) {
        print("(PlatformException) Failed to receive initial uri.");
      }
    } on FormatException catch (error) {
      if (kDebugMode) {
        print(
            "(FormatException) Malformed Initial URI received. Error: $error");
      }
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    uriLinkStream.listen((Uri? uri) async {
      navLinkRouteHandler(uri: uri);
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error');
    });
  }

  static Future<void> navLinkRouteHandler({required Uri? uri}) async {
    log('Received URI: $uri');
    String? path = uri?.path;
    Map<String, String> params = uri?.queryParameters ?? <String, String>{};
    log('Received URI Path: $path Params: $params');

    if (path == null) return;
    if (path == '/page1') {
      String? promoId = params['promo-id'];
      ContextUtility.navigator
          ?.push(MaterialPageRoute(builder: (_) => Page1(data: promoId)));
    }
    if (path == '/page2') {
      String? id = params['id'];
      if (id == null || id.isEmpty) {
        showAboutDialog(
          context: ContextUtility.context!,
          applicationName: 'Alarm App',
          applicationVersion: '1.0.0',
          children: [
            const Text('No ID found'),
          ],
        );
        return;
      }
      ContextUtility.navigator
          ?.push(MaterialPageRoute(builder: (_) => Page2(data: id)));
    }

    // if (uri == null || uri.queryParameters.isEmpty) return;
    // log('Received URI Params: $params');

    // String receivedPromoId = params['promo-id'] ?? '';
    // // log('Received Promo ID: $receivedPromoId');
    // if (receivedPromoId.isEmpty) return;
    // _promoId = receivedPromoId;

    // // if (_promoId == 'ABC1') {
    // ContextUtility.navigator
    //     ?.push(MaterialPageRoute(builder: (_) => Page1(data: params)));
    // // }

    // if (_promoId == 'ABC2') {
    //   // ContextUtility.navigator?.push(
    //   //   MaterialPageRoute(builder: (_) => const RedPromoScreen()),
    //   // );
    // }
  }
}
