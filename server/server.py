from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from flask_bcrypt import Bcrypt
from pymongo import MongoClient, errors
from bson import json_util
from bson.objectid import ObjectId
import mysql.connector
import re
import uuid
import json
import sys

# Define the MongoDB connection string
MONGO_URI = "mongodb://root:password@mongodb:27017/mongo_db?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=false"

# Create the Flask app
app = Flask(__name__)
cors = CORS(app)
bcrypt = Bcrypt(app)
app.config["CORS_HEADERS"] = "Content-Type"
db = None
db_mariadb = None


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
        sys.exit()

    return client


def close_db(client: MongoClient) -> None:
    if client:
        # Close the connection when done
        client.close()


def connect_db_mariadb():
    try:
        # Connect to Mariadb
        conn = mysql.connector.connect(
            user="root",
            password="password",
            host="mariadb",
            database="mysql_db"
        )
        print("Connected to MariaDB successfully")

        with conn.cursor() as cursor:
            try:
                cursor.execute("""CREATE TABLE IF NOT EXISTS `users` (
                    `user_id` CHAR(36) NOT NULL,
                    `user_email` VARCHAR(255) NOT NULL,
                    `user_password_hashed` VARCHAR(255) NOT NULL,
                    PRIMARY KEY (`user_id`)
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;""")
                conn.commit()
                print("Tables created successfully!")
            except Exception as e:
                print(e)
                if "cursor" in locals():
                    conn.rollback()
                sys.exit()
            finally:
                cursor.close()

        return conn
    except mysql.connector.Error as e:
        print(f"Error connecting to mariadb platform: {e}")
        sys.exit()


def close_db_mariadb(conn) -> None:
    if conn:
        # Close the connection when done
        conn.close()


# Validate email format
def validate_email(email):
    pattern = re.compile(r'^\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b')
    return bool(pattern.match(email))


# Validate password
def is_valid_password(password):
    # Can add more password requirements here
    return len(password) >= 8


@app.route("/api/addNewUser", methods=["POST"])
@cross_origin()
def add_new_user():
    global db_mariadb
    # User data to include user email and password
    user_data = request.get_json()

    if "userEmail" not in user_data or "userPassword" not in user_data or not validate_email(user_data["userEmail"]) or not is_valid_password(user_data["userPassword"]):
        return {"result": False, "error": "Invalid or missing email/password"}, 401

    # Hash the password using bcrypt
    hashed_password = bcrypt.generate_password_hash(user_data["userPassword"]).decode("utf-8")

    # Generate a UUID for user ID
    userId = str(uuid.uuid4())

    with db_mariadb.cursor() as cursor:
        try:
            cursor.execute("INSERT INTO users (user_id, user_email, user_password_hashed) VALUES (%s, %s, %s)",
                        (userId, user_data["userEmail"], hashed_password))
            db_mariadb.commit()
            return {"result": True, "message": "User added successfully!"}, 201
        except Exception as e:
            print(e)
            if "cursor" in locals():
                db_mariadb.rollback()
            return {"result": False, "error": "Failed to add user"}, 500
        finally:
            cursor.close()


@app.route("/api/login", methods=["POST"])
@cross_origin()
def login():
    global db_mariadb
    # Login data to include user email and password
    login_data = request.get_json()

    if "userEmail" not in login_data or "userPassword" not in login_data:
        return {"result": False, "error": "User email and password are required"}, 401

    with db_mariadb.cursor(dictionary=True) as cursor:
        try:
            cursor.execute("SELECT user_id, user_email, user_password_hashed FROM users WHERE user_email = %s", (login_data["userEmail"],))
            user = cursor.fetchone()

            if user and bcrypt.check_password_hash(user["user_password_hashed"], login_data["userPassword"]):
                return {"result": True, "message": "Login successful", "user_id": user["user_id"]}, 200
            else:
                # Invalid credentials
                return {"result": False, "error": "Invalid email or password"}, 401
        except Exception as e:
            print(e)
            return {"result": False, "error": "Login failed"}, 500
        finally:
            cursor.close()


