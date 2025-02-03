#ifndef QUOTESLOADER_H
#define QUOTESLOADER_H

#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QRandomGenerator>
#include <QDebug>

class QuotesLoader : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString randomQuote READ getRandomQuote NOTIFY quoteChanged)

public:
    explicit QuotesLoader(QObject *parent = nullptr) {
        loadQuotes();
    }

    QString getRandomQuote() {
        if (quotes.isEmpty()) return "No quotes found.";
        int index = QRandomGenerator::global()->bounded(quotes.size());
        emit quoteChanged();  // Emit signal when a new quote is generated
        return quotes.at(index);
    }

signals:
    void quoteChanged();

private:
    QStringList quotes;

    void loadQuotes() {
        QFile file(":/json/quotes.json");  // Use the correct path for the resource
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning() << "Failed to open quotes.json";
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        if (doc.isNull()) {
            qWarning() << "Failed to parse JSON.";
            return;
        }

        QJsonObject obj = doc.object();
        QJsonArray arr = obj["quotes"].toArray();
        for (const auto &q : arr) {
            QJsonObject quoteObj = q.toObject();
            QString formattedQuote = "\"" + quoteObj["text"].toString() + "\" - " + quoteObj["from"].toString();
            quotes.append(formattedQuote);
        }
        file.close();
    }
};

#endif // QUOTESLOADER_H
