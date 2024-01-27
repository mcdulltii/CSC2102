from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from pymongo import MongoClient
from bson import json_util
from bson.objectid import ObjectId
import mariadb
import json

# Define the MongoDB connection string
MONGO_URI = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"


# Create the Flask app
app = Flask(__name__)
cors = CORS(app)
app.config["CORS_HEADERS"] = "Content-Type"
db = None


def connect_db() -> MongoClient:
    global MONGO_URI
    try:
        # Connect to MongoDB
        client = MongoClient(MONGO_URI)
        print("Connected to MongoDB successfully!")
    except errors.ConnectionFailure as e:
        print("Could not connect to MongoDB:", e)
    except Exception as e:
        print("An error occurred:", e)
    
    return client


def close_db(client: MongoClient, conn) -> None:
    if client:
        # Close the connection when done
        client.close()
    if conn:
        conn.close()


def connect_db_mariadb():
    try:
        conn = mariadb.connect(
            user="root",
            password="password",
            host="mariadb",
            port=3306,
            database="mysql_db"
        )
        print("Test")
        return conn
    except mariadb.error as e:
        print(f"error connecting to mariadb platform: {e}")
        return None


@app.route("/api/addNewChat", methods=["POST"])
@cross_origin()
def add_new_chat():
    global db
    chat_data = request.get_json()
    chats_collection = db.chats

    # Add the new chat to the collection
    new_chat = {"chatId": chat_data["chatId"]}
    chats_collection.insert_one(new_chat)

    return {"result": True, "message": "Chat added successfully!"}, 201


@app.route("/api/getAllChats")
@cross_origin()
def get_all_chats():
    global db
    chats_collection = db.chats

    # Get all chats from the collection
    all_chats = [json.loads(json_util.dumps(chat)) for chat in chats_collection.find()]

    return all_chats, 200


def main() -> None:
    global db, db_mariadb
    # Connect to the MongoDB database
    client = connect_db()
    # Get the database
    db = client.get_database()
    db_mariadb = connect_db_mariadb()
    while True:
        try:
            app.run(host="0.0.0.0", port=8000, debug=True)
        except KeyboardInterrupt:
            break
    close_db(client, db_mariadb)


if __name__ == '__main__':
    main()