import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class Stickers extends StatefulWidget {
  final List<String> urls;
  const Stickers({super.key, required this.urls});

  @override
  createState() => _StickersState();
}

class _StickersState extends State<Stickers> {
  final List<Uint8List> images = [];
  bool loading = true;

  Future<void> _processStickers() async {
    for (var url in widget.urls) {
      final file = await DefaultCacheManager().getSingleFile(url);
      final bytes = file.readAsBytesSync();
      images.add(bytes);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _processStickers();
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
              child: loading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : GridView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 0.0,
                        maxCrossAxisExtent: 65.0,
                      ),
                      children: images.map((sticker) {
                        return GridTile(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context,
                                ImageLayerData(image: ImageItem(sticker)));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            child: Image.memory(sticker),
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
