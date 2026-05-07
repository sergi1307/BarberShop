import 'package:flutter/material.dart';

import 'seleccionar_hora.dart';

class SelectDateScreen extends StatefulWidget {
  const SelectDateScreen({super.key});

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime now = DateTime.now();
  late DateTime currentMonth;
  DateTime? selectedDate;

  final List<String> monthNames = [
    'ENERO',
    'FEBRERO',
    'MARZO',
    'ABRIL',
    'MAYO',
    'JUNIO',
    'JULIO',
    'AGOSTO',
    'SEPTIEMBRE',
    'OCTUBRE',
    'NOVIEMBRE',
    'DICIEMBRE',
  ];

  @override
  void initState() {
    super.initState();
    // Empezamos mostrando el mes actual
    currentMonth = DateTime(now.year, now.month, 1);
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    });
  }

  void _prevMonth() {
    // Evitamos retroceder a meses anteriores al actual
    if (currentMonth.year == now.year && currentMonth.month == now.month)
      return;
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.cut, color: Colors.amber, size: 16),
          ),
        ),
        title: const Text(
          'Beard Style Barbershop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // --- CABECERA DE TEXTOS ---
          const Text(
            'DÍA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Selecciona el día disponible',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4A8E9F),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),

          // --- TARJETA DEL CALENDARIO ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cabecera del mes y flechas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 28),
                        color:
                            (currentMonth.year == now.year &&
                                currentMonth.month == now.month)
                            ? Colors.grey[300]
                            : Colors.black87,
                        onPressed: _prevMonth,
                      ),
                      Text(
                        '${monthNames[currentMonth.month - 1]} ${currentMonth.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: Color(0xFF4A8E9F),
                          letterSpacing: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 28),
                        color: Colors.black87,
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Días de la semana (L M X J V S D)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) {
                      return SizedBox(
                        width: 30,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xFF333333),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Cuadrícula de días
                  _buildCalendarGrid(),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- BARRA INFERIOR DE NAVEGACIÓN ---
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'VOLVER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Indicadores (Ahora el CUARTO punto está activo)
              Row(
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), // ¡Paso 4 activo!
                  _buildDot(isActive: false),
                ],
              ),

              GestureDetector(
                onTap: selectedDate != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectTimeScreen(),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: selectedDate != null ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LÓGICA DEL CALENDARIO ---
  Widget _buildCalendarGrid() {
    int daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    int firstWeekday = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    ).weekday; // 1=Lunes, 7=Domingo

    DateTime prevMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    int daysInPrevMonth = DateUtils.getDaysInMonth(
      prevMonth.year,
      prevMonth.month,
    );

    List<Widget> dayWidgets = [];

    // Rellenamos los días del mes anterior (en gris claro)
    for (int i = 1; i < firstWeekday; i++) {
      int prevDay = daysInPrevMonth - firstWeekday + i + 1;
      dayWidgets.add(
        _buildDayCell(prevDay.toString(), Colors.grey[300]!, false, false),
      );
    }

    // Rellenamos los días del mes actual
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime dayDate = DateTime(currentMonth.year, currentMonth.month, i);

      // Comprobamos si el día es anterior a hoy (eliminando la parte de la hora para ser exactos)
      DateTime today = DateTime(now.year, now.month, now.day);
      bool isPast = dayDate.isBefore(today);

      bool isSelected =
          selectedDate != null &&
          dayDate.year == selectedDate!.year &&
          dayDate.month == selectedDate!.month &&
          dayDate.day == selectedDate!.day;

      bool isSunday = dayDate.weekday == 7;

      // Colores basados en tu diseño
      Color textColor;
      if (isSelected) {
        textColor = Colors.white;
      } else if (isPast) {
        textColor = Colors.grey[300]!; // Pasados en gris
      } else if (isSunday) {
        textColor = Colors.black87; // Domingos en negro
      } else {
        textColor = const Color(0xFF1E88E5); // Días normales en azul
      }

      dayWidgets.add(
        GestureDetector(
          onTap: isPast
              ? null
              : () {
                  setState(() {
                    selectedDate = dayDate;
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2D2D2D)
                  : Colors.transparent, // Fondo oscuro si se selecciona
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$i',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Rellenamos los huecos restantes con los primeros días del mes siguiente para completar la cuadrícula
    int remainingCells = 42 - dayWidgets.length; // 42 = 6 filas de 7 días
    for (int i = 1; i <= remainingCells; i++) {
      dayWidgets.add(
        _buildDayCell(i.toString(), Colors.grey[300]!, false, false),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: dayWidgets,
    );
  }

  // Widget auxiliar para celdas inactivas (mes anterior/siguiente)
  Widget _buildDayCell(
    String text,
    Color color,
    bool isSelected,
    bool isSelectable,
  ) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
