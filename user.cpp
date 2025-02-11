#include "user.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QStandardPaths>


User::User(QObject *parent)
    : QObject(parent), m_username("User" + QString::number(rand() % 1000)) {
    qDebug() << "Initializing User...";
    initDatabase();
}

bool User::done() const{
    QSqlQuery query(u_db);
    if (query.exec("SELECT done FROM users LIMIT 1;") && query.next()) {
        return query.value(0).toBool();
    }
    return false;
}

void User::setDone()
{
    QSqlQuery query(u_db);
    QString doneQuery = "UPDATE Users SET done = true WHERE id = 1";
    if(query.exec(doneQuery))
    {
        emit doneChanged();
    }
}

QString User::username() const {
    QSqlQuery query(u_db);
    if (query.exec("SELECT username FROM users LIMIT 1;") && query.next()) {
        return query.value(0).toString();
    } else {
        qWarning() << "Failed to fetch username:" << query.lastError();
    }
    return "DefaultUser";  // Fallback
}

void User::setUsername(const QString &username) {
    if (m_username != username) {
        m_username = username;


        // Update the database
        QSqlQuery query(u_db);
        query.prepare("UPDATE users SET username = ? WHERE id = 1");
        query.addBindValue(m_username);
        if (!query.exec()) {
            qWarning() << "Failed to update username:" << query.lastError();
        }
        emit usernameChanged(); // Notify QML of the change
    }
}

QString User::avatarPath()  const {
    QSqlQuery query(u_db);
    if (query.exec("SELECT avatar FROM users LIMIT 1;") && query.next()) {
        return query.value(0).toString();
    } else {
        qWarning() << "Failed to fetch avatar path:" << query.lastError();
    }
    return QString();  // Fallback empty path
}

void User::setAvatarPath(const QString &avatarPath) {
    if (m_avatarPath != avatarPath) {
        m_avatarPath = avatarPath;

        // Update the database
        QSqlQuery query(u_db);
        query.prepare("UPDATE users SET avatar = ? WHERE id = 1");
        query.addBindValue(m_avatarPath);
        if (!query.exec()) {
            qWarning() << "Failed to update avatar:" << query.lastError();
        }
        emit avatarChanged(); // Notify QML of the change
    }
}


void User::initDatabase() {
    // Initialize paths for directories and files
    m_destDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    m_destImages = m_destDir + "/images/";
    m_destPath = m_destDir + "/quotes.db";

    logDebug("Starting database initialization");

    if (!setupDatabaseConnection()) {
        logDebug("Database setup failed. Initialization aborted.");
        return;
    }

    createUserTable();

    if (!createDirectories()) {
        logDebug("Directory creation failed. Initialization aborted.");
        return;
    }

    copyDefaultImages();

    initializeDefaultUser();

    logDebug("Database initialization complete.");
}

bool User::setupDatabaseConnection() {
    u_db = QSqlDatabase::addDatabase("QSQLITE", "User_table_connection");
    u_db.setDatabaseName(m_destPath);

    if (!u_db.open()) {
        logDebug("Database open error: " + u_db.lastError().text());
        return false;
    }

    logDebug("Database connection established successfully.");
    return true;
}

bool User::createDirectories() {
    QDir dir(m_destDir);
    if (!dir.exists() && !dir.mkpath(m_destDir)) {
        logDebug("Failed to create directory: " + m_destDir);
        return false;
    }

    QDir imageDir(m_destImages);
    if (!imageDir.exists() && !imageDir.mkpath(m_destImages)) {
        logDebug("Failed to create images directory: " + m_destImages);
        return false;
    }

    logDebug("Directories created successfully.");
    return true;
}

void User::createUserTable() {
    QSqlQuery query(u_db);
    QString createTableQuery = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, avatar TEXT, done bool);";

    if (!query.exec(createTableQuery)) {
        logDebug("Failed to create users table: " + query.lastError().text());
    } else {
        logDebug("Users table created or already exists.");
    }
}

void User::copyDefaultImages() {
    for (int i = 1; i <= 3; ++i) {
        QString sourceFilePath = QString(":/images/avatar%1.jpg").arg(i);
        QString destAvatarPath = m_destImages + QString("avatar%1.jpg").arg(i);

        if (QFile::exists(destAvatarPath)) {
            logDebug("Image already exists: " + destAvatarPath);
            continue;
        }

        QFile sourceFile(sourceFilePath);
        if (!sourceFile.open(QIODevice::ReadOnly)) {
            logDebug("Failed to open resource file: " + sourceFilePath);
            continue;
        }

        QFile destFile(destAvatarPath);
        if (!destFile.open(QIODevice::WriteOnly)) {
            logDebug("Failed to write image to: " + destAvatarPath);
            sourceFile.close();
            continue;
        }

        destFile.write(sourceFile.readAll());
        destFile.close();
        sourceFile.close();

        logDebug("Copied image: " + destAvatarPath);
    }
}

void User::initializeDefaultUser() {
    QSqlQuery query(u_db);
    query.prepare("SELECT COUNT(*) FROM users");

    QString basepath="";

#ifdef Q_OS_ANDROID
    basepath="content://";
#elif defined(Q_OS_LINUX)
    basepath="file://";
#else
    basepath="file://";
#endif

    if (query.exec() && query.next() && query.value(0).toInt() == 0) {
        QString defaultAvatarPath = basepath + m_destImages + QString("avatar%1.jpg").arg((rand() % 3) + 1);

        QString randomUsername = "User" + QString::number(rand() % 1000);

        query.prepare("INSERT INTO users (username, avatar,done) VALUES (?, ?,?)");
        query.addBindValue(randomUsername);
        query.addBindValue(defaultAvatarPath);
        query.addBindValue(false);

        if (!query.exec()) {
            logDebug("Failed to insert default user: " + query.lastError().text());
        } else {
            logDebug("Default user inserted successfully.");
        }
    } else {
        logDebug("User table already contains entries.");
    }
}

void User::logDebug(const QString &message) {
    qDebug() << "[User Debug]:" << message;
}
