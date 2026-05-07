import 'package:flutter/material.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  int _currentStep = 0;
  bool _pujarParaSerVisto = true;
  double _pujaAmount = 0.0;
  
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
        body: Column(
          children: [
            _buildTopNav(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: _buildCurrentStepContent(),
              ),
            ),
            _buildBottomControls(),
          ],
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
          _buildStepItem(1, 'Audiencia'),
          _buildNavDivider(),
          _buildStepItem(2, 'Creativo'),
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
        return _buildAudienceStep();
      case 2:
        return _buildCreativeStep();
      case 3:
        return _buildPaymentStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Información Básica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Datos principales de tu negocio', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        _buildTextField('Nombre de la Empresa', 'Ej. The Executive Grooming'),
        const SizedBox(height: 16),
        _buildTextField('Web / Teléfono / App', 'Ej. www.barber.com o 555-1234'),
        const SizedBox(height: 16),
        _buildDropdown('Objetivo', ['Visitas al local', 'Compras en web', 'Descargas de app', 'Reconocimiento de marca']),
        const SizedBox(height: 16),
        _buildTextField('Página de Destino (URL)', 'https://...'),
      ],
    );
  }

  Widget _buildAudienceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Audiencia y Alcance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('A quién va dirigido el anuncio', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        _buildTextField('Temas de Búsqueda', 'Ej. corte de pelo, barbería premium...'),
        const SizedBox(height: 16),
        _buildTextField('Ubicación e Idioma', 'Ej. Madrid, Español'),
        const SizedBox(height: 16),
        _buildTextField('Detalles', '¿Qué haces y qué te hace único?', maxLines: 4),
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
        _buildTextField('Diferentes Títulos', 'Ej. Título 1, Título 2... (Separados por coma)', maxLines: 2),
        const SizedBox(height: 16),
        _buildTextField('Diferentes Descripciones', 'Ej. Desc 1, Desc 2... (Separados por coma)', maxLines: 3),
        const SizedBox(height: 16),
        _buildFilePicker('Subir Imágenes y Logos'),
        const SizedBox(height: 16),
        _buildFilePicker('Subir Vídeos'),
        const SizedBox(height: 16),
        _buildDropdown('Preferencias de Formato', ['Optimizar para texto', 'Optimizar para vídeo', 'Equilibrado']),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Presupuesto y Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        const Text('Detalles de facturación y puja', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        _buildTextField('Enlaces al Sitio', 'Ej. Ofertas, Reservas...'),
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
                      _buildTextField('Tu Puja Máxima (€)', 'Ej. 1.50', isNumber: true, onChanged: (val) {
                        setState(() {
                          _pujaAmount = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
                        });
                      }),
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
        _buildTextField('Presupuesto Mensual (€)', 'Ej. 500', isNumber: true),
        const SizedBox(height: 24),
        
        const Text('Datos de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildTextField('Titular de la tarjeta', 'Ej. Juan Pérez'),
        const SizedBox(height: 12),
        _buildTextField('Número de tarjeta', 'XXXX XXXX XXXX XXXX', isNumber: true),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField('Caducidad', 'MM/AA')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('CVV', '123', isNumber: true)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1, bool isNumber = false, ValueChanged<String>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
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
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (_) {},
          hint: Text(items.first, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
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
              Text('Toca para subir archivos', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
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
                if (_currentStep < _totalSteps - 1) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  Navigator.pop(context);
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
}
