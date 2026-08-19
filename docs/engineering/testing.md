# Estratégia de testes

| Camada | Teste preferido | O que prova |
|---|---|---|
| Domínio | unitário/table-driven | invariantes e transições |
| Protocolo | round-trip e fixtures | estabilidade de wire format e versão |
| Aplicação | unitário com portas fake | regras de coordenação |
| Infraestrutura | integração | adaptadores e falhas reais |
| Runtimes | smoke/contract/E2E | composição e comportamento entre processos |

Testes devem ser determinísticos: relógio, IDs, aleatoriedade, rede e filesystem
entram por portas ou fixtures controladas. Flakiness é defeito, não motivo para
retry ilimitado. Testes ignorados precisam de Issue, responsável e prazo.
