import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SurahScreen extends StatefulWidget {
  final int suparaNumber;
  final String suparaName;

  const SurahScreen({required this.suparaNumber, required this.suparaName, super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List<String> pdfUrls = [];
  Map<String, Future<Uint8List?>> pdfCache = {};
  Map<String, int> retryCounts = {};
  late ScrollController _scrollController;
  bool isLoadingBatch = false;
  bool hasMorePages = true;
  int batchSize = 3; // Load 3 pages at a time
  final int maxVisiblePdfs = 10; // Buffer for active PDFView widgets
  bool isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadNextBatch();
  }

  void _scrollListener() {
    final pixels = _scrollController.position.pixels;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (hasMorePages && pixels >= maxExtent - 500 && !isLoadingBatch) {
      print('Scroll trigger: Loading next batch');
      _loadNextBatch();
    }
  }

  Future<void> _loadNextBatch() async {
    if (!hasMorePages || isLoadingBatch) {
      print('Batch load skipped: hasMorePages=$hasMorePages, isLoadingBatch=$isLoadingBatch');
      return;
    }

    setState(() {
      isLoadingBatch = true;
      if (pdfUrls.isEmpty) isInitialLoading = true;
    });

    try {
      for (int b = 0; b < batchSize; b++) {
        final int page = pdfUrls.length + 1;
        final url =
            'https://raw.githubusercontent.com/Built-By-Usman/Quran_with_urdu_translation/main/${widget.suparaNumber}/$page.pdf';
        print('Attempting to load PDF: $url');

        if (!pdfCache.containsKey(url)) {
          retryCounts[url] = 0;
          pdfCache[url] = _loadPdf(url).catchError((e) {
            print('Failed to load $url: $e');
            return Uint8List(0);
          });
        }

        final bytes = await pdfCache[url];

        if (bytes == null) {
          print('No more pages for Supara ${widget.suparaNumber} at page $page');
          hasMorePages = false;
          pdfCache.remove(url);
          retryCounts.remove(url);
          break;
        }

        setState(() {
          pdfUrls.add(url);
          print('Added PDF URL: $url, total pages loaded: ${pdfUrls.length}');
        });
      }
    } catch (e) {
      print('Error loading batch: $e');
    } finally {
      setState(() {
        isLoadingBatch = false;
        isInitialLoading = false;
      });
    }
  }

  Future<Uint8List?> _loadPdf(String url) async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    for (int attempt = (retryCounts[url] ?? 0) + 1; attempt <= maxRetries; attempt++) {
      try {
        print('Attempt $attempt/$maxRetries to fetch PDF: $url');
        final response = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Request timed out for $url'),
        );

        print('HTTP Response for $url: Status=${response.statusCode}, Content-Length=${response.bodyBytes.length}');

        if (response.statusCode == 404) {
          return null; // No more pages
        }

        if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
          throw Exception('Invalid PDF response for $url: Status ${response.statusCode}');
        }

        final header = String.fromCharCodes(response.bodyBytes.take(8));
        print('PDF Header check for $url: $header');
        if (!header.startsWith('%PDF-')) {
          throw Exception('Invalid PDF format for $url');
        }

        retryCounts[url] = 0;
        return response.bodyBytes;
      } catch (e) {
        retryCounts[url] = attempt;
        print('Error on attempt $attempt for $url: $e');
        if (attempt < maxRetries) {
          await Future.delayed(retryDelay);
          continue;
        }
        throw Exception('Failed to load PDF after $maxRetries attempts for $url');
      }
    }
    throw Exception('Unexpected error for $url');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    pdfCache.clear();
    retryCounts.clear();
    print('SurahScreen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1), // Assuming AppColors.greenForeground
      appBar: AppBar(
        title: Text(
          widget.suparaName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009688), Color(0xFF00796B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isInitialLoading
          ? _buildLoading()
          : ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: pdfUrls.length + (hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pdfUrls.length && hasMorePages) {
            return _pdfLoadingCard();
          }

          final url = pdfUrls[index];
          return FutureBuilder<Uint8List?>(
            future: pdfCache[url],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _pdfLoadingCard();
              } else if (snapshot.hasError || (snapshot.hasData && (snapshot.data?.isEmpty ?? true))) {
                return _pdfErrorCard(index, url);
              } else if (snapshot.hasData && snapshot.data != null) {
                // Only render PDFView for visible or near-visible items
                final visibleStartIndex = (_scrollController.position.pixels / 516).floor();
                final isVisible = index >= visibleStartIndex - 2 && index <= visibleStartIndex + maxVisiblePdfs + 2;
                return isVisible ? _pdfViewCard(snapshot.data!) : _pdfPlaceholderCard(index);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/loading.json',
            width: 160,
            height: 160,
            repeat: true,
          ),
          const SizedBox(height: 12),
          const Text(
            'Loading Supara...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _pdfLoadingCard() {
    return Container(
      height: 480,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: _cardDecoration(),
      child: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          width: 100,
          repeat: true,
        ),
      ),
    );
  }

  Widget _pdfErrorCard(int index, String url) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: _cardDecoration(color: Colors.red[50]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error loading page ${index + 1}', style: const TextStyle(color: Colors.red)),
          TextButton.icon(
            onPressed: () {
              setState(() {
                print('Retrying PDF load for $url');
                pdfCache[url] = _loadPdf(url).catchError((e) {
                  print('Retry failed for $url: $e');
                  return Uint8List(0);
                });
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _pdfViewCard(Uint8List pdfData) {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PDFView(
          pdfData: pdfData,
          enableSwipe: true,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print('PDFView error: $error');
          },
          onRender: (pages) {
            print('PDFView rendered $pages pages');
          },
        ),
      ),
    );
  }

  Widget _pdfPlaceholderCard(int index) {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: _cardDecoration(),
      child: const Center(
        child: Text(
          'Page cached, scroll to view',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}