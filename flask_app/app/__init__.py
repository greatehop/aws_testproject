import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy



#logger = Logger(config).create_logger()

# TODO: get rid of SQLite
basedir = os.path.abspath(os.path.dirname(__file__))
path_db = os.path.join(basedir, 'aws.db')



daemon_app = Flask(__name__)
daemon_app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % path_db
daemon_app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(daemon_app)

from app import views
