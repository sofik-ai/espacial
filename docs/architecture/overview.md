# Arquitetura inicial

```text
espacial-desktop ───────> espacial-protocol <────── espacial-server
                                                   │       │
                                                   │       v
                                                   │ espacial-infrastructure
                                                   │       │
                                                   v       v
                                           espacial-application
                                                   │
                                                   v
                                             espacial-domain
```

O diagrama mostra dependências de compilação, não o transporte futuro. O desktop
conhece contratos serializáveis e será conectado ao servidor por um adaptador de
cliente (por exemplo HTTP/WebSocket). O binário local futuro deverá subir o
servidor como processo separado e conectar-se pelo mesmo contrato usado no modo
remoto; ele não receberá uma referência para um serviço interno.

## Fronteiras atuais

- Domínio: IDs e invariantes independentes de serialização/transporte.
- Protocolo: envelope de versão, `ClientHello` e `ServerInfo`; são apenas uma
  prova mínima de contrato, não um desenho prematuro do protocolo de chat.
- Aplicação: consulta de saúde e porta de relógio, demonstrando inversão de controle.
- Infraestrutura: relógio do sistema.
- Server: composição e saída diagnóstica temporária.
- Desktop: constrói/serializa uma saudação de cliente usando apenas o protocolo.

## Evolução para servidor remoto

Antes da primeira feature distribuída: escolher transporte em ADR, definir
negociação de versão, autenticação, autorização por tenant, idempotência, limites,
timeouts, streaming/backpressure e matriz de compatibilidade. O modo embutido e o
remoto devem passar pela mesma suíte de contrato.

## ADRs

Crie `docs/architecture/adr/NNNN-titulo.md` a partir de
`docs/architecture/adr-template.md`. Status válidos: Proposed, Accepted,
Superseded, Rejected.
