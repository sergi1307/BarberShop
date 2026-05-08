import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/services.dart';
class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _pujarParaSerVisto = true;
  double _pujaAmount = 0.0;
  String _selectedObjetivo = 'Visitas a página web';
  
  final List<Uint8List> _bannerImagesBytes = [];
  String _adTitle = '';
  String _adDescription = '';
  String _adCompanyName = '';

  final int _totalSteps = 4;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Nuevo Anuncio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTopNav(),
                      BannerPreviewWidget(
                        imagesBytes: _bannerImagesBytes,
                        companyName: _adCompanyName,
                        title: _adTitle,
                        description: _adDescription,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildCurrentStepContent(),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem(0, 'Info'),
          _buildNavDivider(),
          _buildStepItem(1, 'Creativo'),
          _buildNavDivider(),
          _buildStepItem(2, 'Presupuesto'),
          _buildNavDivider(),
          _buildStepItem(3, 'Pago'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepIndex, String title) {
    bool isActive = _currentStep == stepIndex;
    bool isCompleted = _currentStep > stepIndex;

    Color color = isActive || isCompleted ? Colors.black87 : Colors.grey.shade400;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? Colors.black87 : (isCompleted ? Colors.black87 : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNavDivider() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18, left: 4, right: 4), // Alineado visualmente con los círculos
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildCreativeStep();
      case 2:
        return _buildBudgetStep();
      case 3:
        return _buildPaymentStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    String destinoLabel = 'Destino';
    String destinoHint = '';
    
    if (_selectedObjetivo == 'Llamadas') {
      destinoLabel = 'Número de teléfono';
      destinoHint = 'Ej. 555-1234';
    } else if (_selectedObjetivo == 'Descargas de app') {
      destinoLabel = 'Enlace de la App';
      destinoHint = 'Inserta enlace de Google Play o App Store';
    } else {
      destinoLabel = 'Página de Destino (URL)';
      destinoHint = 'https://...';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Información Básica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Datos principales de tu negocio', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        _buildTextField(
          'Nombre de la Empresa', 
          'Ej. The Executive Grooming',
          textCapitalization: TextCapitalization.words,
          onChanged: (val) => setState(() => _adCompanyName = val.isNotEmpty ? val : 'Tu Empresa'),
          validator: (val) {
            if (val == null || val.isEmpty) return 'El nombre es obligatorio';
            if (val.length < 3) return 'El nombre debe tener al menos 3 caracteres';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          'Objetivo', 
          ['Visitas a página web', 'Llamadas', 'Descargas de app'],
          value: _selectedObjetivo,
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedObjetivo = val;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          destinoLabel, 
          destinoHint, 
          isNumber: _selectedObjetivo == 'Llamadas',
          validator: (val) {
            if (val == null || val.isEmpty) return 'Este campo es obligatorio';
            if (_selectedObjetivo == 'Visitas a página web' || _selectedObjetivo == 'Descargas de app') {
              final urlPattern = r"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$";
              if (!RegExp(urlPattern).hasMatch(val)) return 'Introduce una URL válida (ej. https://...)';
            } else if (_selectedObjetivo == 'Llamadas') {
              final phonePattern = r"^[0-9\-\+\s]{9,15}$";
              if (!RegExp(phonePattern).hasMatch(val)) return 'Introduce un teléfono válido (mín. 9 dígitos)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCreativeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contenido Creativo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Textos e imágenes para el anuncio', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        _buildTextField(
          'Título', 
          'Ej. Gran apertura en el centro', 
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [CommaCapitalizationFormatter()],
          onChanged: (val) {
            setState(() {
              _adTitle = val.trim();
            });
          },
          validator: (val) {
            if (val == null || val.isEmpty) return 'El título es obligatorio';
            if (val.length < 10) return 'El título debe tener al menos 10 caracteres';
            if (val.length > 50) return 'El título no puede superar los 50 caracteres';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Descripción', 
          'Ej. Ven a conocernos y disfruta de un corte profesional', 
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [CommaCapitalizationFormatter()],
          onChanged: (val) {
            setState(() {
              _adDescription = val.trim();
            });
          },
          validator: (val) {
            if (val == null || val.isEmpty) return 'La descripción es obligatoria';
            if (val.length < 20) return 'La descripción debe tener al menos 20 caracteres';
            if (val.length > 150) return 'La descripción no puede superar los 150 caracteres';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildFilePicker(
          'Subir Imagen o Logo',
          isImagePicker: true,
          onTap: () => _showPickerOptions(),
        ),
        const SizedBox(height: 16),
        // _buildFilePicker('Subir Vídeos'),
        // const SizedBox(height: 16),
        // _buildDropdown('Preferencias de Formato', ['Optimizar para texto', 'Optimizar para vídeo', 'Equilibrado']),
      ],
    );
  }

  Widget _buildBudgetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Presupuesto y Puja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Detalles de facturación y puja', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Pujar para ser más visto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                subtitle: const Text('Aumenta tu visibilidad en búsquedas', style: TextStyle(fontSize: 12)),
                value: _pujarParaSerVisto,
                onChanged: (bool value) {
                  setState(() {
                    _pujarParaSerVisto = value;
                  });
                },
                activeTrackColor: Colors.black87,
                activeThumbColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              if (_pujarParaSerVisto)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'La media de puja actual en tu sector es de aprox. 1.25€ por interacción.',
                                style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Tu Puja Máxima (€)', 
                        'Ej. 1.50', 
                        isNumber: true, 
                        onChanged: (val) {
                          setState(() {
                            _pujaAmount = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Indica una puja';
                          final amount = double.tryParse(val.replaceAll(',', '.'));
                          if (amount == null || amount <= 0) return 'Introduce un importe válido';
                          if (amount < 0.10) return 'La puja mínima es de 0.10€';
                          return null;
                        },
                      ),
                      if (_pujaAmount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 16, color: Colors.green.shade700),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Estimación: Tu anuncio se mostrará el ${((_pujaAmount / 2.5) * 100).clamp(0, 100).toInt()}% del tiempo en pantalla',
                                  style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Presupuesto Mensual (€)', 
          'Ej. 500', 
          isNumber: true,
          validator: (val) {
            if (val == null || val.isEmpty) return 'El presupuesto es obligatorio';
            final amount = double.tryParse(val.replaceAll(',', '.'));
            if (amount == null || amount < 10) return 'El presupuesto mínimo es de 10€';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Datos de Facturación y Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Configura tus datos fiscales y domiciliación SEPA', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Datos de Facturación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildTextField(
                'Razón Social', 
                'Ej. Mi Empresa S.L. / Juan Pérez',
                textCapitalization: TextCapitalization.words,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'La Razón Social es obligatoria';
                  if (val.trim().length < 3) return 'Debe tener al menos 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'CIF / DNI / NIE', 
                'Ej. B12345678 / 12345678A',
                textCapitalization: TextCapitalization.characters,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'El documento es obligatorio';
                  String cleanDoc = val.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
                  if (!RegExp(r'^([0-9]{8}[A-Z]|[A-Z][0-9]{7}[A-Z0-9]|[XYZ][0-9]{7}[A-Z])$').hasMatch(cleanDoc)) {
                    return 'Formato inválido. Revisa tu DNI, CIF o NIE';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'Dirección Fiscal', 
                'Ej. Calle Mayor 1, 28001 Madrid',
                textCapitalization: TextCapitalization.sentences,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'La dirección fiscal es obligatoria';
                  if (val.trim().length < 10) return 'Introduce una dirección más detallada';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text('Domiciliación Bancaria (SEPA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildTextField(
                'Titular de la cuenta', 
                'Ej. Juan Pérez',
                textCapitalization: TextCapitalization.words,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'El titular es obligatorio';
                  if (!val.trim().contains(' ')) return 'Introduce nombre y apellidos';
                  if (val.length < 5) return 'Nombre demasiado corto';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'IBAN', 
                'ESXX XXXX XXXX XXXX XXXX XXXX',
                validator: (val) {
                  if (val == null || val.isEmpty) return 'El IBAN es obligatorio';
                  String cleanIban = val.replaceAll(' ', '').toUpperCase();
                  if (cleanIban.length < 15) return 'IBAN demasiado corto';
                  if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$').hasMatch(cleanIban)) {
                    return 'Formato de IBAN inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Al proporcionar tu IBAN, autorizas a BarberShop a enviar instrucciones a tu banco para adeudar en tu cuenta de acuerdo con las condiciones.',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label, 
    String hint, {
    int maxLines = 1, 
    bool isNumber = false, 
    ValueChanged<String>? onChanged, 
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            errorStyle: const TextStyle(fontSize: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, {String? value, ValueChanged<String?>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value ?? items.first,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged ?? (_) {},
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, {VoidCallback? onTap, bool isImagePicker = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey[500], size: 32),
                const SizedBox(height: 8),
                Text(
                  isImagePicker && _bannerImagesBytes.isNotEmpty 
                    ? '${_bannerImagesBytes.length} imagen(es). Toca para añadir más.' 
                    : 'Toca para subir archivos', 
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.black87),
                ),
                onPressed: () {
                  setState(() {
                    _currentStep -= 1;
                  });
                },
                child: const Text('Atrás'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_currentStep < _totalSteps - 1) {
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(_currentStep == _totalSteps - 1 ? 'Publicar Anuncio' : 'Siguiente'),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    // if (source == ImageSource.gallery) {
    //   final pickedFiles = await picker.pickMultiImage();
    //   if (pickedFiles.isNotEmpty) {
    //     for (var file in pickedFiles) {
    //       final bytes = await file.readAsBytes();
    //       if (mounted) {
    //         await _showCropDialog(bytes);
    //       }
    //     }
    //   }
    // } else {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) {
          await _showCropDialog(bytes);
        }
      }
    // }
  }

  Future<void> _showCropDialog(Uint8List imageBytes) async {
    final controller = CropController(
      aspectRatio: 300 / 50,
      defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Ajustar Imagen'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: CropImage(
            controller: controller,
            image: Image.memory(imageBytes),
            paddingSize: 25.0,
            alwaysMove: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Saltar / Cancelar', style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            onPressed: () async {
              final bitmap = await controller.croppedBitmap();
              final data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
              if (data != null) {
                setState(() {
                  _bannerImagesBytes.clear(); // Solo una imagen de momento
                  _bannerImagesBytes.add(data.buffer.asUint8List());
                });
              }
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white),
            child: const Text('Recortar'),
          ),
        ],
      ),
    );
  }
}

class BannerPreviewWidget extends StatefulWidget {
  final List<Uint8List> imagesBytes;
  final String companyName;
  final String title;
  final String description;

  const BannerPreviewWidget({
    super.key,
    required this.imagesBytes,
    required this.companyName,
    required this.title,
    required this.description,
  });

  @override
  State<BannerPreviewWidget> createState() => _BannerPreviewWidgetState();
}

class _BannerPreviewWidgetState extends State<BannerPreviewWidget> {
  TextAlign _textAlign = TextAlign.left;
  CrossAxisAlignment _crossAlign = CrossAxisAlignment.start;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentImage = widget.imagesBytes.isNotEmpty && _currentImageIndex < widget.imagesBytes.length
        ? widget.imagesBytes[_currentImageIndex]
        : null;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 75,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            image: currentImage != null
                ? DecorationImage(
                    image: MemoryImage(currentImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
                  )
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              if (currentImage == null)
                const Center(
                  child: Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                ),
              Align(
                alignment: _textAlign == TextAlign.left 
                    ? Alignment.centerLeft 
                    : (_textAlign == TextAlign.right ? Alignment.centerRight : Alignment.center),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  color: Colors.white.withValues(alpha: 0.01),
                  width: MediaQuery.of(context).size.width - 40 - 16,
                    child: Column(
                      crossAxisAlignment: _crossAlign,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade700,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('AD', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.companyName.isEmpty ? 'Tu Empresa' : widget.companyName,
                                style: TextStyle(color: currentImage != null ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w600, fontSize: 10),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                textAlign: _textAlign,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.title.isEmpty ? 'Tu Título Aquí' : widget.title,
                          style: TextStyle(color: currentImage != null ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          textAlign: _textAlign,
                        ),
                        const SizedBox(height: 0),
                        Text(
                          widget.description.isEmpty ? 'Tu descripción aparecerá aquí...' : widget.description,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: currentImage != null ? Colors.white70 : Colors.grey.shade700, fontSize: 10),
                          textAlign: _textAlign,
                        ),
                      ],
                    ),
                  ),
                ),
              // Flechas para cambiar de imagen
              if (widget.imagesBytes.length > 1) ...[
                Positioned(
                  left: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentImageIndex = (_currentImageIndex - 1) % widget.imagesBytes.length;
                          if (_currentImageIndex < 0) _currentImageIndex += widget.imagesBytes.length;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentImageIndex = (_currentImageIndex + 1) % widget.imagesBytes.length;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Controles de alineación (fuera del banner)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() { _textAlign = TextAlign.left; _crossAlign = CrossAxisAlignment.start; }),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.format_align_left, size: 18, color: _textAlign == TextAlign.left ? Colors.black87 : Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() { _textAlign = TextAlign.center; _crossAlign = CrossAxisAlignment.center; }),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.format_align_center, size: 18, color: _textAlign == TextAlign.center ? Colors.black87 : Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() { _textAlign = TextAlign.right; _crossAlign = CrossAxisAlignment.end; }),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.format_align_right, size: 18, color: _textAlign == TextAlign.right ? Colors.black87 : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommaCapitalizationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    
    String text = newValue.text;
    String newText = '';
    
    for (int i = 0; i < text.length; i++) {
      if (i == 0) {
        newText += text[i].toUpperCase();
      } else if (i > 0 && text[i-1] == ',') {
        newText += text[i].toUpperCase();
      } else if (i > 1 && text[i-1] == ' ' && text[i-2] == ',') {
        newText += text[i].toUpperCase();
      } else {
        newText += text[i];
      }
    }
    
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
