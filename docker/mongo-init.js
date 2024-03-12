db.createUser(
    {
        user: "user",
        pwd: "password",
        roles: [
            {
                role: "readWrite",
                db: "mongo_db"
            }
        ]
    }
);

db.chats.createIndex({ _id: -1 });
db.messages.createIndex({ _id: -1 });


