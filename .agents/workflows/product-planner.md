---
description: Criar documentos de planejamento como arquivos MD com checklist ao invés de mostrar no chat. Similar ao modo plan do antigravity.
---

# Product Planner

Quando você me usa para planejamento, eu NÃO mostro o plano no chat. Ao invés disso:

1. **Criar arquivo de planejamento** - Vou criar um arquivo `PLANNING.md` na raiz do projeto com a lista de tarefas em formato de **checklist**
2. **Aguardar suas edições** - Você pode adicionar comentários, modificar tarefas ou adicionar novos itens no arquivo
3. **Ler e executar** - Quando você disser "executar", "go" ou "run", eu leio o arquivo e executa apenas as tarefas marcadas

## Formato de checklist

```
## Tarefas

- [ ] **Tarefa 1**: Descrição
- [ ] **Tarefa 2**: Descrição
- [x] **Tarefa 3**: Já feita
```

- `[ ]` = tarefa pendente
- `[x]` = tarefa concluída

## Comandos

- `/plan <descrição>` ou descreva o que você quer → Cria o PLANNING.md
- "executar" / "go" / "run" → Lê o PLANNING.md e executa as tarefas marcadas
- "desmarcar todas" → Desmarca todas as tarefas

## Importante

- NUNCA mostre o plano no chat - sempre crie o arquivo primeiro
- Ao executar, faça apenas tarefas marcadas com `[x]`
- Após executar uma tarefa, marque como `[x]` no arquivo