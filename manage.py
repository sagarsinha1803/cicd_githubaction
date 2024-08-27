from flask import Flask
from .service.service import hello_world_fn

app = Flask(__name__)


@app.route("/")
def hello_world():
    return hello_world_fn()


def run():
    app.run(host="0.0.0.0", port=8004, debug=True)


if __name__ == "__main__":
    run()
