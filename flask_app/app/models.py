from app import db


class DBModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(100))
    last_name = db.Column(db.String(100))
    first_name = db.Column(db.String(100))
    filename = db.Column(db.String(100))
    datetime = db.Column(db.DateTime, default=None)
