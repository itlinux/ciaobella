from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    return """
    <html>
        <body style="background-color:#121212; color:#ffffff; font-family:Arial;">
            <h1><center>Ciao Remo + Kubernetes! 🚀 </center></h1>
        </body>
    </html>
    """


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8880)
