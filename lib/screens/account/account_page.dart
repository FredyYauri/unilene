import 'package:flutter/material.dart';
import 'package:unilene_app/services/account/service_account.dart';
import 'package:unilene_app/screens/contact/contact_page.dart';
import 'package:unilene_app/core/widgets/custom_font.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _accounts = [];
  @override
  void initState() {
    super.initState();
    BackendAccount.getAccounts(context, "").then((value) => setState(() {
          _accounts = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        BackendAccount.getAccounts(context, value)
                            .then((response) => setState(() {
                                  _accounts = response;
                                }));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando datos')),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return InkWell(
                  onTap: () {
                    // Acción cuando se toca el item
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactPage(
                            accountId: account["codCliente"]!,
                            accountDescription: account["razonSocial"]!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.badge,
                              size: 51.0,
                              color: Color(0xFF1E1E1E),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  fotmatTitleList(account["razonSocial"]!),
                                  const SizedBox(height: 4.0),
                                  fotmatTextList(
                                      'ID: ${account["codCliente"]!}'),
                                  fotmatTextList(
                                      'RUC: ${account["documento"]!}'),
                                  fotmatTextList(
                                      'Vendedor: ${account["vendedor"]!}'),
                                  fotmatTextList(
                                      'Promotor: ${account["promotor"]!}'),
                                  fotmatTextList(
                                      'Tipo Cliente: ${account["tipoCliente"]!}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
