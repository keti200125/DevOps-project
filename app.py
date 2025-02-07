from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello World"

@app.route("/hostname")
def get_hostname():
    return socket.gethostname()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)