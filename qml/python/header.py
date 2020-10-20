import os

MAIN_PATH = '/usr/share/harbour-cargo/qml/creds/'
CONFIG_PATH = '/home/nemo/.config/harbour-cargo/'
TOKEN_FILE = 'token.pickle'
CLIENT_ID_FILE = 'client_id.json'
CONFIG_FILE = 'config'
DOWNLOAD_PATH = '/home/nemo/Downloads/Cargo/'

DEFAULT_CONFIG = "iconSet=[silicaIconSet]\npageSize=[25]"

SCOPES = [
    'https://www.googleapis.com/auth/drive.metadata.readonly',
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/drive.appdata',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.metadata',
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.photos.readonly'
    ]


SERVICE_SEARCH_FIELDS = "nextPageToken, files(id, name, mimeType, description, size, modifiedTime, createdTime, webViewLink, iconLink, hasThumbnail, thumbnailLink)"


GOOGLE_MIME_TYPES_CONVERT = {'application/vnd.google-apps.spreadsheet': 
        	('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '.xlsx'),
       	'application/vnd.google-apps.document': 
        	('application/vnd.openxmlformats-officedocument.wordprocessingml.document', '.docx'),
        'application/vnd.google-apps.presentation':
            ('application/pdf', '.pdf')
        }

DOWNLOAD_TYPES = {'mp4', 'mp3', 'pdf', 'jpg',
              'jpeg', 'png', 'xml', 'json',
               'x-redhat-package-manager', 'plain', 'gif', 'vnd.ms-excel',
               'vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'xml',
               'zip', 'x-7z-compressed', 'csv', 'bin', 'gz', 'svg+xml', 'aac', 'html', 'x-tar'
               'tiff', 'ttf', 'wav', 'x-sh', 'vnd.rar'
               }
