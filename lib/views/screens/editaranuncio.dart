import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/services.dart';
import 'reservas.dart'; // <-- IMPORTANTE: Importamos esto para actualizar el carrusel global

class EditAdScreen extends StatefulWidget {
  final String currentTitle;
  final String currentCpc;
  final bool currentIsActive; 

  const EditAdScreen({
    super.key,
    required this.currentTitle,
    required this.currentCpc,
    required this.currentIsActive,
  });

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _pujarParaSerVisto = true;
  String _selectedObjetivo = 'Visitas a página web';

  final List<Uint8List> _bannerImagesBytes = [];

  late double _pujaAmount;
  late String _adTitle;
  late bool _isActive;

  // Datos pre-rellenados secundarios
  String _adDescription = "Descubre la nueva línea de cortes premium y productos de cuidado para el hombre.";
  String _adCompanyName = "Beard Style Barbershop";
  String _adDestino = "https://beardstyle.com/masters-edge";

  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _adTitle = widget.currentTitle;
    _pujaAmount = double.tryParse(widget.currentCpc.replaceAll('\$', '')) ?? 1.42;
    _isActive = widget.currentIsActive;
  }

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
            'Editar Anuncio',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Eliminar anuncio',
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
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
                        isPaused: !_isActive, 
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Expanded( // --- SOLUCIÓN DEL OVERFLOW ---
                child: Text('¿Eliminar anuncio?', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: const Text('Esta acción no se puede deshacer. Se borrarán todas las estadísticas y no se seguirá mostrando a los clientes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); 
                Navigator.pop(context, true); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Anuncio eliminado correctamente'), 
                    backgroundColor: Colors.red.shade600, 
                    behavior: SnackBarBehavior.floating
                  )
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopNav() {
    return Container(
      color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem(0, 'Info'), _buildNavDivider(), _buildStepItem(1, 'Creativo'), _buildNavDivider(), _buildStepItem(2, 'Presupuesto'), _buildNavDivider(), _buildStepItem(3, 'Pago'),
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
          width: 28, height: 28,
          decoration: BoxDecoration(color: isActive ? Colors.black87 : (isCompleted ? Colors.black87 : Colors.white), shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
          child: Center(child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : Text('${stepIndex + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 12))),
        ),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: color)),
      ],
    );
  }

  Widget _buildNavDivider() {
    return Expanded(child: Container(height: 2, margin: const EdgeInsets.only(bottom: 18, left: 4, right: 4), color: Colors.grey.shade300));
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildBasicInfoStep();
      case 1: return _buildCreativeStep();
      case 2: return _buildBudgetStep();
      case 3: return _buildPaymentStep();
      default: return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    String destinoLabel = _selectedObjetivo == 'Llamadas' ? 'Número de teléfono' : (_selectedObjetivo == 'Descargas de app' ? 'Enlace de la App' : 'Página de Destino (URL)');
    String destinoHint = _selectedObjetivo == 'Llamadas' ? 'Ej. 555-1234' : (_selectedObjetivo == 'Descargas de app' ? 'Inserta enlace' : 'https://...');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Información del Anuncio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Edita el título principal y el estado', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: SwitchListTile(
            title: const Text('Estado de la campaña', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(_isActive ? 'Activa (Pública)' : 'Pausada (Oculta)', style: TextStyle(color: _isActive ? Colors.green.shade700 : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            value: _isActive,
            onChanged: (bool value) => setState(() => _isActive = value),
            activeColor: Colors.green,
          ),
        ),
        const SizedBox(height: 20),

        _buildTextField('Título del Anuncio', 'Ej. Master\'s Edge Series', initialValue: _adTitle, textCapitalization: TextCapitalization.sentences, inputFormatters: [CommaCapitalizationFormatter()], onChanged: (val) => setState(() => _adTitle = val), validator: (val) => (val == null || val.isEmpty) ? 'El título es obligatorio' : null),
        const SizedBox(height: 16),
        _buildDropdown('Objetivo de la campaña', ['Visitas a página web', 'Llamadas', 'Descargas de app'], value: _selectedObjetivo, onChanged: (val) { if (val != null) setState(() => _selectedObjetivo = val); }),
        const SizedBox(height: 16),
        _buildTextField(destinoLabel, destinoHint, initialValue: _adDestino, isNumber: _selectedObjetivo == 'Llamadas', onChanged: (val) => _adDestino = val, validator: (val) => (val == null || val.isEmpty) ? 'Obligatorio' : null),
      ],
    );
  }

  Widget _buildCreativeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contenido Visual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 24),
        _buildTextField('Descripción del anuncio', 'Describe tu oferta...', initialValue: _adDescription, maxLines: 3, textCapitalization: TextCapitalization.sentences, inputFormatters: [CommaCapitalizationFormatter()], onChanged: (val) => setState(() => _adDescription = val.trim()), validator: (val) => (val == null || val.isEmpty) ? 'Obligatorio' : null),
        const SizedBox(height: 16),
        _buildTextField('Nombre de la Empresa', 'Ej. The Executive Grooming', initialValue: _adCompanyName, textCapitalization: TextCapitalization.words, onChanged: (val) => setState(() => _adCompanyName = val.isNotEmpty ? val : 'Tu Empresa'), validator: (val) => (val == null || val.isEmpty) ? 'Obligatorio' : null),
        const SizedBox(height: 16),
        _buildFilePicker('Cambiar Imagen o Logo', isImagePicker: true, onTap: () => _showPickerOptions()),
      ],
    );
  }

  Widget _buildBudgetStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Presupuesto y Puja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: Column(
            children: [
              SwitchListTile(title: const Text('Pujar para ser más visto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), value: _pujarParaSerVisto, onChanged: (bool value) => setState(() => _pujarParaSerVisto = value), activeTrackColor: Colors.black87, activeThumbColor: Colors.white),
              if (_pujarParaSerVisto)
                Padding(padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), child: _buildTextField('Tu Puja Máxima (€)', 'Ej. 1.50', initialValue: _pujaAmount.toString(), isNumber: true, onChanged: (val) => setState(() => _pujaAmount = double.tryParse(val.replaceAll(',', '.')) ?? 0.0))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField('Presupuesto Mensual (€)', 'Ej. 500', initialValue: '500', isNumber: true),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Datos de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Domiciliación Bancaria (SEPA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildTextField('Titular de la cuenta', 'Ej. Juan Pérez', initialValue: 'Beard Style S.L.'),
              const SizedBox(height: 12),
              _buildTextField('IBAN', 'ESXX XXXX XXXX XXXX XXXX XXXX', initialValue: 'ES91 2100 **** **** **** 4321'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {String? initialValue, int maxLines = 1, bool isNumber = false, ValueChanged<String>? onChanged, TextCapitalization textCapitalization = TextCapitalization.none, List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(initialValue: initialValue, onChanged: onChanged, maxLines: maxLines, keyboardType: isNumber ? TextInputType.number : TextInputType.text, textCapitalization: textCapitalization, inputFormatters: inputFormatters, validator: validator, autovalidateMode: AutovalidateMode.onUserInteraction, decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black87)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, {String? value, ValueChanged<String?>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(value: value ?? items.first, decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)), items: items.map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 14)))).toList(), onChanged: onChanged ?? (_) {}),
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
          onTap: onTap, borderRadius: BorderRadius.circular(12),
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: Column(children: [Icon(Icons.cloud_upload_outlined, color: Colors.grey[500], size: 32), const SizedBox(height: 8), Text(isImagePicker && _bannerImagesBytes.isNotEmpty ? 'Imagen actualizada. Toca para cambiar.' : 'Toca para subir nueva imagen', style: TextStyle(color: Colors.grey[600], fontSize: 14))])),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[50], border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(flex: 1, child: OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Colors.black87)), onPressed: () => setState(() => _currentStep -= 1), child: const Text('Atrás'))),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_currentStep < _totalSteps - 1) {
                        setState(() => _currentStep += 1);
                      } else {
                        // --- ACTUALIZAMOS LA VARIABLE GLOBAL DEL CARRUSEL ---
                        isCampaignActiveGlobal = _isActive;

                        Map<String, dynamic> nuevosDatos = {
                          'titulo': _adTitle,
                          'puja': _pujaAmount.toString(),
                          'activo': _isActive,
                        };
                        Navigator.pop(context, nuevosDatos);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados correctamente')));
                      }
                    }
                  },  
                  child: Text(_currentStep == _totalSteps - 1 ? 'Guardar Cambios' : 'Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(context: context, builder: (context) => SafeArea(child: Wrap(children: [ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galería'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }), ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Cámara'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); })])));
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker(); final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) { final bytes = await pickedFile.readAsBytes(); if (mounted) await _showCropDialog(bytes); }
  }

  Future<void> _showCropDialog(Uint8List imageBytes) async {
    final controller = CropController(aspectRatio: 300 / 50, defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9));
    await showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Ajustar Imagen'), content: SizedBox(width: double.maxFinite, height: 300, child: CropImage(controller: controller, image: Image.memory(imageBytes), paddingSize: 25.0, alwaysMove: true)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.black87))), ElevatedButton(onPressed: () async { final bitmap = await controller.croppedBitmap(); final data = await bitmap.toByteData(format: ui.ImageByteFormat.png); if (data != null) setState(() { _bannerImagesBytes.clear(); _bannerImagesBytes.add(data.buffer.asUint8List()); }); if (mounted) Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white), child: const Text('Recortar'))],
      ),
    );
  }
}

