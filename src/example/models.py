import flask_sqlalchemy
from sqlalchemy import UniqueConstraint

db = flask_sqlalchemy.SQLAlchemy()


class Cats(db.Model):
    __tablename__ = 'cats'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    price = db.Column(db.Integer)
    breed = db.Column(db.String(100))


class Users(db.Model):
    __tablename__ = "Users"

    __table_args__ = (UniqueConstraint("email"), {"schema": "Palestra"})

    id_user = db.Column("id_user", db.Integer, primary_key=True)
    name = db.Column("name", db.String(50), nullable=False)
    surname = db.Column("surname", db.String(50), nullable=False)
    birth_date = db.Column("birth_date", db.Date, nullable=False)
    #codice fiscale
    social_security_number = db.Column("social_security_number", db.String(50), nullable=False)
    phone = db.Column("phone", db.String(50), nullable=False)
    role = db.Column("role", db.String(50), nullable=False)
    email = db.Column("email", db.String(50), nullable=False)


class Subscriptions(db.Model):
    __tablename__ = "Subscriptions"

    subscription_id = db.Column("subscription_id", db.Integer, primary_key=True)
    start_date = db.Column("start_date", db.Date, nullable=False)
    end_date = db.Column("end_date", db.Date, nullable=False)
    cur_balance = db.Column("cur_balance", db.Decimal(15, 2), nullable=False)
    user = db.Column(db.Integer, db.ForeignKey('Users.id_user'), nullable=False)


