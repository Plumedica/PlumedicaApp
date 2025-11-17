import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class PharmacyDashboard extends StatefulWidget {
  const PharmacyDashboard({Key? key}) : super(key: key);

  @override
  State<PharmacyDashboard> createState() => _PharmacyDashboardState();
}

class _PharmacyDashboardState extends State<PharmacyDashboard> {
  final List<Order> recentOrders = [
    Order(id: 'ORD-1001', customer: 'Alice M.', total: 24.50, status: OrderStatus.pending, placed: DateTime.now().subtract(const Duration(hours: 3))),
    Order(id: 'ORD-1000', customer: 'Bob K.', total: 12.00, status: OrderStatus.completed, placed: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
    Order(id: 'ORD-0999', customer: 'Clinic XYZ', total: 120.00, status: OrderStatus.processing, placed: DateTime.now().subtract(const Duration(days: 2))),
  ];

  final List<Medicine> lowStock = [
    Medicine(name: 'Amoxicillin 500mg', stock: 3),
    Medicine(name: 'Paracetamol 500mg', stock: 2),
    Medicine(name: 'Insulin', stock: 1),
  ];

  String q = '';

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    final filteredOrders = recentOrders.where((o) {
      if (q.isEmpty) return true;
      return o.id.toLowerCase().contains(q.toLowerCase()) || o.customer.toLowerCase().contains(q.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (v) {},
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                leading: CircleAvatar(child: Icon(Icons.local_pharmacy)),
                title: Text('Plumedica Pharmacy'),
                subtitle: Text('Downtown Branch'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.inventory_2),
                title: const Text('Inventory'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Orders'),
                onTap: () {},
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Overview cards
            Row(
              children: [
                _StatCard(
                  color: Colors.blue.shade700,
                  label: 'Active Orders',
                  value: recentOrders.where((o) => o.status != OrderStatus.completed).length.toString(),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  color: Colors.green.shade700,
                  label: 'Revenue (30d)',
                  value: currency.format(recentOrders.fold(0.0, (p, e) => p + e.total)),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  color: Colors.orange.shade700,
                  label: 'Low Stock',
                  value: lowStock.length.toString(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search orders or customers',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              onChanged: (v) => setState(() => q = v),
            ),
            const SizedBox(height: 12),

            // Content lists
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Recent orders section
                    _SectionHeader(title: 'Recent Orders', actionLabel: 'View all', onTapAction: () {}),
                    const SizedBox(height: 8),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, i) {
                        final o = filteredOrders[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _statusColor(o.status),
                            child: const Icon(Icons.receipt_long, color: Colors.white, size: 18),
                          ),
                          title: Text(o.id),
                          subtitle: Text('${o.customer} • ${DateFormat.yMMMd().add_jm().format(o.placed)}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(currency.format(o.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(o.status.name, style: TextStyle(color: _statusColor(o.status))),
                            ],
                          ),
                          onTap: () {}, // navigate to order details
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // Low stock section
                    _SectionHeader(title: 'Low Stock Items', actionLabel: 'Manage', onTapAction: () {}),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: lowStock.length,
                      itemBuilder: (_, i) {
                        final m = lowStock[i];
                        return ListTile(
                          leading: const Icon(Icons.medical_services),
                          title: Text(m.name),
                          trailing: Text('Qty ${m.stock}', style: const TextStyle(color: Colors.red)),
                          onTap: () {}, // open inventory item
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
        onPressed: () {},
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({Key? key, required this.label, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onTapAction;
  const _SectionHeader({Key? key, required this.title, required this.actionLabel, required this.onTapAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
  title,
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
),
        TextButton(onPressed: onTapAction, child: Text(actionLabel)),
      ],
    );
  }
}

enum OrderStatus { pending, processing, completed, cancelled }

extension OrderStatusName on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Order {
  final String id;
  final String customer;
  final double total;
  final OrderStatus status;
  final DateTime placed;

  Order({required this.id, required this.customer, required this.total, required this.status, required this.placed});
}

class Medicine {
  final String name;
  final int stock;

  Medicine({required this.name, required this.stock});
}