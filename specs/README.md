# Especificações

Cada iniciativa vive em `specs/NNN-slug/` e contém, nesta ordem:

1. `spec.md`: problema, escopo, requisitos e cenários aceitos.
2. `plan.md`: desenho técnico e estratégia de validação.
3. `tasks.md`: unidades executáveis e rastreáveis.

Copie os arquivos de `_templates`, preserve os IDs e atualize o estado no topo de
cada artefato. Código deve citar `TASK-*`; testes e PRs devem citar `SCN-*` e
`REQ-*`. O diretório `000-foundation` registra a fundação inicial e serve como
exemplo completo.
