import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class SelfieCaptureScreen extends StatefulWidget {
  const SelfieCaptureScreen({super.key});

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  CameraController? _controller;
  bool _isLoading = false;
  bool _isFaceValid = false;
  String? _error;
  bool _isDetecting = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
      minFaceSize: 0.15,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();
    await _controller!.startImageStream(_processCameraImage);

    if (mounted) setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || _isLoading) return;
    _isDetecting = true;

    try {
      final inputImage = _convertToInputImage(image);
      if (inputImage == null) {
        _isDetecting = false;
        return;
      }

      final faces = await _faceDetector.processImage(inputImage);

      bool valid = false;

      if (faces.length == 1) {
        final face = faces.first;

        // Eyes check (optional – kuch devices pe null aata hai)
        final leftOk =
            face.leftEyeOpenProbability == null ||
            face.leftEyeOpenProbability! >= 0.3;
        final rightOk =
            face.rightEyeOpenProbability == null ||
            face.rightEyeOpenProbability! >= 0.3;

        final bigEnough = face.boundingBox.width >= 80;

        valid = leftOk && rightOk && bigEnough;
      }

      if (mounted && valid != _isFaceValid) {
        setState(() {
          _isFaceValid = valid;
        });
      }
    } catch (e) {
      debugPrint('Face detect error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  /// Android + iOS dono ke liye sahi conversion
  InputImage? _convertToInputImage(CameraImage image) {
    try {
      final camera = _controller!.description;

      // ----- Rotation -----
      final sensorOrientation = camera.sensorOrientation;
      InputImageRotation? rotation;

      if (Platform.isIOS) {
        rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
      } else {
        // Android
        rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
        // Front camera pe kabhi-kabhi adjust karna padta hai
        rotation ??= InputImageRotation.rotation270deg;
      }

      if (rotation == null) return null;

      // ----- Format -----
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      // ----- Bytes -----
      // Android NV21: saare planes merge karo
      late Uint8List bytes;
      if (Platform.isAndroid) {
        final WriteBuffer allBytes = WriteBuffer();
        for (final Plane plane in image.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        bytes = allBytes.done().buffer.asUint8List();
      } else {
        bytes = image.planes.first.bytes;
      }

      final plane = image.planes.first;

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('Convert error: $e');
      return null;
    }
  }

  Future<void> _capture() async {
    if (!_isFaceValid || _controller == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _controller!.stopImageStream();

      final XFile file = await _controller!.takePicture();

      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        throw Exception('No face detected. Please try again.');
      }
      if (faces.length > 1) {
        throw Exception('Multiple faces detected.');
      }

      if (mounted) {
        Navigator.pop(context, file.path);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isFaceValid = false;
      });

      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.startImageStream(_processCameraImage);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final size = MediaQuery.of(context).size;

    const double ovalWidth = 260;
    const double ovalHeight = 320;

    final Color borderColor = _isFaceValid
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: customText(
          title: 'Take a Selfie',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.headingColor,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                ),

                // White cutout
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          backgroundBlendMode: BlendMode.dstOut,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: ovalWidth,
                          height: ovalHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ovalWidth / 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Border RED / GREEN
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: ovalWidth,
                    height: ovalHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ovalWidth / 2),
                      border: Border.all(color: borderColor, width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_error != null)
            Container(
              width: double.infinity,
              color: Colors.red.shade600,
              padding: const EdgeInsets.all(12),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            child: Column(
              children: [
                customText(
                  title: _isFaceValid
                      ? 'Face detected! You can capture now'
                      : 'Position your face inside the oval',
                  fontSize: 14,
                  color: _isFaceValid
                      ? const Color(0xFF4CAF50)
                      : colors.subTitleColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: (_isFaceValid && !_isLoading) ? _capture : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isFaceValid
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade400,
                        width: 4,
                      ),
                      color: _isLoading
                          ? Colors.grey.shade300
                          : (_isFaceValid
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade300),
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(18),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt_rounded,
                            color: _isFaceValid
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: 32,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
