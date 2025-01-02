import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/dashboard.provider.dart';
import 'package:puntocell_flutter/util/global_keys.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardProvider watch = context.watch<DashboardProvider>();
    return watch.isLoading?const Center(child: CircularProgressIndicator(),) : Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    if(Platform.isAndroid)
                    Builder(builder: (context) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      );
                    }),
                    if(!Platform.isAndroid)
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xFF666666)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MenuAnchor(
                            alignmentOffset:
                                MediaQuery.of(context).size.width > 750
                                    ? const Offset(15, 5)
                                    : Offset.zero,
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () {
                                  debugPrint('Opción 1 seleccionada');
                                },
                                child: const Text('Reporte de ventas'),
                              ),
                              const Divider(),
                              MenuItemButton(
                                onPressed: () {
                                  debugPrint('Inventario');
                                },
                                child: const Text('Inventario'),
                              ),
                            ],
                            builder: (BuildContext context,
                                MenuController controller, Widget? child) {
                              return ElevatedButton(
                                  onPressed: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/excel.svg',
                                        width: 20,
                                      ),
                                      if (MediaQuery.of(context).size.width >
                                          750)
                                        const Text(
                                          ' Generar Excel',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                    ],
                                  ));
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MenuAnchor(
                            alignmentOffset:
                                MediaQuery.of(context).size.width > 750
                                    ? const Offset(15, 5)
                                    : Offset.zero,
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () {
                                  debugPrint('Opción 1 seleccionada');
                                },
                                child: const Text('Reporte general'),
                              ),
                              const Divider(),
                              MenuItemButton(
                                onPressed: () {
                                  debugPrint('Inventario');
                                },
                                child: const Text('Catálogo'),
                              ),
                            ],
                            builder: (BuildContext context,
                                MenuController controller, Widget? child) {
                              return ElevatedButton(
                                  onPressed: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/pdf.svg',
                                        width: 20,
                                      ),
                                      if (MediaQuery.of(context).size.width >
                                          750)
                                        const Text(
                                          ' Generar PDf',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 237, 94, 94),
                                              fontWeight: FontWeight.bold),
                                        )
                                    ],
                                  ));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                LayoutBuilder(builder: (context, constraint) {
                  int crossAxisCount = (constraint.maxWidth < 620) ? 2 : 4;
                  double space = (constraint.maxWidth < 620) ? 32 : 16;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: constraint.maxWidth,
                      child: GridView.count(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: space,
                        crossAxisSpacing: space,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1,
                        children: [
                          CustomCard(
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.phone_android,
                                          color: Color(0xFF039443),
                                          size: 40,
                                        ),
                                        const Text(
                                          'Disponibles',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF039443)),
                                        ),
                                        Text(
                                          '${watch.disponibles} unidades',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color: Color(0xFF039443)),
                                        ),
                                      ],
                                    ),
                                  ))),
                          CustomCard(
                              child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/record.svg',
                                  width: 40,
                                  // ignore: deprecated_member_use
                                  color: const Color(0xFF039443),
                                ),
                                const Text(
                                  'Récord de ventas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF039443)),
                                ),
                                 Text(
                                  '\$${watch.recordventa}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xFF039443)),
                                ),
                              ],
                            ),
                          )),
                          CustomCard(
                              child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.sell,
                                  color: Color(0xFF039443),
                                  size: 40,
                                ),
                                const Text(
                                  'Este mes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF039443)),
                                ),
                                Text(
                                  '${watch.ventasmes} ventas',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xFF039443)),
                                ),
                              ],
                            ),
                          )),
                          Center(
                            child: CustomCard(
                                child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, right: 16, left: 16, bottom: 16),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.payments,
                                          color: Color(0xFF039443),
                                          size: 40,
                                        ),
                                        const Text(
                                          'Ingresos del mes',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF039443)),
                                        ),
                                        Text(
                                          '\$${watch.ingresosmes}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color: Color(0xFF039443)),
                                        ),
                                      ],
                                    ),
                                  )),
                            )),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFECEBDE),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xFFE5E3D4),
                          )),
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  'Ventas mensuales del año 2024',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFF525B44)),
                                ),
                                AspectRatio(
                                  aspectRatio: 16 / 6,
                                  child: LineChartWidget(),
                                )
                              ],
                            ),
                          ))),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DashboardProvider watch =  context.watch<DashboardProvider>();
    final data = LineData();
    return watch.isLoading? const CircularProgressIndicator() : LineChart(
      LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (data) {
                return const Color(0xFF039443);
              },
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y}', // Texto mostrado (valor de ventas)
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return data.leftTitle[value.toInt()] != null
                      ? SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            data.leftTitle[value.toInt()].toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF525B44)),
                          ))
                      : const SizedBox();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return data.bottomTitle[value.toInt()] != null
                      ? SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            data.bottomTitle[value.toInt()].toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF525B44)),
                          ))
                      : const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              color: const Color(0xFF039443),
              barWidth: 2.5,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: const FlDotData(show: true),
              spots: watch.datos
            ),
          ],
          minX: 0,
          maxX: 115,
          maxY: 105,
          minY: -5),
    );
  }
}

class LineData {
  final leftTitle = {
    0: '0',
    20: '20',
    40: '40',
    60: '60',
    80: '80',
    100: '100',
    120: '120',
  };
  final bottomTitle = {
    0: 'Ene',
    10: 'Feb',
    20: 'Mar',
    30: 'Abr',
    40: 'May',
    50: 'Jun',
    60: 'Jul',
    70: 'Ago',
    80: 'Sep',
    90: 'Oct',
    100: 'Nov',
    110: 'Dic',
  };
}

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  Widget child;
  double? height;
  double? width;
  CustomCard({super.key, required this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        elevation: 5,
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            color: Color(0xFFECEBDE),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Align(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
