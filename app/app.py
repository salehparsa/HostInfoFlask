from flask import Flask, jsonify, render_template
from prometheus_flask_exporter import PrometheusMetrics
from datetime import datetime
import socket

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

# health check endpoint
@app.route('/health')
def health_check():
    return json.dumps({
        'status': 'UP',
        'timestamp': datetime.datetime.now().isoformat(),
    }), 200, {'Content-Type': 'application/json'}

# Prometheus metrics will be exposed at /metrics by default
@app.route('/metrics')
def metrics_endpoint():
    return metrics.generate_latest()

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
