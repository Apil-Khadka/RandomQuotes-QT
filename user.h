#ifndef USER_H
#define USER_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

class User : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString avatarPath READ avatarPath WRITE setAvatarPath NOTIFY avatarChanged)
    Q_PROPERTY(bool done READ done  NOTIFY doneChanged)
public:
    explicit User(QObject *parent = nullptr);

    QString username() const;
    Q_INVOKABLE void setUsername(const QString &username); // Add Q_INVOKABLE

    QString avatarPath() const;
    Q_INVOKABLE void setAvatarPath(const QString &avatarPath); // Add Q_INVOKABLE

    bool done() const;
    Q_INVOKABLE void setDone();

signals:
    void usernameChanged();
    void avatarChanged();
    void doneChanged();

private:
    void initDatabase();
    bool setupDatabaseConnection();
    bool createDirectories();
    void createUserTable();
    void copyDefaultImages();
    void initializeDefaultUser();
    void logDebug(const QString &message);

    QSqlDatabase u_db;
    QString m_destDir;
    QString m_destImages;
    QString m_destPath;
    QString m_username;
    QString m_avatarPath;
};

#endif // USER_H
