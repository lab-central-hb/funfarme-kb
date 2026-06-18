import gspread
from google.oauth2.service_account import Credentials
import json
import datetime
import os
import time
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Configuracoes
JSON_FOLDER = r"\\nti-102856\d$\santana\computadores\jsonData"
PROCESSED_FOLDER = os.path.join(JSON_FOLDER, "processed")
SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
CREDENTIALS_FILE = "inventario-funfarme-1e52ec7966d9.json"
SHEET_ID = "1hFr8GnZJa5JXlo-ideu_2wGC3_aIkaBcWWhCOOt88BI"

# Cria pastas se nao existirem
Path(JSON_FOLDER).mkdir(parents=True, exist_ok=True)
Path(PROCESSED_FOLDER).mkdir(parents=True, exist_ok=True)

# Inicializa Google Sheets
creds = Credentials.from_service_account_file(CREDENTIALS_FILE, scopes=SCOPES)
client = gspread.authorize(creds)
sheet = client.open_by_key(SHEET_ID).sheet1


def process_json_file(file_path):
    """Processa um arquivo JSON e envia para Google Sheets"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        row = [
            data.get("NTI", ""),
            data.get("IP", ""),
            data.get("Local", ""),
            data.get("CPU", ""),
            data.get("RAM", ""),
            data.get("Discos", ""),
            data.get("OS", ""),
            data.get("GPU", ""),
            data.get("Placamae", ""),
            data.get("MAC", "")
        ]
        
        sheet.append_row(row)
        
        # Move arquivo para pasta de processados
        filename = os.path.basename(file_path)
        processed_path = os.path.join(PROCESSED_FOLDER, filename)
        os.rename(file_path, processed_path)
        
        print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Dados enviados: {data.get('NTI', 'Unknown')}")
        return True
        
    except json.JSONDecodeError as e:
        print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Erro ao ler JSON {file_path}: {e}")
        return False
    except Exception as e:
        print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Erro ao processar {file_path}: {e}")
        return False


class JsonFileHandler(FileSystemEventHandler):
    """Handler para eventos de arquivos"""
    
    def on_created(self, event):
        if not event.is_directory and event.src_path.lower().endswith('.json'):
            # Aguarda um pouco para garantir que o arquivo foi completamente escrito
            time.sleep(0.5)
            if os.path.exists(event.src_path):
                process_json_file(event.src_path)
    
    def on_moved(self, event):
        if not event.is_directory and event.dest_path.lower().endswith('.json'):
            time.sleep(0.5)
            if os.path.exists(event.dest_path):
                process_json_file(event.dest_path)


def process_existing_files():
    """Processa arquivos JSON que ja existem na pasta"""
    json_files = [f for f in os.listdir(JSON_FOLDER) if f.lower().endswith('.json')]
    for filename in json_files:
        file_path = os.path.join(JSON_FOLDER, filename)
        if os.path.isfile(file_path):
            process_json_file(file_path)


if __name__ == "__main__":
    print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Iniciando monitoramento da pasta: {JSON_FOLDER}")
    print("Pressione Ctrl+C para parar o monitoramento\n")
    
    # Processa arquivos existentes
    process_existing_files()
    
    # Inicia monitoramento
    event_handler = JsonFileHandler()
    observer = Observer()
    observer.schedule(event_handler, JSON_FOLDER, recursive=False)
    observer.start()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print(f"\n[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Monitoramento interrompido.")
    
    observer.join()
