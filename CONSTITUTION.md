# Constituição de engenharia do Espacial

Versão 1.0 — 2026-08-19

Este documento é a autoridade de engenharia do projeto. Exceções precisam ser
registradas na spec e na PR, com motivo, risco, prazo e responsável pela remoção.

## 1. Produto e princípios

1. O Espacial é colaborativo por definição: identidade, concorrência, auditoria e
   isolamento entre empresas não são complementos tardios.
2. O servidor é a autoridade sobre estado compartilhado. O desktop é um cliente
   e nunca importa nem chama internals do servidor.
3. Contratos atravessam processos. Mesmo quando desktop e servidor forem
   distribuídos juntos, devem continuar substituíveis por um servidor remoto.
4. O domínio não conhece UI, rede, banco de dados, sistema operacional ou SDKs de
   LLM. Dependências apontam para dentro; adaptadores implementam portas.
5. Mudanças começam em um problema verificável, não em código. A menor solução
   que satisfaz a spec vence abstrações especulativas.
6. Segurança, observabilidade, acessibilidade e operação são atributos do
   produto e entram nos critérios de aceite.

## 2. Arquitetura obrigatória

- `espacial-domain` não depende de crates internas.
- `espacial-protocol` contém somente contratos de fronteira, sua versão e regras
  de compatibilidade; não contém casos de uso.
- `espacial-application` coordena domínio e portas; não instancia infraestrutura.
- `espacial-infrastructure` implementa portas e pode depender de aplicação e
  domínio.
- `espacial-server` é um composition root. É o único runtime que compõe casos de
  uso do servidor e adaptadores.
- `espacial-desktop` pode depender de `espacial-protocol` e bibliotecas de
  cliente/UI, mas nunca de application, infrastructure, domain ou server.

Qualquer mudança nessas setas exige Architecture Decision Record (ADR), revisão
de arquitetura e teste automatizado de dependências.

## 3. Qualidade e testes

- O ciclo normal é red → green → refactor. O teste demonstra o comportamento
  faltante antes da implementação, salvo scaffolding puramente mecânico.
- Pirâmide: muitos testes unitários de invariantes, testes de contrato nas
  fronteiras, integração para adaptadores e poucos testes ponta a ponta.
- Todo bug corrigido ganha um teste de regressão reproduzindo a causa.
- `cargo fmt`, Clippy com warnings negados e todos os testes são gates de merge.
- Código inseguro (`unsafe`) é proibido por padrão. Uma exceção exige ADR,
  encapsulamento, comentário de segurança e revisão especializada.

## 4. Desempenho e confiabilidade

- Nenhuma otimização sem perfil ou orçamento explícito na spec.
- Operações remotas devem ter timeout, cancelamento e política de retry definida;
  retries precisam ser limitados e seguros para idempotência.
- Backpressure e limites de recursos são obrigatórios para streaming e fan-out.
- Métricas não podem carregar conteúdo de prompts ou respostas por padrão.
- Mudanças críticas registram baseline, cenário, ambiente e resultado do benchmark.

## 5. Segurança e privacidade

- Negar por padrão; autenticação não substitui autorização por empresa/sessão.
- Segredos nunca entram em Git, logs, artefatos ou parâmetros de CLI.
- Dados em trânsito usam TLS quando saem da máquina; pontos de extensão para
  criptografia e gestão de chaves pertencem à infraestrutura.
- Entradas externas são não confiáveis e devem ser validadas na fronteira.
- Ações de usuários e agentes que alterem estado compartilhado devem ser
  atribuíveis e auditáveis, com retenção definida.
- Dependências são minimizadas e revisadas; achados críticos bloqueiam release.
- Incidentes seguem contenção, preservação de evidência, comunicação e correção
  com post-mortem sem culpa.

## 6. Processo e governança

Toda feature usa os artefatos `spec.md`, `plan.md` e `tasks.md` em
`specs/<id>-<slug>/`. Decisões duráveis usam ADR. Uma PR deve ligar Issue, spec e
tarefas, e passa por duas revisões separadas: primeiro aderência à spec; depois
qualidade, segurança, testes e manutenibilidade.

Emendas a esta constituição exigem uma PR própria ou seção explícita na spec,
aprovação de arquitetura e segurança, e atualização da versão/data acima.
