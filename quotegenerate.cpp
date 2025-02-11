#include "quotegenerate.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QTime>

#include <QClipboard>
#include <QGuiApplication>

QuoteGenerate::QuoteGenerate(QObject *parent)
    : QObject(parent), m_currentIndex(0)
{
    // Seed the random generator.
   initializeDatabase();
    m_statusMessage = "";
}

QString QuoteGenerate::currentQuote() const {
    if (m_quotes.isEmpty())
        return "Click Generate To get a Quote";
    return m_quotes[m_currentIndex].first;
}

QString QuoteGenerate::currentAuthor() const {
    if (m_quotes.isEmpty())
        return "";
    return m_quotes[m_currentIndex].second;
}

QString QuoteGenerate::statusMessage() const {
    return m_statusMessage;
}

void QuoteGenerate::generateQuote() {
    if (!m_db.isOpen()) {
        qWarning() << "Database is not open!";
        return;
    }

    QSqlQuery query(m_db);
    // Query a single random quote.
    if (!query.exec("SELECT text, author FROM quotes ORDER BY RANDOM() LIMIT 1;")) {
        qWarning() << "Random query failed:" << query.lastError();
        return;
    }

    if (query.next()) {
        QString text = query.value(0).toString();
        QString author = query.value(1).toString();

        // Append the quote to our list.
        m_quotes.append(qMakePair(text, author));
        m_currentIndex = m_quotes.size() - 1;
        m_statusMessage = ""; // Clear any previous status.
        emit statusMessageChanged();
        emit currentQuoteChanged();
    } else {
        qWarning() << "No quote found in query.";
    }
}

void QuoteGenerate::nextQuote() {
    if (m_quotes.isEmpty())
        return;
    if (m_currentIndex < m_quotes.size() - 1) {
        m_currentIndex++;
        m_statusMessage = "";
        emit currentQuoteChanged();
        emit statusMessageChanged();
    } else {
        m_statusMessage = "This is the latest quote";
        emit statusMessageChanged();
    }
}

void QuoteGenerate::previousQuote() {
    if (m_quotes.isEmpty())
        return;
    if (m_currentIndex > 0) {
        m_currentIndex--;
        m_statusMessage = "";
        emit currentQuoteChanged();
        emit statusMessageChanged();
    } else {
        m_statusMessage = "This is the first quote";
        emit statusMessageChanged();
    }
}

void QuoteGenerate::copyQuote()
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    if (!clipboard) {
        qDebug() << "Clipboard is unavailable!";
        return;
    }

    QString quoteText = QString("%1\n— %2").arg(currentQuote(), currentAuthor());
    clipboard->setText(quoteText);

    qDebug() << "Copied to clipboard:" << quoteText;
}


void QuoteGenerate::initializeDatabase() {
    qDebug() << "Available SQL drivers:" << QSqlDatabase::drivers();

    QString sourcePath = ":/database/quotes.db";
    qDebug() << "Resource exists:" << QFile::exists(sourcePath);

    QString destDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString destPath = destDir + "/quotes.db";
    qDebug() << "Destination path:" << destPath;

    // Ensure the destination directory exists
    QDir dir(destDir);
    if (!dir.exists()) {
        if (!dir.mkpath(destDir)) {
            qDebug() << "Failed to create directory:" << destDir;
            return;
        }
    }

    // Copy the database if it doesn't exist
    if (!QFile::exists(destPath)) {
        QFile sourceFile(sourcePath);
        if (!sourceFile.copy(destPath)) {
            qDebug() << "Copy error:" << sourceFile.errorString();
            return;
        }
        QFile::setPermissions(destPath, QFile::ReadOwner | QFile::WriteOwner | QFile::ReadUser | QFile::WriteUser);
    }

    // Open database connection
    m_db = QSqlDatabase::addDatabase("QSQLITE","quotes_connection");
    m_db.setDatabaseName(destPath);
    if (!m_db.open()) {
        qDebug() << "Database open error:" << m_db.lastError().text();
        return;
    }

    // Perform an integrity check
    QSqlQuery query(m_db);
    if (!query.exec("PRAGMA quick_check")) {
        qDebug() << "Quick check failed:" << query.lastError().text();
    } else {
        qDebug() << "Database integrity check passed";
    }
}
