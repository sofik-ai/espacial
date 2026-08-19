# Spec 000: Fundação de engenharia e workspace Rust

- Status: Accepted
- Owner: Orchestration
- Issue: TBD (repositório remoto ainda não definido)
- Última atualização: 2026-08-19

## Problema e resultado

O Espacial precisa começar com um processo repetível e fronteiras que não acoplem
o desktop ao servidor local. O resultado é uma base compilável, testada e pronta
para receber specs de produto sem antecipar chat ou orquestração LLM.

## Descoberta

- Usuários: equipe de engenharia e agentes colaboradores.
- Evidência: direcionamento confirmado para produto Rust colaborativo, hoje local
  e futuramente conectável a servidor remoto auto-hospedado.
- Alternativas: monólito único (rejeitado pelo acoplamento); microserviços agora
  (rejeitado por complexidade prematura); workspace modular (selecionado).
- Perguntas abertas: toolkit desktop, transporte, storage e provedor de identidade.

## Escopo

### Incluído

Constituição, fluxo de artefatos, papéis, workspace Rust, prova mínima das
fronteiras, testes, CI, build Linux/macOS e templates GitHub.

### Não objetivos

Chat, chamadas LLM, persistência compartilhada, autenticação, UI real, rede,
  instalador e assinatura/notarização sem credenciais fornecidas.

## Requisitos

- **REQ-001:** o processo deve ser descrito por spec, plano e tarefas rastreáveis.
- **REQ-002:** as dependências devem preservar as seis fronteiras definidas.
- **REQ-003:** desktop não pode depender de internals do servidor.
- **REQ-004:** a base deve passar por formatação, lint estrito e testes.
- **REQ-005:** CI deve validar, gerar binários Linux/macOS e publicar releases de tags.
- **REQ-006:** o repositório deve oferecer templates para Issues, PRs e Project.

## Cenários de aceite

- **SCN-001** cobre REQ-001/REQ-006: um colaborador encontra templates e campos
  necessários para levar uma iniciativa de descoberta até PR.
- **SCN-002** cobre REQ-002/REQ-003: o manifesto do desktop referencia apenas a
  crate interna de protocolo, e o workspace compila.
- **SCN-003** cobre REQ-004: o script local executa fmt, Clippy e testes sem falhas.
- **SCN-004** cobre REQ-005: uma tag coerente gera checksums, assets Linux/macOS e
  GitHub Release, com assinatura/notarização condicionadas a secrets completos.

## Qualidades

- Desempenho: perfil release otimizado sem impor abstrações de runtime.
- Confiabilidade: testes determinísticos e CI com lockfile.
- Segurança: `unsafe` proibido, segredos ignorados e assinatura sem chaves no Git.
- Acessibilidade/UX: N/A nesta etapa sem UI.

## Métricas de sucesso

Todos os gates locais verdes; dependências inspecionáveis por `cargo metadata`;
todo item de escopo presente no repositório.

## Aprovação

- Produto: direção fornecida pelo usuário em 2026-08-19.
- Engenharia: registrada pela entrega inicial.
- Segurança: baseline documentada; implementação de autenticação fora do escopo.
