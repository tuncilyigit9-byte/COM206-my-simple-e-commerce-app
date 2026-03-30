import 'package:flutter/material.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  final String category;

  const ProductPage({super.key, required this.category});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectedColor;
  String? selectedSize;

  List<String> get colors {
    switch (widget.category) {
      case 'Jeans':
        return ['Blue', 'Light Gray', 'Dark Blue', 'Black', 'Fume'];
      default:
        return ['Red', 'Blue', 'Green', 'Black', 'White'];
    }
  }

  List<String> get sizes {
    switch (widget.category) {
      case 'Hat':
        return []; // Hat is one-size.
      case 'Jeans':
        return ['34', '36', '38', '40', '42'];
      default:
        return ['S', 'M', 'L', 'XL', 'XXL'];
    }
  }

  bool get requiresSize => widget.category != 'Hat';

  int getProductPrice(String category) {
    switch (category) {
      case 'Hat':
        return 10;
      case 'T-Shirt':
        return 19;
      case 'Shirt':
        return 26;
      case 'Jeans':
        return 32;
      case 'Coat':
        return 36;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = getProductPrice(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose options for ${widget.category}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Select Color:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedColor,
              hint: const Text('Select color'),
              items: colors.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedColor = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            if (requiresSize) ...[
              const Text('Select Size:', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: selectedSize,
                hint: const Text('Select size'),
                items: sizes.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSize = newValue;
                  });
                },
              ),
            ] else ...[
              const Text('Size: One size fits all ages', style: TextStyle(fontSize: 18)),
            ],
            const SizedBox(height: 20),
            Text('Price: \$$price', style: const TextStyle(fontSize: 18, color: Colors.green)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (selectedColor != null && (!requiresSize || selectedSize != null))
                  ? () {
                      cartItems.add(
                        CartItem(
                          name: widget.category,
                          color: selectedColor!,
                          size: requiresSize ? selectedSize! : 'One size (All ages)',
                          price: price,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.category} added to cart'),
                        ),
                      );
                    }
                  : null,
              child: const Text('Add to Cart'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
              child: const Text('Go to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}