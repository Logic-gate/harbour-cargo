import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4

import "../python"
import "../components"

Page {
      id: pickerPage
      property string selectedFile
      property var uploadStatusLoading
      property bool loaded: true

      ValueButton {
          id: filePickerButton
          anchors {
              horizontalCenter: parent.horizontalCenter
          }
          label:  qsTr("File")
          description: qsTr("Select a file to upload!")
          value: selectedFile ? selectedFile : "None"
          onClicked: pageStack.push(filePickerPage)
      }

      Component {
          id: filePickerPage
          FilePickerPage {
              onSelectedContentPropertiesChanged: {
                  page.selectedFile = selectedContentProperties.fileName
                  loaded = false
                  py.upload(selectedContentProperties.filePath, selectedContentProperties.mimeType, selectedContentProperties.fileName)
              }
          }
      }

      AppNotification {
          id: imageNotification
      }

      LoadingIndicator {
          id: loading
          visible: !loaded
          Behavior on opacity {
              NumberAnimation {
              }
          }
          opacity: loaded ? 0 : 1
          height: parent.height
          width: parent.width
      }

      Python {
          id: py
          Component.onCompleted: {
              addImportPath(Qt.resolvedUrl('../python'))
              setHandler('upload_status', function (res) {
                  if (res === 110) {
                      imageNotification.show(qsTr("Upload Complete!"));
                      loaded = true;
                      filePickerButton.description = qsTr("File Uploaded!")
                  }
                  else {
                      imageNotification.show(qsTr("Upload Failed!"));
                      loaded = true;
                  }
              })

              importModule('main', function () {})
          }

          function upload(file, mimetype, fileName) {
              call('main.api.upload', [file, mimetype, fileName], function () {})
          }

      }
}
