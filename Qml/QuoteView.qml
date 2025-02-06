import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "Util.js" as Util

Rectangle {
    id: quoteviewwindow
    visible: true
    width: parent.width
    height: parent.height

    // ---------------------------
    // Appearance & Mode Settings
    // ---------------------------
    property bool isDarkMode: false
    property color backgroundColor: isDarkMode ? "#263238" : "#E8F5E9"
    property color cardColor: isDarkMode ? "#37474F" : "#FFFFFF"
    property color borderColor: isDarkMode ? "#78909C" : "#B0BEC5"
    property color accentColor: isDarkMode ? "#66BB6A" : "#43A047"
    property color buttonColor: isDarkMode ? "#558B2F" : "#8BC34A"
    property color hoverColor: isDarkMode ? "#689F38" : "#AED581"

    // ---------------------------
    // Text & Font Settings
    // ---------------------------
    property string selectedTextColorName: "Default"
    property var colorMapping: ({
        "Crimson": "#DC143C",
        "Royal Blue": "#4169E1",
        "Forest Green": "#228B22",
        "Goldenrod": "#DAA520"
    })
    property color userTextColor: selectedTextColorName === "Default" ?
        (isDarkMode ? "#C8E6C9" : "#388E3C") : colorMapping[selectedTextColorName]

    property string selectedFont: "Default"
    property int fontSize: 18

    Column {
        id: mainColumn
        spacing: 20
        anchors.fill: parent
        anchors.margins: 20

        // ---------------------------
        // Quote Container
        // ---------------------------
        Rectangle {
            id: quoteContainer
            width: parent.width
            height: parent.height * 0.6
            radius: 10
            color: cardColor
            border.width: 1
            border.color: borderColor

            Text {
                id: quoteText
                text: quoteGen.currentQuote
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
                font.family: selectedFont === "Default" ? Qt.application.font.family : selectedFont
                font.pixelSize: fontSize
                color: userTextColor
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.9
            }
            Text {
                id: authorText
                text: quoteGen.currentAuthor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: quoteText.top
                anchors.bottomMargin: 10
                font.family: selectedFont === "Default" ? Qt.application.font.family : selectedFont
                font.pixelSize: fontSize * 0.8
                color: userTextColor
            }

            // ---------------------------
            // Copy-to-Clipboard Button
            // ---------------------------
            Button {
                id: copyButton
                text: "📋"
                // width: parent.width / 20
                // height: parent.height / 20
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 10
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
                onClicked: {
                    if (quoteGen.copyQuote)
                        quoteGen.copyQuote();
                    copiedMessage.visible = true
                    copyMessageTimer.restart()
                }
            }
        }
        // ---------------------------
        // Author & Status Text
        // ---------------------------

        Text {
            id: statusText
            text: quoteGen.statusMessage   // Ensure quoteGen.statusMessage exists.
            color: "red"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            opacity: quoteGen.statusMessage !== "" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        // ---------------------------
        // Navigation Row
        // ---------------------------
        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "←"
                onClicked: quoteGen.previousQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
            Button {
                text: "Generate"
                onClicked: quoteGen.generateQuote()
                background: Rectangle {
                    color: parent.hovered ? Qt.lighter(accentColor, 1.2) : accentColor
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Button {
                text: "→"
                onClicked: quoteGen.nextQuote()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
        }

        // ---------------------------
        // Bottom Row: Settings & Dark Mode
        // ---------------------------
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "⚙"
                onClicked: settingsPopup.open()
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
            }
            Button {
                text: isDarkMode ? "☀" : "🌙"
                background: Rectangle {
                    color: parent.hovered ? hoverColor : buttonColor
                    radius: 5
                }
                onClicked: isDarkMode = !isDarkMode
            }
        }
    }

    // ---------------------------
      // Settings Popup (Improved Layout)
      // ---------------------------
      Popup {
          id: settingsPopup
          modal: true
          focus: true
          // Make popup larger: at least 300x350, scaling with window size.
          width: Math.max(300, quoteviewwindow.width * 0.5)
          height: Math.max(350, quoteviewwindow.height * 0.6)
          anchors.centerIn: parent
          background: Rectangle {
              radius: 10
              color: cardColor
              border.color: borderColor
              border.width: 2
          }
          contentItem: ColumnLayout {
              anchors.fill: parent
              anchors.margins: 20
              spacing: 20

              Label {
                  text: "Settings"
                  font.pixelSize: fontSize * 1.2
                  horizontalAlignment: Text.AlignHCenter
                  color: userTextColor
                  Layout.alignment: Qt.AlignHCenter
              }

              RowLayout {
                  spacing: 10
                  Layout.fillWidth: true

                  Label {
                      text: "Font Size:"
                      font.pixelSize: fontSize
                      color: userTextColor
                      Layout.preferredWidth: 100
                  }
                  TextField {
                      id: fontSizeField
                      text: fontSize.toString()
                      Layout.fillWidth: true
                      // Allow digits only (may vary based on platform)
                      inputMethodHints: Qt.ImhDigitsOnly
                      onEditingFinished: {
                          var newValue = parseInt(text)
                          if (!isNaN(newValue) && newValue >= 11 && newValue <= 32) {
                              fontSize = newValue
                          } else {
                              // If the input is invalid, revert to the current fontSize value.
                              text = fontSize.toString()
                          }
                      }
                  }
              }

              RowLayout {
                  spacing: 20
                  Layout.fillWidth: true

                  Label {
                      text: "Text Color:"
                      font.pixelSize: fontSize
                      color: userTextColor
                      Layout.preferredWidth: 100
                  }
                  ComboBox {
                      id: textColorCombo
                      Layout.fillWidth: true
                      model: [ "Default", "Crimson", "Royal Blue", "Forest Green", "Goldenrod" ]
                      currentIndex: 0
                      onActivated: function(index) {
                          selectedTextColorName = model[index];
                          userTextColor = selectedTextColorName === "Default" ?
                              (isDarkMode ? "#C8E6C9" : "#388E3C") : colorMapping[selectedTextColorName];
                      }
                      contentItem: Text {
                          text: parent.displayText
                          color: userTextColor
                          font.pixelSize: fontSize
                          verticalAlignment: Text.AlignVCenter
                          leftPadding: 10
                      }
                      background: Rectangle {
                          color: buttonColor
                          radius: 5
                          border.color: borderColor
                          border.width: 1
                      }
                      popup: Popup {
                          y: textColorCombo.height
                          width: textColorCombo.width
                          implicitHeight: contentItem.implicitHeight
                          padding: 1

                          contentItem: ListView {
                              clip: true
                              implicitHeight: contentHeight
                              model: textColorCombo.popup.visible ? textColorCombo.delegateModel : null
                              currentIndex: textColorCombo.highlightedIndex
                              ScrollIndicator.vertical: ScrollIndicator { }
                          }

                          background: Rectangle {
                              color: cardColor
                              border.color: borderColor
                              radius: 5
                          }
                      }
                      delegate: ItemDelegate {
                          width: textColorCombo.width
                          height: textColorCombo.height
                          highlighted: textColorCombo.highlightedIndex === index

                          contentItem: Text {
                              text: modelData
                              color: userTextColor
                              font.pixelSize: fontSize
                              elide: Text.ElideRight
                              verticalAlignment: Text.AlignVCenter
                              leftPadding: 10
                          }

                          background: Rectangle {
                              color: highlighted ? hoverColor : "transparent"
                              radius: 5
                          }
                      }
                  }
              }

              // Close button for the settings popup.
              Button {
                  text: "Close Settings"
                  Layout.alignment: Qt.AlignHCenter
                  onClicked: settingsPopup.close()
                  background: Rectangle {
                      color: parent.hovered ? hoverColor : accentColor
                      radius: 5
                  }
                  font.pixelSize: fontSize
              }
          }
      }


    // ---------------------------
    // "Copied to Clipboard" Message
    // ---------------------------
    Rectangle {
        id: copiedMessage
        visible: false
        width: 220
        height: 40
        radius: 5
        color: "#00000080"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        Text {
            text: "Copied to clipboard"
            color: "cyan"
            anchors.centerIn: parent
        }
    }
    Timer {
        id: copyMessageTimer
        interval: 2000
        onTriggered: copiedMessage.visible = false
    }
}
