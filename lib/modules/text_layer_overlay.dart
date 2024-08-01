import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class TextLayerOverlay extends StatefulWidget {
  final int index;
  final TextLayerData layer;
  final Function onUpdate;

  const TextLayerOverlay({
    super.key,
    required this.layer,
    required this.index,
    required this.onUpdate,
  });

  @override
  createState() => _TextLayerOverlayState();
}

class _TextLayerOverlayState extends State<TextLayerOverlay> {
  double slider = 0.0;
  String selectedFont = 'Roboto';
  final List<String> popularFonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Oswald',
    'Raleway',
    'Merriweather',
    'Ubuntu',
    'Playfair Display',
    'Dancing Script',
    'Pacifico',
    'Great Vibes',
    'Lobster',
    'Indie Flower',
    'Bebas Neue',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedFont = widget.layer.font;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        i18n('Font'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButtonFormField<String>(
                            value: selectedFont,
                            items: popularFonts
                                .map<DropdownMenuItem<String>>((String font) {
                              return DropdownMenuItem<String>(
                                value: font,
                                child: Text(
                                  font,
                                  style: GoogleFonts.getFont(
                                    font,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFont = newValue!;
                                widget.layer.font = selectedFont;
                                widget.onUpdate();
                              });
                            },
                            decoration: InputDecoration(
                              filled: false,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        i18n('Size'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          thumbColor: Colors.white,
                          value: widget.layer.size,
                          min: 0.0,
                          max: 100.0,
                          onChangeEnd: (v) {
                            setState(() {
                              widget.layer.size = v.toDouble();
                              widget.onUpdate();
                            });
                          },
                          onChanged: (v) {
                            setState(() {
                              slider = v;
                              // print(v.toDouble());
                              widget.layer.size = v.toDouble();
                              widget.onUpdate();
                            });
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.layer.backgroundOpacity = 0.5;
                            widget.onUpdate();
                          });
                        },
                        child: Text(
                          i18n('Reset'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            i18n('Color'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.layer.color = Colors.white;
                                  widget.onUpdate();
                                });
                              },
                              child: Text(i18n('Reset'),
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                    FastColorPicker(
                      selectedColor: widget.layer.color,
                      onColorSelected: (color) {
                        setState(() {
                          widget.layer.color = color;
                          widget.onUpdate();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            i18n('Background Color'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.layer.background = Colors.transparent;
                                  widget.layer.backgroundOpacity = 0;
                                  widget.onUpdate();
                                });
                              },
                              child: Text(
                                i18n('Reset'),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ],
                    ),
                    FastColorPicker(
                      selectedColor: widget.layer.background,
                      onColorSelected: (color) {
                        setState(() {
                          widget.layer.background = color;
                          if (widget.layer.backgroundOpacity == 0) {
                            widget.layer.backgroundOpacity = 0.5;
                          }

                          widget.onUpdate();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        i18n('Background Opacity'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 1,
                          divisions: 100,
                          value: widget.layer.backgroundOpacity,
                          thumbColor: Colors.white,
                          onChanged: (double value) {
                            setState(() {
                              widget.layer.backgroundOpacity = value;
                              widget.onUpdate();
                            });
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            widget.layer.backgroundOpacity = 0;
                            widget.onUpdate();
                          });
                        },
                        child: Text(
                          i18n('Reset'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ]),
                  ]),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    removedLayers.add(layers.removeAt(widget.index));

                    Navigator.pop(context);
                    widget.onUpdate();
                    // back(context);
                    // setState(() {});
                  },
                  child: Text(
                    i18n('Remove'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
