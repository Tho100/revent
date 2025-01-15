import 'package:url_launcher/url_launcher.dart';

class OpenLink {

  final String url;

  OpenLink({required this.url});

  Future<void> open() async {

    final parsedUrl = Uri.parse(url);

    await launchUrl(parsedUrl);

  }

  bool isValidUrl() {
    return RegExp(r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?')
      .hasMatch(url);
  }

}