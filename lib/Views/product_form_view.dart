import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_gerenciamento/models/product.dart';
import 'package:shop_gerenciamento/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imagemUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)!.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['Url'] = product.imageUrl;

        _imagemUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    // importante, pois liberar recursos
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocus.removeListener(updateImage);
    _imageFocus.dispose();
    super.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)!.hasAbsolutePath;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.gif');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(context, listen: false)
          .addProductFromData(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Ocorreu um erro',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: const Text('Ocorreu um erro ao salvar o produto'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de produto'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save),
            tooltip: 'Submeter',
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        hintText: 'Ex: Victor Gomes',
                        helperText: 'Informe seu nome',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (name) {
                        if (name!.trim().isEmpty) {
                          // O trim retira os espaços em branco.
                          return 'Nome é obrigatório';
                        }
                        if (name.trim().length < 3) {
                          // O trim retira os espaços em branco.
                          return 'Nome precisa no mínimo de 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      focusNode: _priceFocus,
                      onSaved: (_price) {
                        final priceString = _price ?? '0';
                        final price = priceString.replaceAll(',', '.');
                        _formData['price'] = double.parse(price);
                      },
                      validator: (_price) {
                        final priceString = _price ?? '0';
                        final priceOp = priceString.replaceAll(',', '.');
                        final price = double.tryParse(priceOp) ?? 0;
                        if (price <= 0) {
                          return 'Valor inválido';
                        }

                        return null;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (desc) => _formData['description'] = desc ?? '',
                      validator: (_desc) {
                        final desc = _desc ?? '';
                        if (desc.trim().isEmpty) {
                          // O trim retira os espaços em branco.
                          return 'Descrição é obrigatório';
                        }
                        if (desc.trim().length < 20) {
                          // O trim retira os espaços em branco.
                          return 'Descrição precisa no mínimo de 20 letras.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Url da imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageFocus,
                            controller: _imagemUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (url) => _formData['Url'] = url ?? '',
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl;
                              if (!isValidImageUrl(imageUrl!)) {
                                return 'Informe uma Url válida!';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: (_imagemUrlController.text.isEmpty ||
                                  !isValidImageUrl(_imagemUrlController.text))
                              ? const Text('Informe a Url')
                              : Image.network(_imagemUrlController.text),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
