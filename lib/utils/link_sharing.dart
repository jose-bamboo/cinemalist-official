import 'package:share_plus/share_plus.dart';

void shareTrailerLink(String movieName, String trailerName, String url) {
  final youtubeUrl = 'https://www.youtube.com/watch?v=$url';
  Share.share(
    'Check this trailer out for $movieName - $trailerName $youtubeUrl',
  );
}
