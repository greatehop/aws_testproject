from flask import render_template
from app import daemon_app
from app.models import DBModel


@daemon_app.route('/', strict_slashes=False)
def index():
    data = DBModel.query.all()
    return render_template('index.html', data=data)
