# Tarefas — Spec 000

- Status: Done
- Tracking issue: TBD

## TASK-001 — Governança e fluxo de artefatos

- Status: Done
- Papel dono: Specification / Orchestration
- Issue/PR: TBD / TBD
- Requisitos/cenários: REQ-001, REQ-006; SCN-001
- Depende de: nenhuma
- Escopo: constituição, docs, templates e Project.
- Fora do escopo: criar recursos remotos.
- Critérios de aceite: artefatos completos e links navegáveis.
- Verificação: inspeção dos arquivos versionados.

## TASK-002 — Workspace e fronteiras Rust

- Status: Done
- Papel dono: Architecture / Rust/backend / Desktop
- Issue/PR: TBD / TBD
- Requisitos/cenários: REQ-002, REQ-003; SCN-002
- Depende de: TASK-001
- Escopo: seis packages mínimos e testes de unidade/contrato.
- Fora do escopo: rede, chat, LLM e UI.
- Critérios de aceite: workspace compila; desktop só depende internamente de protocol.
- Verificação: `cargo metadata`; `cargo test --workspace --all-targets --all-features`.

## TASK-003 — Gates e build

- Status: Done
- Papel dono: Quality / Security/release
- Issue/PR: TBD / TBD
- Requisitos/cenários: REQ-004, REQ-005; SCN-003, SCN-004
- Depende de: TASK-002
- Escopo: script local, validação e artefatos Linux/macOS.
- Fora do escopo: configurar credenciais Apple inexistentes e publicar produto funcional.
- Critérios de aceite: gates locais verdes; tag publica release e assets; secrets
  Apple, quando configurados, habilitam assinatura/notarização sem exposição.
- Verificação: `./scripts/check.sh` e inspeção dos workflows.

## TASK-004 — Identidade de aplicação nos artefatos

- Status: Done
- Papel dono: Desktop / Security/release
- Issue/PR: TBD / TBD
- Requisitos/cenários: REQ-004, REQ-005; SCN-003
- Depende de: TASK-003
- Escopo: ícones macOS/Linux, favicons e integração ao empacotamento.
- Fora do escopo: UI funcional, instalador nativo e publicação web.
- Critérios de aceite: bundle macOS declara ICNS; pacote Linux inclui desktop
  entry e árvore hicolor; assets web têm SVG, ICO, PNGs e manifest.
- Verificação: `./scripts/verify-icon-assets.sh` e inspeção dos pacotes locais.

## Revisões

### 1. Aderência à spec

- Resultado: Pass — todos os REQ/SCN possuem artefato ou evidência local.

### 2. Qualidade

- Resultado: Pass — registrada após fmt, Clippy e testes verdes.
- Follow-up: adicionar teste automatizado de política de dependências quando a
  primeira crate cliente/transport for criada.
