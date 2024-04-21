#!/usr/bin/python3
"""A script that starts a Flask web application:"""
from flask import Flask, render_template

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


@app.route("/python/", strict_slashes=False)
@app.route("/python/<text>", strict_slashes=False)
def dynamic_text_default(text="is cool"):
    """Displays Dynamic text in browser"""
    text = text.replace('_', ' ')
    return f"Python {text}"


@app.route("/number/<int:n>", strict_slashes=False)
def display_integer(n):
    """Displays Integer in browser"""
    return f"{n} is a number"


@app.route("/number_template/<int:n>", strict_slashes=False)
def html_page(n):
    """Displays html_page in browser"""
    return render_template('5-number.html', n=n)


if __name__ == "__main__":
    app.run(debug=True)
