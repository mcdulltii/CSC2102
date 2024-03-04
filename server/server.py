from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from pymongo import MongoClient, errors
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


def close_db(client: MongoClient) -> None:
    if client:
        # Close the connection when done
        client.close()

def connect_db_mariadb():
    try:
        conn = mariadb.connect(
            user="user",
            password="password",
            host="mariadb",
            port=3306,
            database="mysql_db"
        )
        print("Connected to MariaDB successfully")
        return conn
    except mariadb.error as e:
        print(f"Error connecting to mariadb platform: {e}")
        return None

@app.route("/api/addNewUser", methods=["POST"])
@cross_origin()
def add_new_user():
    global db_mariadb
    user_data = request.get_json()
    
    with db_mariadb.cursor() as cursor:
        try:
            cursor.execute("INSERT INTO users (user_id, user_name, user_password_hash) VALUES (%s, %s, %s)",
                        (user_data["userId"], user_data["userName"], user_data["userPasswordHash"]))
            db_mariadb.commit()
            return {"result": True, "message": "User added successfully!"}, 201
        except Exception as e:
            print(e)
            if "cursor" in locals():
                db_mariadb.rollback()
            return {"result": False, "error": "Failed to add user"}, 500
        finally:
            cursor.close()


@app.route("/api/addNewChat", methods=["POST"])
@cross_origin()
def add_new_chat():
    global db, db_mariadb
    chat_data = request.get_json()
    chats_collection = db.chats

    with db_mariadb.cursor() as cursor:
        try:
            cursor.execute("INSERT INTO chats (chat_id, user_id) VALUES (%s, %s)", (chat_data["chatId"], chat_data["userId"]))
            db_mariadb.commit()

            new_chat = {"chatId": chat_data["chatId"]}
            chats_collection.insert_one(new_chat)

            return {"result": True, "message": "Chat added successfully!"}, 201
        except Exception as e:
            print(e)
            if "cursor" in locals():
                db_mariadb.rollback()
            return {"result": False, "error": "Failed to add chat"}, 500
        finally:
            cursor.close()

    
@app.route("/api/getAllChats")
@cross_origin()
def get_all_chats():
    global db, db_mariadb

    # Requires user id in query parameters
    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400
    
    cursor = db_mariadb.cursor()
    cursor.execute("SELECT chat_id FROM chats WHERE user_id = %s", (user_id,))
    chat_ids = [row["chat_id"] for row in cursor.fetchall()]
    cursor.close()  

    chats_collection = db.chats
    all_chats = [json.loads(json_util.dumps(chat)) for chat in chats_collection.find({"chatId": {"$in": chat_ids}})]

    return jsonify(all_chats), 200


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
    close_db(client)


if __name__ == '__main__':
    main()