#!/bin/bash

EXT_DIR="$HOME/.vscode/extensions"
STORAGE_DIR="$HOME/.config/Code/User/globalStorage"
SETTINGS_FILE="$HOME/.config/Code/User/settings.json"

ACTIVE_EXTENSIONS=$(code --list-extensions)
REMOVIDAS=()

echo "🔹 Verificando extensões órfãs no VSCode..."

for ext_path in "$EXT_DIR"/*; do
    ext_name=$(basename "$ext_path")
    
    if ! echo "$ACTIVE_EXTENSIONS" | grep -q "^$ext_name"; then
        echo ""
        echo "🗑 Extensão órfã encontrada: $ext_name"
        read -p "Deseja remover esta extensão? (s/n) " RESP
        
        if [[ "$RESP" =~ ^[Ss]$ ]]; then
            # Remove pasta da extensão
            rm -rf "$ext_path"
            echo "   ✅ Pasta removida: $ext_path"
            
            # Remove dados no globalStorage
            storage_path="$STORAGE_DIR/$ext_name"
            if [ -d "$storage_path" ]; then
                rm -rf "$storage_path"
                echo "   ✅ GlobalStorage removido: $storage_path"
            fi

            REMOVIDAS+=("$ext_name")
        else
            echo "   ⏭ Pulando..."
        fi
    fi
done

# Abrir settings.json no VSCode para revisão
if [ ${#REMOVIDAS[@]} -gt 0 ]; then
    echo ""
    echo "⚠️ Extensões removidas: ${REMOVIDAS[*]}"
    echo "Abrindo $SETTINGS_FILE no VSCode para remover configurações relacionadas..."
    
    # Abre o arquivo no VSCode
    code "$SETTINGS_FILE"
else
    echo ""
    echo "✅ Nenhuma extensão órfã removida."
fi

echo ""
echo "🎯 Limpeza concluída!"
