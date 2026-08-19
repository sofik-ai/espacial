# Configuração sugerida do GitHub Project

Crie um Project v2 da organização quando o repositório remoto existir. Nenhuma
automação externa é executada por estes arquivos.

## Campos

| Campo | Tipo | Valores sugeridos |
|---|---|---|
| Status | single select | Inbox, Discovery, Spec, Planned, Ready, In progress, In review, Done |
| Phase | single select | Discovery, Spec, Plan, Tasks, Implementation, Validation, Release |
| Role | single select | Orchestration, Spec, Architecture, Rust/backend, Desktop, Quality, Security/release |
| Priority | single select | P0, P1, P2, P3 |
| Risk | single select | Low, Medium, High, Critical |
| Estimate | number | pontos inteiros |
| Spec | text | caminho/URL de `spec.md` |
| Requirement IDs | text | `REQ-001, ...` |
| Target release | iteration | iteração planejada |

## Views

- **Delivery board:** colunas por Status; agrupar por Target release.
- **Artifact flow:** colunas por Phase; filtrar itens não Done.
- **Risk review:** tabela ordenada por Risk e Priority.
- **Agent workload:** board agrupado por Role, depois Status.
- **Release readiness:** itens da iteração com Status, Risk e checks de aceite.

Automações sugeridas: item novo → Inbox; spec aprovada → Planned; PR aberta → In
review; PR merged → Done. A passagem para `Ready` continua manual para garantir a
Definition of Ready.
