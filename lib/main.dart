import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MiAppFinanzas());
}

// ── Modelo de categoría ──────────────────────────────────────────────────────
class Categoria {
  final String id;
  final String nombre;
  final String subtitulo;
  final String icono;
  final Color color;
  final Color colorFondo;
  double total;

  Categoria({
    required this.id,
    required this.nombre,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.colorFondo,
    this.total = 0.0,
  });
}

// ── Modelo de entrada de historial ──────────────────────────────────────────
class EntradaHistorial {
  final String categoriaId;
  final String categoriaNombre;
  final String categoriaIcono;
  final Color categoriaColor;
  final double monto;
  final DateTime fecha;
  final String periodo;

  EntradaHistorial({
    required this.categoriaId,
    required this.categoriaNombre,
    required this.categoriaIcono,
    required this.categoriaColor,
    required this.monto,
    required this.fecha,
    required this.periodo,
  });
}

// ── Paleta Dark Mode LED ─────────────────────────────────────────────────────
class AppColores {
  static const fondoBase       = Color(0xFF0D0D0F);
  static const fondoCard       = Color(0xFF16161A);
  static const fondoCardAlt    = Color(0xFF1C1C22);

  static const ledTeal         = Color(0xFF00FFB2);
  static const ledTealOscuro   = Color(0xFF00B87A);
  static const ledTealFondo    = Color(0xFF0A2620);

  static const ledAmber        = Color(0xFFFFBB00);
  static const ledAmberOscuro  = Color(0xFFCC9500);
  static const ledAmberFondo   = Color(0xFF261E00);

  static const ledAzul         = Color(0xFF00AAFF);
  static const ledAzulOscuro   = Color(0xFF0077CC);
  static const ledAzulFondo    = Color(0xFF00152A);

  static const ledVerde        = Color(0xFF44FF88);
  static const ledVerdeOscuro  = Color(0xFF22BB55);
  static const ledVerdeFondo   = Color(0xFF072210);

  static const ledPurpura      = Color(0xFFAA77FF);
  static const ledPurpuraOscuro= Color(0xFF7744CC);
  static const ledPurpuraFondo = Color(0xFF130A22);

  static const ledRosa         = Color(0xFFFF44AA);
  static const ledRosaOscuro   = Color(0xFFCC1177);
  static const ledRosaFondo    = Color(0xFF220011);

  static const ledGris         = Color(0xFF88AACC);
  static const ledGrisOscuro   = Color(0xFF556688);
  static const ledGrisFondo    = Color(0xFF101520);

  static const ledRojo         = Color(0xFFFF4444);
  static const ledRojoOscuro   = Color(0xFFCC2222);
  static const ledRojoFondo    = Color(0xFF220000);

  static const textoBlanco     = Color(0xFFE8E8F0);
  static const textoGris       = Color(0xFF888899);
}

// ── App Root ─────────────────────────────────────────────────────────────────
class MiAppFinanzas extends StatelessWidget {
  const MiAppFinanzas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Finanzas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColores.fondoBase,
        colorScheme: const ColorScheme.dark(
          primary: AppColores.ledTeal,
          surface: AppColores.fondoCard,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PantallaFinanzas(),
    );
  }
}

// ── Modelo de datos del consejo ──────────────────────────────────────────────
class _TipData {
  final IconData icono;
  final Color color;
  final Color fondo;
  final String mensaje;

  const _TipData({
    required this.icono,
    required this.color,
    required this.fondo,
    required this.mensaje,
  });
}

// ── Enum de periodo ──────────────────────────────────────────────────────────
enum Periodo { semanal, quincenal, mensual }

extension PeriodoExt on Periodo {
  String get etiqueta {
    switch (this) {
      case Periodo.semanal:   return 'Semanal';
      case Periodo.quincenal: return 'Quincenal';
      case Periodo.mensual:   return 'Mensual';
    }
  }

  String get abreviacion {
    switch (this) {
      case Periodo.semanal:   return '7d';
      case Periodo.quincenal: return '15d';
      case Periodo.mensual:   return '30d';
    }
  }
}

// ── Pantalla principal ────────────────────────────────────────────────────────
class PantallaFinanzas extends StatefulWidget {
  const PantallaFinanzas({super.key});

  @override
  State<PantallaFinanzas> createState() => _PantallaFinanzasState();
}

