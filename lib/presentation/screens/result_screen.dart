import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result/tax_deduction_card.dart';
import '../widgets/result/future_asset_card.dart';
import '../widgets/result/pension_receipt_card.dart';
import '../widgets/charts/asset_change_chart.dart';

/// 결과 화면
class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => ResultScreenState();
}

class ResultScreenState extends ConsumerState<ResultScreen> {
  final GlobalKey _contentKey = GlobalKey();
  bool _isCapturing = false;

  /// 전체 콘텐츠를 이미지로 캡처
  Future<ui.Image?> _captureFullContent() async {
    try {
      final RenderRepaintBoundary boundary =
          _contentKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      // 고해상도 이미지 생성
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      return image;
    } catch (e) {
      debugPrint('캡처 실패: $e');
      return null;
    }
  }

  /// 이미지를 바이트로 변환
  Future<Uint8List?> _imageToBytes(ui.Image image) async {
    try {
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('이미지 변환 실패: $e');
      return null;
    }
  }

  /// 스크린샷 캡처 및 공유
  Future<void> _captureAndShare() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      final image = await _captureFullContent();
      if (image == null) {
        throw Exception('스크린샷 캡처 실패');
      }

      final bytes = await _imageToBytes(image);
      if (bytes == null) {
        throw Exception('이미지 변환 실패');
      }

      // 임시 파일로 저장
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/pension_result_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(bytes);

      // 공유
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: '연금 플래너 360 - 계산 결과',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('공유 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  /// 스크린샷 캡처 및 저장
  Future<void> _captureAndSave() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      final image = await _captureFullContent();
      if (image == null) {
        throw Exception('스크린샷 캡처 실패');
      }

      final bytes = await _imageToBytes(image);
      if (bytes == null) {
        throw Exception('이미지 변환 실패');
      }

      // Documents 폴더에 저장
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/pension_result_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 완료: $imagePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  /// 공유 옵션 표시 (public method for HomeScreen)
  void showShareOptions() {
    if (_isCapturing) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('공유하기'),
              subtitle: const Text('전체 결과를 이미지로 공유'),
              onTap: () {
                Navigator.pop(context);
                _captureAndShare();
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('이미지로 저장'),
              subtitle: const Text('전체 결과를 이미지 파일로 저장'),
              onTap: () {
                Navigator.pop(context);
                _captureAndSave();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taxDeduction = ref.watch(taxDeductionResultProvider);
    final futureAsset = ref.watch(futureAssetResultProvider);
    final pensionReceipt = ref.watch(pensionReceiptResultProvider);
    final assetChange = ref.watch(assetChangeResultProvider);

    return SingleChildScrollView(
      child: RepaintBoundary(
        key: _contentKey,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 요약 안내
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '입력값 변경 시 자동으로 재계산됩니다',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 세액공제 결과
              TaxDeductionCard(result: taxDeduction),
              const SizedBox(height: 16),

              // 미래자산 결과
              FutureAssetCard(result: futureAsset),
              const SizedBox(height: 16),

              // 연금수령 시뮬레이션 결과
              PensionReceiptCard(result: pensionReceipt),
              const SizedBox(height: 16),

              // 자산변화 차트
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '자산 변화 시뮬레이션',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AssetChangeChart(result: assetChange),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
