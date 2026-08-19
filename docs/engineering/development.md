# Fluxo de desenvolvimento dirigido por artefatos

## Ciclo

1. **Descobrir:** esclarecer usuários, problema, restrições, riscos e alternativas.
   Não escolher implementação enquanto o comportamento esperado estiver ambíguo.
2. **Especificar:** copiar `specs/_templates/spec.md`; escrever cenários e
   requisitos numerados e verificáveis. Revisar com produto antes do plano.
3. **Planejar:** copiar `plan.md`; registrar arquitetura, contratos, migração,
   segurança, observabilidade, testes e rollback. Criar ADRs quando necessário.
4. **Fatiar:** copiar `tasks.md`; cada tarefa é pequena, rastreável, tem dono/papel,
   dependências, arquivos prováveis e critérios de aceite.
5. **Implementar com TDD:** tornar um cenário vermelho, fazer a mudança mínima,
   deixar verde, refatorar e executar os gates locais.
6. **Depurar sistematicamente:** reproduzir; coletar evidência; localizar a
   primeira divergência; formular uma hipótese por vez; validar; corrigir a causa;
   adicionar regressão. Não empilhar correções especulativas.
7. **Revisar em duas etapas:** (a) requisitos/cenários/escopo; (b) design, segurança,
   testes, operação e legibilidade. Qualidade só começa após a aderência passar.
8. **Entregar:** atualizar artefatos e changelog quando aplicável, anexar evidência
   dos gates, documentar rollout/rollback e fechar Issue/tarefas.

## Definition of Ready

- Issue e diretório de spec identificados.
- problema, não objetivos e critérios mensuráveis registrados;
- riscos de dados/segurança classificados;
- dependências e decisões abertas explícitas;
- tarefas pequenas o bastante para revisão independente.

## Definition of Done

- todos os requisitos aplicáveis têm evidência ou desvio aprovado;
- testes relevantes, formatação e lint passam;
- docs, contrato e ADR foram atualizados;
- revisão de spec e revisão de qualidade foram registradas separadamente;
- observabilidade, rollout e rollback foram tratados ou marcados N/A com motivo;
- Issue, PR, spec e IDs de tarefas têm links recíprocos.

## Gates locais

```sh
./scripts/check.sh
```

Não use `--fix` no CI. Corrija localmente e revise o diff.
