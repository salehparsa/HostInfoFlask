from flask import Flask, jsonify, render_template
from datetime import datetime
import socket
import json

app = Flask(__name__)

@app.route('/')
def index():
    # Get current timestamp and hostnames
    timestamp = datetime.utcnow().isoformat() + 'Z'
    container_hostname = socket.gethostname()
    
    # Render the template with the values
    return render_template('index.html', 
                           timestamp=timestamp,
                           container_hostname=container_hostname)

# healthcheck endpoint
@app.route('/health')
def health_check():
    return json.dumps({
        'status': 'UP',
        'timestamp': datetime.utcnow().isoformat()
    }), 200, {'Content-Type': 'application/json'}

# API endpoint
@app.route('/api')
def api():
    # Get current timestamp and hostnames
    timestamp = datetime.utcnow().isoformat() + 'Z'
    container_hostname = socket.gethostname()
    
    # Create a response dictionary
    response = {
        'timestamp': timestamp,
        'container_hostname': container_hostname,
    }
    
    # Return as a JSON response
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)