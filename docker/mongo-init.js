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

db.chats.createIndex( { chatId: -1 } );