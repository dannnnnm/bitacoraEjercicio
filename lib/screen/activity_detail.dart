import 'package:bitacora_ejercicios/model/activity.dart';
import 'package:flutter/material.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;

  const ActivityDetailScreen({Key? key, required this.activity})
    : super(key: key);

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.activity.completed;
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detalle de Actividad'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título y badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    activity.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Completada',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Horario
            _buildInfoRow(
              icon: Icons.access_time,
              iconColor: Colors.blue,
              title: 'Fecha',
              subtitle: activity.date.toLocal().toString(),
            ),
            const SizedBox(height: 20),

            // Clima
            _buildInfoRow(
              icon: Icons.wb_sunny,
              iconColor: Colors.orange,
              title: 'Clima',
              subtitle: activity.weather.toString(),
            ),
            const SizedBox(height: 24),

            // Descripción
            Text(
              'Descripción',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              activity.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(children: [Text("Categoria: "), Text(activity.category.name)]),
            const SizedBox(height: 32),

            // Botón marcar como completado
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isCompleted = !isCompleted;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isCompleted
                            ? 'Actividad marcada como completada'
                            : 'Actividad marcada como pendiente',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 24,
                ),
                label: Text(
                  isCompleted
                      ? 'Actividad completada'
                      : 'Marcar como realizada',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCompleted ? Colors.green[600] : Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            if (isCompleted) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isCompleted = false;
                    });
                  },
                  child: const Text('Desmarcar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
