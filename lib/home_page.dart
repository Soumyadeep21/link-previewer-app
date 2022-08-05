import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// const url = "http://localhost:8080/scraper";
const url = "https://web-scraper-link.herokuapp.com/scraper";
const textColor = Color(0xff1F80E5);
const btnColor = Color(0xff2AA7ED);
const backgroundColor = Color(0xff171C28);
final radius = BorderRadius.circular(10);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = "";
  Meta? meta;
  bool isLoading = false;

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.comfortaa(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: btnColor,
        shape: RoundedRectangleBorder(borderRadius: radius),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(24, 4, 24, 12),
      ),
    );
  }

  void submit() async {
    if (text.trim().isEmpty) {
      showSnack("Please provide a Link!");
      return;
    }
    setState(() {
      meta = null;
      isLoading = true;
    });
    try {
      final resp = await http.post(
        Uri.parse(url),
        body: {"text": text},
      );
      // print("BODY : ${resp.body}");
      Map<String, dynamic> parsed = jsonDecode(resp.body);
      if (resp.statusCode != 200) {
        String msg = parsed["error"] ?? "Some error occurred!";
        showSnack(msg);
      } else {
        setState(() {
          meta = Meta.fromJson(parsed);
        });
      }
    } catch (err) {
      showSnack("Some error occurred!");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        title: SizedBox(
          height: kToolbarHeight - 4,
          child: Row(
            children: [
              Image.asset("assets/link.png"),
              const VerticalDivider(color: Colors.transparent),
              Text(
                "TECHLinks",
                style: GoogleFonts.itim(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GradientBtn(
              label: "Share",
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                Share.share(
                    'Preview your Links @ https://techlinks.netlify.app/');
              },
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: Center(
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Divider(color: Colors.transparent),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Image.asset("assets/home.png"),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Preview your Links!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Text(
                          "TechLinks is a tool that enables you to see the preview for your url as it would be seen when you share through social media.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comfortaa(
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Material(
                        borderRadius: radius,
                        color: backgroundColor,
                        type: MaterialType.card,
                        elevation: 4,
                        shadowColor: btnColor,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) => text = value,
                                onSubmitted: (value) {
                                  text = value;
                                  submit();
                                },
                                style: GoogleFonts.comfortaa(
                                  height: 2,
                                  fontSize: 20,
                                  color: Colors.blueGrey.shade300,
                                ),
                                cursorColor: Colors.blueGrey,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: radius,
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.white.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Transform.rotate(
                                      angle: math.pi / 9,
                                      child: const Icon(
                                        Icons.link_rounded,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  suffixIcon: GradientBtn(
                                    margin: const EdgeInsets.only(right: 8),
                                    label: "Preview",
                                    icon: const Icon(Icons.visibility_outlined),
                                    onPressed: submit,
                                  ),
                                  hintText: "Paste a link to preview it",
                                  hintStyle: GoogleFonts.comfortaa(
                                    height: 2,
                                    fontSize: 20,
                                    color: Colors.blueGrey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Made with ❤️  in India 🇮🇳",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.comfortaa(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      AnimatedOpacity(
                        opacity: meta == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: MetaView(meta: meta),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetaView extends StatelessWidget {
  const MetaView({
    Key? key,
    required this.meta,
  }) : super(key: key);

  final Meta? meta;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: radius,
      color: backgroundColor,
      type: MaterialType.card,
      elevation: 4,
      shadowColor: btnColor,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 24,
        ),
        child: meta == null
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (meta!.image != null) ...[
                    Container(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                      ),
                      child: Image.network(meta!.image!),
                    ),
                    const Divider(color: Colors.transparent),
                  ],
                  if (meta!.title != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (meta!.favicon != null) ...[
                          Image.network(
                            meta!.favicon!,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            meta!.title!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.comfortaa(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.transparent),
                  ],
                  if (meta!.description != null) ...[
                    Text(
                      meta!.description!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comfortaa(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(color: Colors.transparent),
                  ],
                  if (meta!.url != null)
                    GradientBtn(
                      label: "Know More",
                      icon: const Icon(Icons.read_more_rounded),
                      textSize: 16,
                      height: 48,
                      tooltipMsg: meta!.url!,
                      onPressed: () async {
                        await launchUrl(Uri.parse(meta!.url!));
                      },
                    ),
                ],
              ),
      ),
    );
  }
}

class GradientBtn extends StatelessWidget {
  const GradientBtn({
    Key? key,
    this.onPressed,
    required this.label,
    this.icon,
    this.margin,
    this.height,
    this.tooltipMsg = "",
    this.textSize = 14,
  }) : super(key: key);

  final String label;
  final Widget? icon;
  final EdgeInsetsGeometry? margin;
  final double textSize;
  final double? height;
  final String tooltipMsg;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMsg,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      child: Container(
        margin: margin,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff28A1EC), Color(0xff1763DF)],
          ),
          borderRadius: radius,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
            ),
            // onPrimary: Colors.red,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Meta {
  String? url;
  String? title;
  String? favicon;
  String? description;
  String? image;
  String? author;

  Meta({
    this.author,
    this.description,
    this.favicon,
    this.image,
    this.title,
    this.url,
  });

  factory Meta.fromJson(Map<dynamic, dynamic> data) => Meta(
        author: data['author'],
        description: data['description'],
        favicon: data['favicon'],
        image: data['image'],
        title: data['title'],
        url: data['url'],
      );
}
