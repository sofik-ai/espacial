# Plano técnico — Spec NNN

- Status: Draft
- Spec: `spec.md`
- Architecture owner:
- Issue: TBD

## Resumo da abordagem

## Impacto por fronteira

| Fronteira | Mudança | Dependências permitidas |
|---|---|---|
| Domain | | nenhuma crate interna |
| Protocol | | contratos apenas |
| Application | | domain, protocol |
| Infrastructure | | application, domain |
| Server | | composição server-side |
| Desktop | | protocol; nunca internals do servidor |

## Contratos e compatibilidade

Versão, serialização, negociação, erros, idempotência e estratégia de migração.

## Dados e migração

## Segurança e threat model

## Desempenho, confiabilidade e observabilidade

## Estratégia de testes

Mapeie cada `SCN-*` para nível de teste e evidência planejada.

## Rollout e rollback

## ADRs e decisões abertas

## Revisão do plano

- Arquitetura:
- Qualidade:
- Segurança/release:
