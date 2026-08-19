# Plano técnico — Spec 000

- Status: Accepted
- Spec: `spec.md`
- Architecture owner: Architecture
- Issue: TBD

## Resumo

Criar workspace Cargo com bibliotecas inward-facing e dois binários como
composition roots. Usar tipos mínimos de health/hello apenas para provar
serialização e inversão de dependência.

## Fronteiras

| Fronteira | Mudança | Dependências internas |
|---|---|---|
| Domain | IDs validados | nenhuma |
| Protocol | versão e DTOs mínimos | nenhuma |
| Application | health + porta Clock | domain, protocol |
| Infrastructure | SystemClock | application |
| Server | compõe health | application, infrastructure, protocol |
| Desktop | serializa ClientHello | protocol |

## Contratos e compatibilidade

`ProtocolVersion { major, minor }` começa em 1.0. Mudança incompatível incrementa
major; adição retrocompatível incrementa minor. Antes de rede real, uma ADR deverá
definir envelope, negociação e erros. DTOs não vazam entidades internas.

## Testes

Unitários para IDs e serviço; round-trip JSON para protocolo; smoke tests dos dois
binários via testes de unidade dos entrypoints. CI repete fmt, lint e workspace.

## Segurança e release

Sem rede de produto e sem segredos no repositório. Tags publicam checksums e
binários; o macOS permanece explicitamente unsigned quando as categorias de
secrets não existem. Quando presentes, certificado e chave notarial só vivem em
arquivos/keychain efêmeros do runner e são limpos mesmo após falha.

## Rollback

Como não há dados/migração nem publicação, rollback é reverter a mudança em Git.
