import json
import random
import string

def generate_product_name():
    adjectives = ['Elegant', 'Durable', 'Sleek', 'Vintage', 'Modern', 'Cozy', 'Luxurious', 'Eco-friendly']
    nouns = ['Shirt', 'Pants', 'Dress', 'Shoes', 'Watch', 'Bag', 'Jacket', 'Sunglasses']
    return f"{random.choice(adjectives)} {random.choice(nouns)}"

def generate_description():
    descriptions = [
        "Perfect for any occasion.",
        "Made with high-quality materials.",
        "A must-have for your wardrobe.",
        "Comfortable and stylish.",
        "Designed for the modern lifestyle.",
        "Elevate your look with this piece.",
    ]
    return " ".join(random.sample(descriptions, k=random.randint(2, 4)))

def generate_product():
    product_id = f"PROD{random.randint(1000, 9999)}"
    product_name = generate_product_name()
    price = round(random.uniform(10.0, 500.0), 2)
    
    return {
        "product_id": product_id,
        "product_name": product_name,
        "price": price,
        "description": generate_description(),
        "category": random.choice(['Clothing', 'Accessories', 'Footwear', 'Jewelry']),
        "brand": ''.join(random.choices(string.ascii_uppercase, k=random.randint(3, 5))),
        "stock_quantity": random.randint(0, 1000),
        "weight": round(random.uniform(0.1, 5.0), 2),
        "dimensions": {
            "length": round(random.uniform(5, 50), 1),
            "width": round(random.uniform(5, 50), 1),
            "height": round(random.uniform(5, 50), 1)
        },
        "tags": random.sample(['trendy', 'casual', 'formal', 'seasonal', 'bestseller', 'new_arrival'], k=random.randint(1, 3)),
        "variants": [
            {
                "sku": f"SKU{random.randint(100000, 999999)}",
                "color": random.choice(['Red', 'Blue', 'Green', 'Black', 'White']),
                "size": random.choice(['S', 'M', 'L', 'XL'])
            } for _ in range(random.randint(1, 3))
        ],
        "rating": round(random.uniform(1, 5), 1),
        "review_count": random.randint(0, 1000)
    }

def generate_products(num_products):
    products = [generate_product() for _ in range(num_products)]
    return products

# Generate a large number of products (e.g., 10,000)
num_products = 10000
synthetic_products = generate_products(num_products)

# Save to JSON file
with open('ecomm_products.json', 'w') as f:
    json.dump(synthetic_products, f, indent=2)

print(f"Generated {num_products} synthetic e-commerce products and saved to ecomm_products.json")