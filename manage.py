from flask import Flask

app = Flask(__name__)
app.config['TESTING'] = True

@app.route("/")
def helloworld():
    return "<p>Hello, !</p>"

def run():
     app.run(host="0.0.0.0", port=8004, debug=True)

if __name__ == "__main__":
    run()