@app.route("/api/addNewChat", methods=["POST"])
@cross_origin()
def add_new_chat():
    global db
    # Chat data to include user ID, title and timestamp
    chat_data = request.get_json()

    if "userId" not in chat_data or "title" not in chat_data or "timestamp" not in chat_data:
        return {"result": False, "error": "User ID, title and timestamp are required"}, 400

    chats_collection = db.chats

    new_chat = {
        "userId": chat_data["userId"],
        "title": chat_data["title"],
        "timestamp": chat_data["timestamp"]
    }

    try:
        result = chats_collection.insert_one(new_chat)
        return {"result": True, "message": "Chat created successfully", "chat_id": str(result.inserted_id)}, 201
    except Exception as e:
        print(e)
        return {"result": False, "error": "Failed to create chat"}, 500


@app.route("/api/getAllChats")
@cross_origin()
def get_all_chats():
    global db
    # Requires user ID
    user_id = request.args.get("userId")

    if not user_id:
        return {"result": False, "error": "User ID is required"}, 400

    chats_collection = db.chats
    chats = chats_collection.find({"userId": user_id})

    chat_list = []
    for chat in chats:
        chat_data = {
            "chatId": str(chat["_id"]),
            "userId": chat["userId"],
            "title": chat["title"],
            "timestamp": chat["timestamp"]
        }
        chat_list.append(chat_data)

    return jsonify(chat_list), 200


@app.route("/api/updateChatTitle", methods=["PUT"])
@cross_origin()
def update_chat_title():
    global db
    # Update data to include chat ID and new title
    update_data = request.get_json()

    if "chatId" not in update_data or "title" not in update_data:
        return {"result": False, "error": "Chat ID and title are required"}, 400

    chats_collection = db.chats

    try:
        result = chats_collection.update_one({"_id": ObjectId(update_data["chatId"])}, {"$set": {"title": update_data["title"]}})
        if result.modified_count > 0:
            return {"result": True, "message": "Chat title updated successfully"}, 200
        else:
            return {"result": False, "error": "Chat not found or title unchanged"}, 404
    except Exception as e:
        print(e)
        return {"result": False, "error": "Failed to update chat title"}, 500


@app.route("/api/createMessage", methods=["POST"])
@cross_origin()
def create_message():
    global db
    # Message data to include chat ID, isBot, payload and timestamp
    message_data = request.get_json()

    if "chatId" not in message_data or "isBot" not in message_data or "payload" not in message_data or "timestamp" not in message_data:
        return {"result": False, "error": "Chat ID, isBot, payload and timestamps are required"}, 400

    chats_collection = db.chats
    messages_collection = db.messages

    # Check if the chat exists
    if not chats_collection.find_one({"_id": ObjectId(message_data["chatId"])}):
        return {"result": False, "error": "Chat not found"}, 404

    new_message = {
        "chatId": message_data["chatId"],
        "isBot": message_data["isBot"],
        "payload": message_data["payload"],
        "timestamp": message_data["timestamp"]
    }

    try:
        result = messages_collection.insert_one(new_message)
        return {"result": True, "message": "Message created successfully", "message_id": str(result.inserted_id)}, 201
    except Exception as e:
        print(e)
        return {"result": False, "error": "Failed to create message"}, 500


@app.route("/api/getMessages")
@cross_origin()
def get_message():
    global db
    # Requires chat ID
    chat_id = request.args.get("chatId")

    if not chat_id:
        return {"result": False, "error": "Chat ID is required"}, 400

    messages_collection = db.messages
    messages = messages_collection.find({"chatId": chat_id})

    message_list = []
    for message in messages:
        message_data = {
            "chatId": message["chatId"],
            "isBot": message["isBot"],
            "payload": message["payload"],
            "timestamp": message["timestamp"]
        }
        message_list.append(message_data)

    return jsonify(message_list), 200


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
    close_db_mariadb(db_mariadb)


if __name__ == '__main__':
    main()
