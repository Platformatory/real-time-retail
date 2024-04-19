from flask import Flask,request,jsonify
from datetime import timedelta,datetime,date
from random import randrange
import ast

app = Flask(__name__)

@app.route('/')
def index():
  return 'Index Page'


@app.route('/user', methods=["POST"])
def get_user():
      data = request.get_json()
      username = data['username']
      password = data['password']
      print({username, password })
      return {"username":username, password: password}  

def predict_sell_through(inventory_data):
    average_daily_sales = inventory_data['total_sales'] / inventory_data['total_days']
    days_until_sell_through = inventory_data['quantity_on_hand'] / average_daily_sales
    sell_through_date = datetime.now() + timedelta(days=days_until_sell_through)
    inventory_doh = inventory_data['quantity_on_hand'] / average_daily_sales
    return sell_through_date, inventory_doh

@app.route('/stores/<store_name>/inventory_forecast/predict', methods=["POST"])
def show_post(store_name):
  try:
    inventory_data = request.json
    if not inventory_data:
        return jsonify({'error': 'No data provided'}), 400
    
    
    sell_through_date, inventory_doh = predict_sell_through(inventory_data)
    print(sell_through_date, inventory_doh, inventory_data)
    return jsonify({
        'sell_through_date': sell_through_date.strftime('%Y-%m-%d'),
        'inventory_doh': int(inventory_doh)
    })
  except Exception as e:
      return jsonify({"error": str(e)})

@app.route('/dynamic-pricing', methods=['POST'])
def dynamic_pricing():
    try:
        data = request.get_json()[0]
        print(data) 
        if data["activity_count"]>3:
            data["dynamic_price"] = data["price"]*1.1
        else:
            data["dynamic_price"] = data["price"]*1.01

        return data, 200

    except Exception as e:
        # Handle any exceptions
        print(f"Error processing request: {str(e)}")
        return jsonify({'error': 'An error occurred'}), 500

@app.route('/sell-through', methods=['POST'])
def sell_through_date():
    try:
        data = request.get_json()[0]
        print(data) 
        # date + random days (5-10)
        data["sell_through_date"] = datetime.now() + timedelta(days=randrange(10))

        return data, 200

    except Exception as e:
        # Handle any exceptions
        print(f"Error processing request: {str(e)}")
        return jsonify({'error': 'An error occurred'}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

# curl -X POST http://localhost:5000/stores/acme/inventory_forecast/predict -H 'Content-Type:application/json' -d '{"total_sales":453,"total_days":32,"quantity_on_hand":98,"current_date":"2024-04-10T15:17"}'