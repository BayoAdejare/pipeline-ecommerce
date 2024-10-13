import json
import random
from datetime import datetime, timedelta

def generate_sales_data(start_date, end_date, product_ids):
    current_date = start_date
    sales_data = []

    while current_date <= end_date:
        # Generate between 50 and 200 sales entries per day
        daily_sales_count = random.randint(50, 200)
        
        for _ in range(daily_sales_count):
            product_id = random.choice(product_ids)
            quantity_sold = random.randint(1, 10)
            price_per_unit = round(random.uniform(10.0, 500.0), 2)
            revenue = round(quantity_sold * price_per_unit, 2)
            
            sale_entry = {
                "sales_date": current_date.strftime("%Y-%m-%d"),
                "product_id": product_id,
                "quantity_sold": quantity_sold,
                "revenue": revenue,
                "average_price": price_per_unit,
                "channel": random.choice(["online", "in-store", "marketplace"]),
                "customer_segment": random.choice(["new", "returning", "loyal"]),
                "promotion_applied": random.choice([True, False]),
                "region": random.choice(["North", "South", "East", "West", "Central"]),
                "profit_margin": round(random.uniform(0.1, 0.5), 2),
                "total_cost": round(revenue * (1 - random.uniform(0.1, 0.5)), 2)
            }
            
            sales_data.append(sale_entry)
        
        current_date += timedelta(days=1)
    
    return sales_data

# Generate product IDs (assuming 10,000 products as in the previous script)
product_ids = [f"PROD{i}" for i in range(1000, 11000)]

# Set date range for one year of sales data
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 12, 31)

# Generate sales data
processed_sales_data = generate_sales_data(start_date, end_date, product_ids)

# Save to JSON file
with open('processed_sales_data.json', 'w') as f:
    json.dump(processed_sales_data, f, indent=2)

print(f"Generated {len(processed_sales_data)} processed sales data entries and saved to processed_sales_data.json")