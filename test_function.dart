import 'lib/searchimage.dart';

void main() async {
  print('Testing getFirstImageUrl with query: "dosa"');
  print('Fetching image...\n');

  final imageBytes = await getFirstImageUrl('dosa');

  if (imageBytes != null) {
    print('✅ Success!');
    print('Image downloaded successfully');
    print('Image size: ${imageBytes.length} bytes');
  } else {
    print('❌ Failed!');
    print('Could not fetch image for query "dosa"');
  }
}
