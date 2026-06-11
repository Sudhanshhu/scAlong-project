import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_button.dart';

class CaptchaScreen extends StatefulWidget {
  final String captchaId;
  final String captchaImage;

  const CaptchaScreen({
    super.key,
    required this.captchaId,
    required this.captchaImage,
  });

  @override
  State<CaptchaScreen> createState() => _CaptchaScreenState();
}

class _KSliderTrackPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color activeColor;

  _KSliderTrackPainter({
    required this.progress,
    required this.trackColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(rrect, paint);

    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill;
      final RRect activeRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        Radius.circular(size.height / 2),
      );
      canvas.drawRRect(activeRRect, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CaptchaScreenState extends State<CaptchaScreen> {
  double _sliderValue = 0.0;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Parse the base64 image data URI
    final String base64Data = widget.captchaImage.contains(',')
        ? widget.captchaImage.split(',').last
        : widget.captchaImage;
    final imageBytes = base64Decode(base64Data);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Check'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(false),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCaptchaValidated) {
            setState(() {
              _isSuccess = true;
            });
            // Return true to the caller to signal successful CAPTCHA validation
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) {
                context.pop(true);
              }
            });
          } else if (state is AuthFailure) {
            // Reset slider on failure
            setState(() {
              _sliderValue = 0.0;
              _isSuccess = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: KText(
                  state.message.replaceAll('Exception:', '').trim(),
                  color: Colors.white,
                ),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isValidating = state is AuthCaptchaValidating;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const KText(
                  'Complete the Verification',
                  style: KTextStyle.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                KText(
                  'Drag the slider to verify you are a human.',
                  style: KTextStyle.bodyMedium,
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Render CAPTCHA Image
                Container(
                  height: 150,
                  width: 250,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.error_outline, size: 40, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                
                // Slider UI
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_isSuccess || isValidating) return;
                    final box = context.findRenderObject() as RenderBox;
                    final localOffset = box.globalToLocal(details.globalPosition);
                    final double relativeX = localOffset.dx - 24; // margin padding
                    final double maxWidth = box.size.width - 48;
                    
                    setState(() {
                      _sliderValue = (relativeX / maxWidth).clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isSuccess || isValidating) return;
                    if (_sliderValue >= 0.95) {
                      setState(() {
                        _sliderValue = 1.0;
                      });
                      // Submit validation
                      context.read<AuthCubit>().submitCaptcha(
                            captchaId: widget.captchaId,
                            captchaInput: 'slider-verified',
                          );
                    } else {
                      // Reset slider if released early
                      setState(() {
                        _sliderValue = 0.0;
                      });
                    }
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final trackWidth = constraints.maxWidth;
                      final handleSize = 48.0;
                      final maxDragWidth = trackWidth - handleSize;
                      final currentOffset = _sliderValue * maxDragWidth;

                      return Container(
                        height: handleSize,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(handleSize / 2),
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // Track Background with progress
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _KSliderTrackPainter(
                                  progress: _sliderValue,
                                  trackColor: theme.colorScheme.outline.withOpacity(0.15),
                                  activeColor: _isSuccess 
                                      ? Colors.green.shade400 
                                      : theme.colorScheme.primary.withOpacity(0.4),
                                ),
                              ),
                            ),
                            
                            // Track Text Hint
                            Center(
                              child: KText(
                                _isSuccess
                                    ? 'Verified!'
                                    : (isValidating ? 'Validating...' : 'Slide to the right >>'),
                                style: KTextStyle.bodyMedium,
                                color: theme.colorScheme.onBackground.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            // Slider Handle
                            Positioned(
                              left: currentOffset,
                              child: Container(
                                height: handleSize,
                                width: handleSize,
                                decoration: BoxDecoration(
                                  color: _isSuccess 
                                      ? Colors.green.shade500 
                                      : theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isSuccess
                                        ? Icons.check
                                        : (isValidating 
                                            ? Icons.sync 
                                            : Icons.chevron_right),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
