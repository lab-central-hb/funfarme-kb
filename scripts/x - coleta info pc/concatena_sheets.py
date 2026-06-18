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
JSON_FOLDER = r"\\nti-102856\d$\santana\funfarme-kb\scripts\x - coleta info pc\jsonData"
PROCESSED_FOLDER = os.path.join(JSON_FOLDER, "processed")
SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
CREDENTIALS_FILE = "inventario-funfarme-1e52ec7966d9.json"
SHEET_ID = "1hFr8GnZJa5JXlo-ideu_2wGC3_aIkaBcWWhCOOt88BI"

# Obtem o diretorio do script para encontrar o arquivo de credenciais
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CREDENTIALS_PATH = os.path.join(SCRIPT_DIR, CREDENTIALS_FILE)

# Cria pastas se nao existirem
try:
    Path(JSON_FOLDER).mkdir(parents=True, exist_ok=True)
    Path(PROCESSED_FOLDER).mkdir(parents=True, exist_ok=True)
except Exception as e:
    print(f"[ERRO] Nao foi possivel criar as pastas: {e}")
    print(f"Verifique se o caminho {JSON_FOLDER} esta acessivel.")
    exit(1)

# Inicializa Google Sheets
try:
    if not os.path.exists(CREDENTIALS_PATH):
        print(f"[ERRO] Arquivo de credenciais nao encontrado: {CREDENTIALS_PATH}")
        exit(1)
    
    creds = Credentials.from_service_account_file(CREDENTIALS_PATH, scopes=SCOPES)
    client = gspread.authorize(creds)
    sheet = client.open_by_key(SHEET_ID).sheet1
    print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Conectado ao Google Sheets com sucesso")
except Exception as e:
    print(f"[ERRO] Falha ao conectar ao Google Sheets: {e}")
    exit(1)


def process_json_file(file_path):
    """Processa um arquivo JSON e envia para Google Sheets"""
    try:
        # Verifica se o arquivo existe e nao esta sendo usado
        if not os.path.exists(file_path):
            return False
        
        # Tenta ler o arquivo (utf-8-sig remove automaticamente o BOM se presente)
        max_retries = 3
        for attempt in range(max_retries):
            try:
                with open(file_path, 'r', encoding='utf-8-sig') as f:
                    data = json.load(f)
                break
            except (json.JSONDecodeError, IOError) as e:
                if attempt < max_retries - 1:
                    time.sleep(0.5)
                    continue
                else:
                    raise
        
        # Valida que os campos necessarios existem
        required_fields = ["NTI", "IP", "Patrimonio", "Entidade", "Local", "CPU", "RAM", "Discos", "OS", "GPU", "Placamae", "MAC"]
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            print(f"[AVISO] Arquivo {os.path.basename(file_path)} esta faltando campos: {', '.join(missing_fields)}")
        
        # Prepara a linha na ordem correta: NTI, IP, Local, CPU, RAM, Discos, OS, GPU, Placamae, MAC
        row = [
            str(data.get("NTI", "")),
            str(data.get("IP", "")),
            str(data.get("Patrimonio", "")),
            str(data.get("Entidade", "")),
            str(data.get("Local", "")),
            str(data.get("CPU", "")),
            str(data.get("RAM", "")),
            str(data.get("Discos", "")),
            str(data.get("OS", "")),
            str(data.get("GPU", "")),
            str(data.get("Placamae", "")),
            str(data.get("MAC", ""))
        ]
        
        # Envia para Google Sheets
        sheet.insert_row(row, 2)
        
        # Move arquivo para pasta de processados
        try:
            filename = os.path.basename(file_path)
            processed_path = os.path.join(PROCESSED_FOLDER, filename)
            
            # Se o arquivo processado ja existe, adiciona timestamp
            if os.path.exists(processed_path):
                name, ext = os.path.splitext(filename)
                timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
                processed_path = os.path.join(PROCESSED_FOLDER, f"{name}_{timestamp}{ext}")
            
            os.rename(file_path, processed_path)
        except Exception as e:
            print(f"[AVISO] Nao foi possivel mover arquivo {file_path} para processados: {e}")
            # Tenta deletar o arquivo se nao conseguir mover
            try:
                os.remove(file_path)
            except:
                pass
        
        print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Dados enviados com sucesso: {data.get('NTI', 'Unknown')}")
        return True
        
    except json.JSONDecodeError as e:
        print(f"[ERRO] JSON invalido em {file_path}: {e}")
        # Move arquivo com erro para uma pasta de erros
        try:
            error_folder = os.path.join(JSON_FOLDER, "errors")
            Path(error_folder).mkdir(parents=True, exist_ok=True)
            error_path = os.path.join(error_folder, os.path.basename(file_path))
            if os.path.exists(file_path):
                os.rename(file_path, error_path)
        except:
            pass
        return False
    except Exception as e:
        print(f"[ERRO] Erro ao processar {file_path}: {e}")
        import traceback
        traceback.print_exc()
        return False


class JsonFileHandler(FileSystemEventHandler):
    """Handler para eventos de arquivos"""
    
    def __init__(self):
        self.processing = set()  # Evita processar o mesmo arquivo multiplas vezes
    
    def on_created(self, event):
        if not event.is_directory and event.src_path.lower().endswith('.json'):
            file_path = os.path.normpath(event.src_path)
            if file_path not in self.processing:
                self.processing.add(file_path)
                # Aguarda um pouco para garantir que o arquivo foi completamente escrito
                time.sleep(1)
                if os.path.exists(file_path):
                    process_json_file(file_path)
                self.processing.discard(file_path)
    
    def on_moved(self, event):
        if not event.is_directory and event.dest_path.lower().endswith('.json'):
            file_path = os.path.normpath(event.dest_path)
            if file_path not in self.processing:
                self.processing.add(file_path)
                time.sleep(1)
                if os.path.exists(file_path):
                    process_json_file(file_path)
                self.processing.discard(file_path)


def process_existing_files():
    """Processa arquivos JSON que ja existem na pasta"""
    try:
        if not os.path.exists(JSON_FOLDER):
            print(f"[AVISO] Pasta {JSON_FOLDER} nao existe ainda")
            return
        
        json_files = [f for f in os.listdir(JSON_FOLDER) 
                     if f.lower().endswith('.json') and os.path.isfile(os.path.join(JSON_FOLDER, f))]
        
        if json_files:
            print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Encontrados {len(json_files)} arquivo(s) pendente(s) para processar")
            for filename in json_files:
                file_path = os.path.join(JSON_FOLDER, filename)
                process_json_file(file_path)
        else:
            print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Nenhum arquivo pendente encontrado")
    except Exception as e:
        print(f"[ERRO] Erro ao processar arquivos existentes: {e}")


if __name__ == "__main__":
    print("=" * 60)
    print("MONITOR DE COLETA DE INFORMACOES DE PC")
    print("=" * 60)
    print(f"[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Iniciando monitoramento da pasta: {JSON_FOLDER}")
    print("Pressione Ctrl+C para parar o monitoramento\n")
    
    # Processa arquivos existentes
    process_existing_files()
    
    # Inicia monitoramento
    try:
        event_handler = JsonFileHandler()
        observer = Observer()
        observer.schedule(event_handler, JSON_FOLDER, recursive=False)
        observer.start()
        
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print(f"\n[{datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')}] Monitoramento interrompido pelo usuario.")
    except Exception as e:
        print(f"\n[ERRO FATAL] {e}")
        import traceback
        traceback.print_exc()
    finally:
        try:
            observer.join()
        except:
            pass