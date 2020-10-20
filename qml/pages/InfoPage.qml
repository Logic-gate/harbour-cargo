/* FILE-MANGER */


import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "../python"
import "../components"
import "../components/MimeTypeSwitcher.js" as MimeTypeIconSwitcher
import "../components/GeneralUseFunctions.js" as Functions

Page {
    id: page
    allowedOrientations: Orientation.All

    property string file: "/"

    property var fileId
    property var fileName
    property var fileDescription
    property var fileSize
    property var fileModifiedTime
    property var fileMimeType
    property var fileCreatedTime
    property var fileWebViewLink
    property var fileIconLink
    property var fileHasThumbnail
    //this will show true for google docs.
    property var fileThumbnailLink

    function fixGoogleDocsNoThumbnails(fileThumbnailLink) {

        /*
        There is an issue with thumbnails for Goolge documents, 'server reply Not found'.
        One way to fix this is to export the document as SUPPORTED_EXT, fetch the thumbnail of that
        EXT, then delete the EXT. This is by no means the way I want to solve this. Until then,
        this soultion works.
        */
        if (fileHasThumbnail && fileThumbnailLink.search(
                    'https://docs.google.com/') !== -1) {
            return false
        } else if (fileHasThumbnail) {
            return true
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        VerticalScrollDecorator {
            flickable: flickable
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Download")
                onClicked: {
                    py.download(fileId)
                }
            }

            MenuItem {
                text: qsTr("Open")
                onClicked: {
                    console.log(fileWebViewLink)
                    Qt.openUrlExternally(fileWebViewLink)
                }
            }
        }

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                title: fileName
            }

            Column {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x

                Image {
                    id: thumbNail
                    cache: true
                    asynchronous: true
                    source: fixGoogleDocsNoThumbnails(
                                fileThumbnailLink) ? Functions.retinaIconLink(
                                                         fileThumbnailLink,
                                                         '=s220',
                                                         '=s1000') : Functions.retinaIconLink(
                                                         fileIconLink,
                                                         '/16/', '/256/')
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DetailItem {
                    label: qsTr("Name")
                    value: fileName
                }
                DetailItem {
                    label: qsTr("Size")
                    value: Format.formatFileSize(fileSize)
                }
                DetailItem {
                    label: qsTr("Type")
                    value: fileMimeType
                }
                DetailItem {
                    label: qsTr("id")
                    value: fileId
                }
                DetailItem {
                    id: _fileDescription
                    label: qsTr("Descpriction")
                    value: fileDescription ? fileDescription : _fileDescription.visible = false
                }
                DetailItem {
                    id: _fileModifiedTime
                    label: qsTr("Last Modified")
                    value: fileModifiedTime ? fileModifiedTime : _fileModifiedTime.visible = false
                }
                DetailItem {
                    id: _fileCreatedTime
                    label: qsTr("Created On")
                    value: fileCreatedTime ? fileCreatedTime : _fileCreatedTime.visible = false
                }
            }
        }

        AppNotification {
            id: imageNotification
        }
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))
            setHandler('download_status', function (res) {
                if (res === 100) {
                    imageNotification.show(qsTr("Download Complete!"));
                } else {
                    imageNotification.show(qsTr("Download Failed!"));
                }
            })
            importModule('main', function () {})
        }


        function download(id) {
            call('main.api.download', [id], function () {})
        }
    }
}
