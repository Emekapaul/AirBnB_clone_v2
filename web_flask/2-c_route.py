#!/usr/bin/python3
"""A script that starts a Flask web application:"""
from flask import Flask

app = Flask(__name__)


@app.route("/", strict_slashes=False)
def hello_hbnb():
    """Displays Hello HBNB! in browser"""
    return "Hello HBNB!"


@app.route("/hbnb", strict_slashes=False)
def hbnb():
    """Displays HBNB in browser"""
    return "HBNB"


@app.route("/c/<text>", strict_slashes=False)
def dynamic_text(text):
    """Displays Dynamic text in browser"""
    text = text.replace('_', ' ')
    return f"C {text}"


if __name__ == "__main__":
    app.run(debug=True)