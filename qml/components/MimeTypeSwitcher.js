//Thank you Michal--mimtType switch case from nanoFiles

function mimeTypeIcon(mimeType, colorScheme) {

    var type = mimeType.split("/")[0]
    var icon = ""

    switch (type) {
    case "audio":
        icon = "image://theme/icon-m-file-audio"
        break
    case "image":
        icon = "image://theme/icon-m-file-image"
        break
    case "video":
        icon = "image://theme/icon-m-file-video"
        break
    default:
        icon = "image://theme/icon-m-file-document-dark"
    }

    switch (mimeType) {
    case "application/pdf":
        icon = "image://theme/icon-m-file-pdf-dark"
        break
    case "application/vnd.ms-excel":
    case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
    case "application/vnd.oasis.opendocument.spreadsheet":
    case "application/vnd.google-apps.spreadsheet":
        icon = "image://theme/icon-m-file-spreadsheet-dark"
        break
    case "application/vnd.ms-powerpoint":
    case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
    case "application/vnd.oasis.opendocument.presentation":
    case "application/vnd.google-apps.presentation":
        icon = "image://theme/icon-m-file-presentation-dark"
        break
    case "application/msword":
    case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
    case "application/vnd.oasis.opendocument.text":
    case "application/vnd.google-apps.document":
        icon = "image://theme/icon-m-file-formatted-dark"
        break
    case "application/x-rar-compressed":
    case "application/zip":
    case "application/x-tar":
    case "application/x-bzip":
    case "application/x-bzip2":
    case "application/gzip":
    case "application/x-7z-compressed":
    case "application/x-lzma":
    case "application/x-xz":
        icon = "image://theme/icon-m-file-archive-folder"
        break
    case "application/vnd.android.package-archive":
        icon = "image://theme/icon-m-file-apk"
        break
    case "application/x-rpm":
        icon = "image://theme/icon-m-file-rpm"
        break
    }

    if (colorScheme){
        return icon.replace('-dark', '-light')
    }
    else {
        return icon
    }

}
