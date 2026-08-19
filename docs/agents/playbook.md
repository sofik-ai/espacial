# Playbook de agentes

Agentes seguem a constituição e operam em mudanças pequenas, observáveis e
reversíveis. O orquestrador mantém um único estado dos artefatos e não declara
conclusão sem evidência.

## Papéis

| Papel | Responsabilidade | Saída mínima |
|---|---|---|
| Orquestração | sequenciar, delegar, integrar, bloquear desvios | status de tarefas e evidências |
| Especificação | descobrir problema e critérios, evitar solução prematura | `spec.md` revisada |
| Arquitetura | fronteiras, contratos, ADRs, riscos e evolução | `plan.md` e ADRs |
| Rust/backend | domínio, aplicação, infraestrutura e server via TDD | código/testes ligados a TASK IDs |
| Desktop | UX/runtime cliente sem importar internals do servidor | código/testes de cliente/contrato |
| Qualidade | estratégia, regressão e duas revisões | parecer de spec e parecer de qualidade |
| Segurança/release | threat model, supply chain, build e rollout | checklist, achados e plano de release |

## Contrato operacional de uma tarefa

Nenhuma tarefa entra em progresso sem: ID estável; objetivo/escopo; fora de
escopo; papel dono; requisitos `REQ-*` e cenários `SCN-*` cobertos; dependências;
critérios de aceite; estratégia de teste; Issue e PR (ou `TBD` antes de existirem).
O template canônico está em `specs/_templates/tasks.md`.

Ao iniciar, o agente confirma a tarefa e inspeciona o estado atual. Durante o
trabalho, registra decisões e bloqueios no artefato, sem criar arquitetura paralela.
Ao terminar, informa arquivos alterados, comandos e resultados, riscos residuais e
links. Outro agente/revisor executa primeiro a revisão de aderência e depois a de
qualidade. Quem implementa não autoaprova a entrega.

## Guardrails de coordenação

- Um arquivo tem um responsável por vez; paralelize por fronteiras disjuntas.
- Delegação inclui contexto, resultado esperado, arquivos permitidos e critérios.
- Conflitos são resolvidos pela spec; lacunas voltam à especificação.
- Agentes não publicam, fazem push, releases, migrações destrutivas ou usam segredos
  sem autorização explícita.
- Um bloqueio informa evidência, tentativas seguras e a decisão mínima necessária.