class _PantallaFinanzasState extends State<PantallaFinanzas>
    with TickerProviderStateMixin {
  double _ingresos = 0.0;
  final _controladorIngresos = TextEditingController();
  Periodo _periodo = Periodo.quincenal;

  final List<EntradaHistorial> _historial = [];

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  final List<Categoria> _categorias = [
    Categoria(
      id: 'comida',
      nombre: 'Comida',
      subtitulo: 'Antojo, lunch, cena',
      icono: '🍔',
      color: AppColores.ledAmber,
      colorFondo: AppColores.ledAmberFondo,
    ),
    Categoria(
      id: 'transporte',
      nombre: 'Transporte',
      subtitulo: 'Camión, Uber, gasolina',
      icono: '🚗',
      color: AppColores.ledAzul,
      colorFondo: AppColores.ledAzulFondo,
    ),
    Categoria(
      id: 'escuela',
      nombre: 'Escuela',
      subtitulo: 'Copias, materiales',
      icono: '📚',
      color: AppColores.ledVerde,
      colorFondo: AppColores.ledVerdeFondo,
    ),
    Categoria(
      id: 'ocio',
      nombre: 'Ocio',
      subtitulo: 'Cine, salidas, apps',
      icono: '🍿',
      color: AppColores.ledPurpura,
      colorFondo: AppColores.ledPurpuraFondo,
    ),
    Categoria(
      id: 'salud',
      nombre: 'Salud',
      subtitulo: 'Médico, farmacia',
      icono: '❤️',
      color: AppColores.ledRosa,
      colorFondo: AppColores.ledRosaFondo,
    ),
    Categoria(
      id: 'otro',
      nombre: 'Otro',
      subtitulo: 'Ropa, regalos, etc.',
      icono: '🎁',
      color: AppColores.ledGris,
      colorFondo: AppColores.ledGrisFondo,
    ),
  ];

  double get _totalGastado =>
      _categorias.fold(0.0, (sum, c) => sum + c.total);
  double get _saldoDisponible => _ingresos - _totalGastado;
  double get _porcentajeGastado =>
      _ingresos > 0 ? (_totalGastado / _ingresos).clamp(0.0, 1.0) : 0.0;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.18)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.18, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 35,
      ),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    _controladorIngresos.dispose();
    super.dispose();
  }

  void _dispararBounce() => _bounceCtrl.forward(from: 0);
  void _feedbackPositivo() => HapticFeedback.lightImpact();
  void _feedbackAlerta()   => HapticFeedback.heavyImpact();

  void _actualizarIngresos(String val) {
    setState(() => _ingresos = double.tryParse(val) ?? 0.0);
    _dispararBounce();
  }

  // ── Dialog para ingresar gasto ────────────────────────────────────────────
  void _mostrarDialogGasto(Categoria cat) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColores.fondoCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cat.color.withOpacity(0.7), width: 1.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cat.color.withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cat.colorFondo,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20)),
                  border: Border(
                      bottom:
                          BorderSide(color: cat.color.withOpacity(0.3))),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: cat.color.withOpacity(0.6), width: 1.2),
                      ),
                      child: Text(cat.icono,
                          style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat.nombre,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cat.color)),
                        Text(cat.subtitulo,
                            style: TextStyle(
                                fontSize: 12,
                                color: cat.color.withOpacity(0.6))),
                      ],
                    ),
                  ],
                ),
              ),
              // Contenido
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: ctrl,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: const TextStyle(
                          color: AppColores.textoBlanco, fontSize: 16),
                      cursorColor: AppColores.ledTeal,
                      decoration: InputDecoration(
                        labelText: 'Cantidad gastada (MXN)',
                        labelStyle:
                            TextStyle(color: cat.color.withOpacity(0.7)),
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                            color: cat.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        filled: true,
                        fillColor: cat.colorFondo,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: cat.color.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: cat.color, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _confirmarGasto(cat, ctrl),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColores.textoGris,
                              side: BorderSide(
                                  color: AppColores.textoGris
                                      .withOpacity(0.4)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _confirmarGasto(cat, ctrl),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  cat.color.withOpacity(0.15),
                              foregroundColor: cat.color,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: cat.color, width: 1.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                            ),
                            child: const Text('Agregar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarGasto(Categoria cat, TextEditingController ctrl) {
    final valor = double.tryParse(ctrl.text);
    if (valor == null || valor <= 0) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context);
    setState(() {
      cat.total += valor;
      _historial.insert(
        0,
        EntradaHistorial(
          categoriaId: cat.id,
          categoriaNombre: cat.nombre,
          categoriaIcono: cat.icono,
          categoriaColor: cat.color,
          monto: valor,
          fecha: DateTime.now(),
          periodo: _periodo.etiqueta,
        ),
      );
    });
    _dispararBounce();
    if (_saldoDisponible < 0) {
      _feedbackAlerta();
    } else {
      _feedbackPositivo();
    }
  }

  void _resetearTodo() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColores.fondoCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: AppColores.ledRojo.withOpacity(0.6), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColores.ledRojo, size: 40),
              const SizedBox(height: 12),
              const Text('Reiniciar todo',
                  style: TextStyle(
                      color: AppColores.textoBlanco,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                '¿Seguro que quieres borrar todos los gastos registrados?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColores.textoGris, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColores.textoGris,
                        side: BorderSide(
                            color:
                                AppColores.textoGris.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          for (final c in _categorias) {
                            c.total = 0.0;
                          }
                          _historial.clear();
                          _ingresos = 0.0;
                          _controladorIngresos.clear();
                        });
                        _dispararBounce();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColores.ledRojoFondo,
                        foregroundColor: AppColores.ledRojo,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: AppColores.ledRojo, width: 1.5),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text('Reiniciar',
                          style:
                              TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom sheet de historial ─────────────────────────────────────────────
  void _mostrarHistorial() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.35,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: AppColores.fondoCard,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
                color: AppColores.ledPurpura.withOpacity(0.4), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColores.ledPurpura.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColores.textoGris.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Cabecera
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColores.ledPurpuraFondo,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                AppColores.ledPurpura.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.history_rounded,
                          color: AppColores.ledPurpura, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Historial de gastos',
                            style: TextStyle(
                                color: AppColores.textoBlanco,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Text(
                          '${_historial.length} movimiento${_historial.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                              color: AppColores.textoGris, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (_historial.isNotEmpty)
                      Text(
                        'Total: \$${_historial.fold(0.0, (s, e) => s + e.monto).toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: AppColores.ledPurpura,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
              ),
              // Línea divisora LED
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    AppColores.ledPurpura.withOpacity(0.6),
                    Colors.transparent,
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              // Lista
              Expanded(
                child: _historial.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_rounded,
                                color: AppColores.textoGris
                                    .withOpacity(0.3),
                                size: 48),
                            const SizedBox(height: 12),
                            const Text('Sin movimientos aún',
                                style: TextStyle(
                                    color: AppColores.textoGris,
                                    fontSize: 14)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        itemCount: _historial.length,
                        itemBuilder: (_, i) {
                          final e = _historial[i];
                          final hora =
                              '${e.fecha.hour.toString().padLeft(2, '0')}:${e.fecha.minute.toString().padLeft(2, '0')}';
                          final dia =
                              '${e.fecha.day}/${e.fecha.month}/${e.fecha.year}';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: e.categoriaColor.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: e.categoriaColor
                                      .withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: e.categoriaColor
                                        .withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(9),
                                    border: Border.all(
                                        color: e.categoriaColor
                                            .withOpacity(0.4)),
                                  ),
                                  child: Text(e.categoriaIcono,
                                      style: const TextStyle(fontSize: 17)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(e.categoriaNombre,
                                          style: const TextStyle(
                                              color:
                                                  AppColores.textoBlanco,
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight.w600)),
                                      Text(
                                        '$dia  $hora  •  ${e.periodo}',
                                        style: const TextStyle(
                                            color: AppColores.textoGris,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '-\$${e.monto.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: e.categoriaColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                          color: e.categoriaColor
                                              .withOpacity(0.7),
                                          blurRadius: 8),
                                    ],
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
        ),
      ),
    );
  }

  // ── Tip dinámico según saldo ──────────────────────────────────────────────
  _TipData _calcularTip() {
    if (_ingresos == 0) {
      return const _TipData(
        icono: Icons.lightbulb_rounded,
        color: AppColores.ledTeal,
        fondo: AppColores.ledTealFondo,
        mensaje:
            'Ingresa tu dinero disponible y empieza a registrar tus gastos.',
      );
    }
    if (_saldoDisponible < 0) {
      final exceso = (-_saldoDisponible).toStringAsFixed(2);
      return _TipData(
        icono: Icons.warning_rounded,
        color: AppColores.ledRojo,
        fondo: AppColores.ledRojoFondo,
        mensaje:
            '¡Alerta! Te sobregiaste \$$exceso. Deja de gastar en ocio y revisa qué categoría puedes recortar esta semana.',
      );
    }
    if (_porcentajeGastado > 0.8) {
      return _TipData(
        icono: Icons.warning_amber_rounded,
        color: AppColores.ledAmber,
        fondo: AppColores.ledAmberFondo,
        mensaje:
            'Ya usaste el ${(_porcentajeGastado * 100).round()}% de tu dinero. Queda poco – prioriza solo lo esencial.',
      );
    }
    if (_porcentajeGastado > 0.5) {
      final guardar = (_saldoDisponible * 0.1).toStringAsFixed(0);
      return _TipData(
        icono: Icons.savings_rounded,
        color: AppColores.ledAmber,
        fondo: AppColores.ledAmberFondo,
        mensaje:
            'Vas a la mitad del presupuesto. Considera apartar \$$guardar para imprevistos antes de más gastos.',
      );
    }
    return const _TipData(
      icono: Icons.check_circle_rounded,
      color: AppColores.ledTeal,
      fondo: AppColores.ledTealFondo,
      mensaje:
          '¡Buen control! Tus finanzas están estables y dentro del límite establecido.',
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final tip = _calcularTip();
    final categoriasConGasto =
        _categorias.where((c) => c.total > 0).toList();

    return Scaffold(
      backgroundColor: AppColores.fondoBase,
      appBar: AppBar(
        backgroundColor: AppColores.fondoCard,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColores.ledTeal,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Símbolo $ estilizado en lugar de ícono
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColores.ledTealFondo,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColores.ledTeal.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                      color: AppColores.ledTeal.withOpacity(0.25),
                      blurRadius: 8),
                ],
              ),
              child: const Text(
                '\$',
                style: TextStyle(
                  color: AppColores.ledTeal,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColores.ledTeal, AppColores.ledAzul],
              ).createShader(bounds),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis Finanzas',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 0.5),
                  ),
                  Text(
                    'Por Marcela',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.menu_rounded, color: AppColores.textoGris),
                if (_historial.isNotEmpty)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColores.ledPurpura,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppColores.ledPurpura.withOpacity(0.8),
                              blurRadius: 5),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            color: AppColores.fondoCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                  color: AppColores.ledTeal.withOpacity(0.25), width: 1),
            ),
            elevation: 8,
            onSelected: (value) {
              if (value == 'historial') _mostrarHistorial();
              if (value == 'reiniciar') _resetearTodo();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'historial',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColores.ledPurpuraFondo,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColores.ledPurpura.withOpacity(0.4)),
                      ),
                      child: const Icon(Icons.history_rounded,
                          color: AppColores.ledPurpura, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Historial',
                            style: TextStyle(
                                color: AppColores.textoBlanco,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        Text(
                          '${_historial.length} movimiento${_historial.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                              color: AppColores.textoGris, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuDivider(
                height: 1,
              ),
              PopupMenuItem(
                value: 'reiniciar',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColores.ledRojoFondo,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColores.ledRojo.withOpacity(0.4)),
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: AppColores.ledRojo, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Text('Reiniciar',
                        style: TextStyle(
                            color: AppColores.ledRojo,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tarjeta de saldo ─────────────────────────────────────
              _SaldoCardAnimada(
                saldoDisponible: _saldoDisponible,
                ingresos: _ingresos,
                totalGastado: _totalGastado,
                porcentaje: _porcentajeGastado,
                bounceAnim: _bounceAnim,
                periodo: _periodo,
              ),
              const SizedBox(height: 14),

              // ── Campo de ingresos + selector de periodo ───────────────
              _LedCard(
                ledColor: AppColores.ledTeal,
                child: Column(
                  children: [
                    TextField(
                      controller: _controladorIngresos,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: _actualizarIngresos,
                      style: const TextStyle(
                          color: AppColores.textoBlanco, fontSize: 15),
                      cursorColor: AppColores.ledTeal,
                      decoration: InputDecoration(
                        labelText: 'Ingreso disponible (MXN)',
                        labelStyle: const TextStyle(
                            color: AppColores.textoGris, fontSize: 13),
                        hintText: 'Ej: 1500.00',
                        hintStyle: TextStyle(
                            color:
                                AppColores.textoGris.withOpacity(0.5)),
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(10),
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColores.ledTealFondo,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    AppColores.ledTeal.withOpacity(0.5)),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      AppColores.ledTeal.withOpacity(0.3),
                                  blurRadius: 8),
                            ],
                          ),
                          child: const Text(
                            '\$',
                            style: TextStyle(
                              color: AppColores.ledTeal,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        prefixText: '\$ ',
                        prefixStyle: const TextStyle(
                            color: AppColores.ledTeal,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // ── Selector de periodo ───────────────────────────
                    Row(
                      children: [
                        const Text('⏱',
                        style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        const Text('Periodo:',
                            style: TextStyle(
                                color: AppColores.textoGris,
                                fontSize: 12)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: Periodo.values.map((p) {
                              final sel = _periodo == p;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _periodo = p);
                                    HapticFeedback.selectionClick();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7),
                                    decoration: BoxDecoration(
                                      color: sel
                                          ? AppColores.ledTeal
                                              .withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      border: Border.all(
                                        color: sel
                                            ? AppColores.ledTeal
                                            : AppColores.textoGris
                                                .withOpacity(0.2),
                                        width: sel ? 1.5 : 1.0,
                                      ),
                                      boxShadow: sel
                                          ? [
                                              BoxShadow(
                                                  color: AppColores
                                                      .ledTeal
                                                      .withOpacity(0.25),
                                                  blurRadius: 8),
                                            ]
                                          : [],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          p.abreviacion,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            color: sel
                                                ? AppColores.ledTeal
                                                : AppColores.textoGris,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          p.etiqueta,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: sel
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                            color: sel
                                                ? AppColores.ledTeal
                                                : AppColores.textoGris,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Título categorías ─────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColores.ledTeal,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                            color: AppColores.ledTeal.withOpacity(0.7),
                            blurRadius: 6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('REGISTRAR GASTO',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColores.textoGris,
                          letterSpacing: 1.2)),
                ],
              ),
              const SizedBox(height: 10),

              // ── Grid de categorías ────────────────────────────────────
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.55,
                children: _categorias
                    .map((cat) => _CategoriaBoton(
                          categoria: cat,
                          onTap: () => _mostrarDialogGasto(cat),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // ── Barras de desglose ────────────────────────────────────
              if (categoriasConGasto.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColores.ledPurpura,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  AppColores.ledPurpura.withOpacity(0.7),
                              blurRadius: 6),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('DESGLOSE DE GASTOS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColores.textoGris,
                            letterSpacing: 1.2)),
                  ],
                ),
                const SizedBox(height: 10),
                _LedCard(
                  ledColor: AppColores.ledPurpura,
                  child: Column(
                    children: categoriasConGasto
                        .map((cat) => _BarraCategoria(
                              categoria: cat,
                              ingresos: _ingresos,
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // ── Consejo dinámico ──────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tip.fondo,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: tip.color.withOpacity(0.5), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                        color: tip.color.withOpacity(0.2),
                        blurRadius: 16,
                        spreadRadius: 2),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: tip.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(tip.icono, color: tip.color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip.mensaje,
                        style: TextStyle(
                            fontSize: 13,
                            color: tip.color,
                            height: 1.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget auxiliar: tarjeta con borde LED ────────────────────────────────────
class _LedCard extends StatelessWidget {
  final Color ledColor;
  final Widget child;

  const _LedCard({required this.ledColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColores.fondoCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: ledColor.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: ledColor.withOpacity(0.18),
              blurRadius: 18,
              spreadRadius: 2),
        ],
      ),
      child: child,
    );
  }
}

// ── Widget: Tarjeta de saldo con bounce ───────────────────────────────────────
class _SaldoCardAnimada extends StatelessWidget {
  final double saldoDisponible;
  final double ingresos;
  final double totalGastado;
  final double porcentaje;
  final Animation<double> bounceAnim;
  final Periodo periodo;

  const _SaldoCardAnimada({
    required this.saldoDisponible,
    required this.ingresos,
    required this.totalGastado,
    required this.porcentaje,
    required this.bounceAnim,
    required this.periodo,
  });

  Color get _colorLed {
    if (saldoDisponible < 0) return AppColores.ledRojo;
    if (porcentaje > 0.8) return AppColores.ledAmber;
    return AppColores.ledTeal;
  }

  Color get _colorFondo {
    if (saldoDisponible < 0) return AppColores.ledRojoFondo;
    if (porcentaje > 0.8) return AppColores.ledAmberFondo;
    return AppColores.ledTealFondo;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _colorFondo,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: _colorLed.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: _colorLed.withOpacity(0.3),
              blurRadius: 24,
              spreadRadius: 4),
        ],
      ),
      child: Column(
        children: [
          // Título + badge de periodo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SALDO DISPONIBLE',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _colorLed.withOpacity(0.7),
                    letterSpacing: 1.5),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _colorLed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: _colorLed.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      periodo.abreviacion,
                      style: TextStyle(
                          fontSize: 9,
                          color: _colorLed,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      periodo.etiqueta,
                      style: TextStyle(
                          fontSize: 9,
                          color: _colorLed,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Número con bounce
          AnimatedBuilder(
            animation: bounceAnim,
            builder: (_, child) =>
                Transform.scale(scale: bounceAnim.value, child: child),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: _colorLed,
                shadows: [
                  Shadow(
                      color: _colorLed.withOpacity(0.8), blurRadius: 20),
                  Shadow(
                      color: _colorLed.withOpacity(0.4), blurRadius: 40),
                ],
              ),
              child: Text('\$${saldoDisponible.toStringAsFixed(2)}'),
            ),
          ),
          if (ingresos > 0) ...[
            const SizedBox(height: 14),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _colorLed.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  widthFactor: porcentaje.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: _colorLed,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: _colorLed.withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gastado: \$${totalGastado.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 12,
                        color: _colorLed.withOpacity(0.7))),
                Text('Total: \$${ingresos.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 12,
                        color: _colorLed.withOpacity(0.7))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Widget: Botón de categoría con glow LED ───────────────────────────────────
class _CategoriaBoton extends StatefulWidget {
  final Categoria categoria;
  final VoidCallback onTap;

  const _CategoriaBoton(
      {required this.categoria, required this.onTap});

  @override
  State<_CategoriaBoton> createState() => _CategoriaBotonState();
}

class _CategoriaBotonState extends State<_CategoriaBoton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.categoria;
    final tieneGasto = cat.total > 0;

    return GestureDetector(
      onTapDown: (_) {
        _ctrl.forward();
        setState(() => _hover = true);
      },
      onTapUp: (_) {
        _ctrl.reverse();
        setState(() => _hover = false);
        widget.onTap();
      },
      onTapCancel: () {
        _ctrl.reverse();
        setState(() => _hover = false);
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: tieneGasto ? cat.colorFondo : AppColores.fondoCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: tieneGasto || _hover
                  ? cat.color.withOpacity(0.7)
                  : AppColores.textoGris.withOpacity(0.15),
              width: tieneGasto ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: tieneGasto
                    ? cat.color.withOpacity(0.35)
                    : (_hover
                        ? cat.color.withOpacity(0.2)
                        : Colors.transparent),
                blurRadius: tieneGasto ? 16 : 10,
                spreadRadius: tieneGasto ? 2 : 0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: cat.color
                          .withOpacity(tieneGasto ? 0.7 : 0.3),
                      width: 1),
                  boxShadow: tieneGasto
                      ? [
                          BoxShadow(
                              color: cat.color.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1),
                        ]
                      : [],
                ),
                child: Text(cat.icono, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat.nombre,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColores.textoBlanco),
                      overflow: TextOverflow.ellipsis,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: tieneGasto
                          ? Text(
                              '\$${cat.total.toStringAsFixed(0)}',
                              key: ValueKey(cat.total),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: cat.color,
                                shadows: [
                                  Shadow(
                                      color:
                                          cat.color.withOpacity(0.8),
                                      blurRadius: 8),
                                ],
                              ),
                            )
                          : Text(
                              cat.subtitulo,
                              key: const ValueKey('subtitulo'),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColores.textoGris),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget: Barra de categoría en desglose ────────────────────────────────────
class _BarraCategoria extends StatelessWidget {
  final Categoria categoria;
  final double ingresos;

  const _BarraCategoria(
      {required this.categoria, required this.ingresos});

  @override
  Widget build(BuildContext context) {
    final pct = ingresos > 0
        ? (categoria.total / ingresos).clamp(0.0, 1.0)
        : 1.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Emoji de categoría en el desglose
          Text(categoria.icono,
              style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          SizedBox(
            width: 60,
            child: Text(
              categoria.nombre,
              style: const TextStyle(
                  fontSize: 12, color: AppColores.textoGris),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: categoria.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 400),
                  widthFactor: pct,
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: categoria.color,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                            color: categoria.color.withOpacity(0.7),
                            blurRadius: 6,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 54,
            child: Text(
              '\$${categoria.total.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: categoria.color,
                shadows: [
                  Shadow(
                      color: categoria.color.withOpacity(0.6),
                      blurRadius: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}