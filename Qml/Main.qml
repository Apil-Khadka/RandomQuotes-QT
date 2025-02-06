// pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls 2.15
ApplicationWindow {
    id: mainwindow
    width: 600
    height: 500
    visible: true
    title: qsTr("QuoteGenerator")

    InitScreen {
        id: initview
        anchors.fill: parent
        onClicked: {
            quoteview.visible = true
            initview.visible = false
        }
    }

    QuoteView {
        id: quoteview
        anchors.fill: parent
        visible: false
    }
}
