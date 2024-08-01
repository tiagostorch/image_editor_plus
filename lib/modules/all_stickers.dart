import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image/image.dart' as img;

class Stickers extends StatefulWidget {
  final List<String> urls;
  const Stickers({super.key, required this.urls});

  @override
  createState() => _StickersState();
}

class _StickersState extends State<Stickers> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        height: 400,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 10.9,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                i18n('Select Sticker'),
                style: const TextStyle(color: Colors.white),
              ),
            ]),
            const SizedBox(height: 16),
            Container(
              height: 315,
              padding: const EdgeInsets.all(0.0),
              child: GridView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0.0,
                  maxCrossAxisExtent: 65.0,
                ),
                children: widget.urls.map((sticker) {
                  return GridTile(
                      child: GestureDetector(
                    onTap: () async {
                      final bytes =
                          (await NetworkAssetBundle(Uri.parse(sticker))
                                  .load(sticker))
                              .buffer
                              .asUint8List();
                      late Uint8List compressedBytes;

                      img.Image originalImage = img.decodeImage(bytes)!;
                      if (originalImage.numChannels == 4) {
                        img.Image resizedImage = img.copyResize(originalImage,
                            width: originalImage.width ~/ 2);

                        compressedBytes =
                            Uint8List.fromList(img.encodePng(resizedImage));
                      } else {
                        img.Image resizedImage = img.copyResize(originalImage,
                            width: originalImage.width ~/ 2);
                        compressedBytes = Uint8List.fromList(
                            img.encodeJpg(resizedImage, quality: 70));
                      }

                      Navigator.pop(
                        context,
                        ImageLayerData(
                          image: ImageItem(compressedBytes),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      child: Image.network(sticker),
                    ),
                  ));
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
