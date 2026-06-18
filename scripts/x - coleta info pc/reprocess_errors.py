"""
Script para reprocessar arquivos que estao na pasta de erros
Apos corrigir o problema do BOM, este script pode reprocessar os arquivos
"""
import os
from pathlib import Path
from concatena_sheets import process_json_file, JSON_FOLDER

ERROR_FOLDER = os.path.join(JSON_FOLDER, "errors")

def reprocess_error_files():
    """Reprocessa arquivos da pasta de erros"""
    if not os.path.exists(ERROR_FOLDER):
        print(f"Pasta de erros nao existe: {ERROR_FOLDER}")
        return
    
    error_files = [f for f in os.listdir(ERROR_FOLDER) 
                   if f.lower().endswith('.json') and os.path.isfile(os.path.join(ERROR_FOLDER, f))]
    
    if not error_files:
        print("Nenhum arquivo de erro encontrado para reprocessar.")
        return
    
    print(f"Encontrados {len(error_files)} arquivo(s) de erro para reprocessar.\n")
    
    # Move arquivos de volta para a pasta principal para processamento
    for filename in error_files:
        error_path = os.path.join(ERROR_FOLDER, filename)
        main_path = os.path.join(JSON_FOLDER, filename)
        
        try:
            # Move de volta para a pasta principal
            os.rename(error_path, main_path)
            print(f"Movido: {filename}")
            
            # Processa o arquivo
            if process_json_file(main_path):
                print(f"  ✓ Processado com sucesso: {filename}\n")
            else:
                print(f"  ✗ Falha ao processar: {filename}\n")
        except Exception as e:
            print(f"  ✗ Erro ao processar {filename}: {e}\n")

if __name__ == "__main__":
    print("=" * 60)
    print("REPROCESSAMENTO DE ARQUIVOS COM ERRO")
    print("=" * 60)
    print()
    reprocess_error_files()
    print("=" * 60)
    print("Concluido!")



