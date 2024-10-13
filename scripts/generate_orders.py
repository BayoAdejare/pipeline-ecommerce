import json
import random
from datetime import datetime, timedelta

def generate_order():
    order_id = f"ORDER{random.randint(1000000, 9999999)}"
    customer_id = f"CUST{random.randint(100000, 999999)}"
    order_date = (datetime.now() - timedelta(days=random.randint(0, 365))).strftime("%Y-%m-%d %H:%M:%S")
    total_amount = round(random.uniform(10.0, 1000.0), 2)
    
    return {
        "order_id": order_id,
        "customer_id": customer_id,
        "order_date": order_date,
        "total_amount": total_amount,
        "status": random.choice(["pending", "processing", "shipped", "delivered", "cancelled"]),
        "payment_method": random.choice(["credit_card", "paypal", "apple_pay", "google_pay"]),
        "shipping_address": {
            "street": f"{random.randint(1, 999)} {random.choice(['Main', 'Oak', 'Pine', 'Maple'])} St",
            "city": random.choice(["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"]),
            "state": random.choice(["NY", "CA", "IL", "TX", "AZ"]),
            "zip_code": f"{random.randint(10000, 99999)}",
            "country": "United States"
        },
        "items": [
            {
                "product_id": f"PROD{random.randint(1000, 9999)}",
                "quantity": random.randint(1, 5),
                "price": round(random.uniform(5.0, 200.0), 2)
            } for _ in range(random.randint(1, 5))
        ]
    }

def generate_orders(num_orders):
    orders = [generate_order() for _ in range(num_orders)]
    return orders

# Generate a large number of orders (e.g., 100,000)
num_orders = 100000
synthetic_orders = generate_orders(num_orders)

# Save to JSON file
with open('shopify_orders.json', 'w') as f:
    json.dump(synthetic_orders, f, indent=2)

print(f"Generated {num_orders} synthetic Shopify orders and saved to shopify_orders.json")