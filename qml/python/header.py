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


SERVICE_SEARCH_FIELDS = "nextPageToken, files(*)"


GOOGLE_MIME_TYPES_CONVERT = {'application/vnd.google-apps.spreadsheet': 
        	('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '.xlsx'),
       	'application/vnd.google-apps.document': 
        	('application/vnd.openxmlformats-officedocument.wordprocessingml.document', '.docx'),
        'application/vnd.google-apps.presentation':
            ('application/pdf', '.pdf')
        }
