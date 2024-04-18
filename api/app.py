from flask import Flask,request,jsonify
from datetime import timedelta,datetime

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

@app.route('/events', methods=['POST'])
def events():
    try:
        # Get the JSON data from the POST request
        print(request.data)
        #data = request.get_json()
        #request_json = request.data.decode('utf8')#.replace("'", '"')
        #data = json.loads(request_json)

        # Pretty print the JSON data to the console
        #print(json.dumps(data, indent=4))

        # Return a response if necessary
        return jsonify({'message': 'Data received successfully'}), 200

    except Exception as e:
        # Handle any exceptions
        print(f"Error processing request: {str(e)}")
        return jsonify({'error': 'An error occurred'}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

# curl -X POST http://localhost:5000/stores/acme/inventory_forecast/predict -H 'Content-Type:application/json' -d '{"total_sales":453,"total_days":32,"quantity_on_hand":98,"current_date":"2024-04-10T15:17"}'