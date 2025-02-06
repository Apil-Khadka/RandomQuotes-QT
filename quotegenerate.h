#ifndef QUOTEGENERATE_H
#define QUOTEGENERATE_H

#include <QObject>
#include <QList>
#include <QPair>
#include <QString>
#include <QSqlDatabase>

class QuoteGenerate : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentQuote READ currentQuote NOTIFY currentQuoteChanged)
    Q_PROPERTY(QString currentAuthor READ currentAuthor NOTIFY currentQuoteChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)

public:
    explicit QuoteGenerate(QObject *parent = nullptr);

    QString currentQuote() const;
    QString currentAuthor() const;
    QString statusMessage() const;

    Q_INVOKABLE void generateQuote();
    Q_INVOKABLE void nextQuote();
    Q_INVOKABLE void previousQuote();
    Q_INVOKABLE void copyQuote();

signals:
    void currentQuoteChanged();
    void statusMessageChanged();

private:
    void initializeDatabase();

    // List storing quotes as (text, author) pairs.
    QList<QPair<QString, QString>> m_quotes;
    int m_currentIndex;

    // Persistent database connection.
    QSqlDatabase m_db;

    // Status message shown when trying to navigate past boundaries.
    QString m_statusMessage;
};

#endif // QUOTEGENERATE_H
