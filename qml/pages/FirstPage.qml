/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "../python"

Page {
    id: mainPage
    allowedOrientations: Orientation.All
    focus: true
    Component.onCompleted: {
        python.checkToken()
    }

    SilicaFlickable {
        id: mainContainer
        contentHeight: mainView.height
        anchors.fill: parent
        visible: true
        opacity: 100

        Column {
            id: mainView
            width: mainPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Cargo, A Google Drive Client")
            }

            Image {
                id: cargoImage
                source: "../../res/images/harbour-cargo-big.png"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                fillMode: Image.PreserveAspectFit
                width: 1 / 2 * parent.width
            }

            Label {
                text: qsTr("Welcome to Cargo")
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: mainLabel
                text: qsTr("Cargo is a Google drive client for sailfish OS. All materials pertaining to Google are the sole property of Google Inc, Alphabet Inc.")
                x: Theme.horizontalPageMargin
                visible: false
                width: parent.width - (2 * Theme.horizontalPageMargin)
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Button {
                id: processCode
                text: qsTr("Process Code")
                visible: false
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: {
                    python.process_token(codeField.text)
                    processCode.visible = false
                    codeField.visible = false
                    loading_.visible = true
                    loading_main.visible = true
                    mainLabel.text = qsTr("Please wait while stuff happens...")
                }
            }

            Button {
                id: generateLink
                text: qsTr("Generate Link")
                visible: false
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: {
                    python.creds()
                    logIn.visible = true
                    generateLink.visible = false
                    mainLabel.text = qsTr("Login to Google and paste the code!")
                    mainLabel.horizontalAlignment = Text.AlignHCenter
                }
            }

            Button {
                id: logIn
                text: qsTr("Login to Google")
                visible: false
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: {
                    Qt.openUrlExternally(apires.text)
                    codeField.visible = true
                    logIn.visible = false
                    generateLink.visible = false
                    processCode.visible = true
                }
            }

            Label {
                id: apires
                visible: false
                x: Theme.horizontalPageMargin
                width: parent.width - (2 * Theme.horizontalPageMargin)
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                linkColor: Theme.highlightColor
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }
            TextField {
                id: codeField
                visible: false
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - 4 * Theme.paddingLarge
                horizontalAlignment: TextInput.AlignHCenter
            }

            InfoLabel {
                id: loading_
                visible: false
                text: qsTr("Generating Pickle...")
            }

            BusyIndicator {
                id: loading_main
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
                size: BusyIndicatorSize.Large
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))

            setHandler('authUrl', function (res) {
                apires.text = res
            })
            setHandler('code', function (code) {
                if (code === 1) {
                    generateLink.visible = false
                    mainLabel.visible = false
                    loading_.visible = true
                    loading_main.running = true
                    loading_main.visible = true
                    loading_.text = qsTr('Logging in...')
                    logIn.visible = false
                }
                else if(code === 2)
                {
                    generateLink.visible = true
                    mainLabel.visible = true

                }
            })

            setHandler('mover', function (code) {
                if (code === 2) {
                    loading_.visible = false
                    loading_main.visible = false
                    loading_main.running = false
                    generateLink.visible = false
                    pageStack.replace('ListPage.qml')
                }
            })

            setHandler('status', function (code) {
                loading_.text = code
            })

            importModule('main', function () {})
        }

        function checkToken() {
            call('main.api.credentialsCheckToken', function () {})
        }

        function creds() {
            call('main.api.credentialsCheck', function () {})
        }

        function process_token(token) {
            call('main.api.processToken', [token], function () {})
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback)
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data)
        }
    }
}
