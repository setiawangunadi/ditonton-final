import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class Network {
  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<http.Client> get httpClient async {
    _secureClient ??= _createSecureClient();
    return _secureClient!;
  }

  Future<http.Client>? _secureClient;

  Future<http.Client> _createSecureClient() async {
    final httpClient = HttpClient(context: await globalContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(httpClient);
  }
}

final network = Network();
