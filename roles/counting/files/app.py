from flask import Flask, jsonify
from threading import Lock

app = Flask(__name__)

counter = 0
lock = Lock()


@app.get("/health")
def health():
    return jsonify({"status": "ok"}), 200


@app.get("/count")
def count():
    global counter
    with lock:
        counter += 1
        value = counter

    return jsonify({
        "service": "counting",
        "count": value
    }), 200


@app.post("/reset")
def reset():
    global counter
    with lock:
        counter = 0

    return jsonify({
        "service": "counting",
        "count": 0
    }), 200