class BannerPreviewWidget extends StatefulWidget {
  final List<Uint8List> imagesBytes;
  final String companyName;
  final String title;
  final String description;
  final bool isPaused; 

  const BannerPreviewWidget({
    super.key, required this.imagesBytes, required this.companyName, required this.title, required this.description, this.isPaused = false,
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
    final currentImage = widget.imagesBytes.isNotEmpty && _currentImageIndex < widget.imagesBytes.length ? widget.imagesBytes[_currentImageIndex] : null;

    return Column(
      children: [
        Opacity(
          opacity: widget.isPaused ? 0.5 : 1.0, 
          child: Container(
            width: double.infinity, height: 75, margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16), image: currentImage != null ? DecorationImage(image: MemoryImage(currentImage), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken)) : null),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                if (currentImage == null) const Center(child: Icon(Icons.image_outlined, size: 48, color: Colors.grey)),
                Align(
                  alignment: _textAlign == TextAlign.left ? Alignment.centerLeft : (_textAlign == TextAlign.right ? Alignment.centerRight : Alignment.center),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0), color: Colors.white.withValues(alpha: 0.01), width: MediaQuery.of(context).size.width - 40 - 16,
                    child: Column(
                      crossAxisAlignment: _crossAlign, mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: widget.isPaused ? Colors.grey : Colors.amber.shade700, borderRadius: BorderRadius.circular(4)), child: const Text('AD', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1))),
                            const SizedBox(width: 8),
                            Flexible(child: Text(widget.companyName.isEmpty ? 'Tu Empresa' : widget.companyName, style: TextStyle(color: currentImage != null ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w600, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: _textAlign)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(widget.title.isEmpty ? 'Tu Título Aquí' : widget.title, style: TextStyle(color: currentImage != null ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: _textAlign),
                        const SizedBox(height: 0),
                        Text(widget.description.isEmpty ? 'Tu descripción aparecerá aquí...' : widget.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: currentImage != null ? Colors.white70 : Colors.grey.shade700, fontSize: 10), textAlign: _textAlign),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(onTap: () => setState(() { _textAlign = TextAlign.left; _crossAlign = CrossAxisAlignment.start; }), child: Padding(padding: const EdgeInsets.all(4.0), child: Icon(Icons.format_align_left, size: 18, color: _textAlign == TextAlign.left ? Colors.black87 : Colors.grey))), const SizedBox(width: 8),
              GestureDetector(onTap: () => setState(() { _textAlign = TextAlign.center; _crossAlign = CrossAxisAlignment.center; }), child: Padding(padding: const EdgeInsets.all(4.0), child: Icon(Icons.format_align_center, size: 18, color: _textAlign == TextAlign.center ? Colors.black87 : Colors.grey))), const SizedBox(width: 8),
              GestureDetector(onTap: () => setState(() { _textAlign = TextAlign.right; _crossAlign = CrossAxisAlignment.end; }), child: Padding(padding: const EdgeInsets.all(4.0), child: Icon(Icons.format_align_right, size: 18, color: _textAlign == TextAlign.right ? Colors.black87 : Colors.grey))),
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
    String text = newValue.text; String newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 0) newText += text[i].toUpperCase(); else if (i > 0 && text[i - 1] == ',') newText += text[i].toUpperCase(); else if (i > 1 && text[i - 1] == ' ' && text[i - 2] == ',') newText += text[i].toUpperCase(); else newText += text[i];
    }
    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}