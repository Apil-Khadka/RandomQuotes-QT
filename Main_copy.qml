import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 500
    height: 400
    title: "Random Quote Generator"

    // Theme properties
    property bool isDarkMode: false
    property color textColor: isDarkMode ? "#ffffff" : "#333333"
    property color backgroundColor: isDarkMode ? "#2d2d2d" : "#f5f5f5"
    property color buttonColor: isDarkMode ? "#404040" : "#e0e0e0"
    property color hoverColor: isDarkMode ? "#505050" : "#d0d0d0"

    // Font properties
    property string selectedFont: "Arial"
    property int fontSize: 20

    color: backgroundColor

    Column {
        id: mainColumn
        spacing: 20
        anchors {
            fill: parent
            margins: 20
        }

        Rectangle {
            id: quoteContainer
            width: parent.width
            height: parent.height * 0.6
            color: isDarkMode ? "#3d3d3d" : "#ffffff"
            radius: 10
            border.color: isDarkMode ? "#555555" : "#cccccc"
            border.width: 1

            Text {
                id: quoteText
                text: quoteGen.currentQuote
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
                font {
                    family: selectedFont
                    pixelSize: fontSize
                }
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.9
            }
        }

        Text {
            id: authorText
            text: "- " + quoteGen.currentAuthor
            font {
                family: selectedFont
                pixelSize: fontSize * 0.8
            }
            color: textColor
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Text {
            id: statusText
            text: quoteGen.statusMessage
            color: "red"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            opacity: quoteGen.statusMessage !== "" ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "←"
                ToolTip.visible: hovered
                ToolTip.text: "Previous quote"
                onClicked: quoteGen.previousQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }

            Button {
                text: "Generate"
                ToolTip.visible: hovered
                ToolTip.text: "Generate new random quote"
                onClicked: quoteGen.generateQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }

            Button {
                text: "→"
                ToolTip.visible: hovered
                ToolTip.text: "Next quote"
                onClicked: quoteGen.nextQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "⚙"
                ToolTip.visible: hovered
                ToolTip.text: "Settings"
                onClicked: settingsPopup.open()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }

            Button {
                text: isDarkMode ? "☀" : "🌙"
                ToolTip.visible: hovered
                ToolTip.text: "Toggle dark mode"
                onClicked: isDarkMode = !isDarkMode
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
            Button {
                text: "©"
                ToolTip.visible: hovered
                ToolTip.text: "Copy Quote"
                onClicked: quoteGen.copyQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
        }
    }

    Popup {
        id: settingsPopup
        width: 200
        height: 150
        anchors.centerIn: parent
        modal: true
        dim: true

        background: Rectangle {
            color: isDarkMode ? "#3d3d3d" : "#ffffff"
            border.color: isDarkMode ? "#555555" : "#cccccc"
            radius: 5
        }

        Column {
            spacing: 10
            anchors.fill: parent
            padding: 10

            Label {
                text: "Font Size"
                color: textColor
            }

            Slider {
                width: parent.width
                from: 16
                to: 32
                value: fontSize
                onValueChanged: fontSize = value
                background: Rectangle {
                    color: isDarkMode ? "#505050" : "#e0e0e0"
                    height: 4
                    radius: 2
                }
            }

            Label {
                text: "Font Family"
                color: textColor
            }

            ComboBox {
                width: parent.width
                model: Qt.fontFamilies()
                currentIndex: model.indexOf(selectedFont)
                onActivated: selectedFont = model[index]
                background: Rectangle {
                    color: buttonColor
                    radius: 5
                }
            }
        }
    }

    // Responsive behavior
    onWidthChanged: updateLayout()
    onHeightChanged: updateLayout()

    function updateLayout() {
        var baseSize = Math.min(width, height) * 0.04
        fontSize = baseSize
        mainColumn.spacing = baseSize * 0.5
    }
}
