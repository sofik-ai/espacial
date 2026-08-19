# Baseline de segurança e release

## Checklist de mudança

- Classificar dados tocados e fronteiras de confiança.
- Modelar abuso para identidade, tenant, sessão e ferramentas de agentes.
- Validar autorização no servidor em cada operação, sem confiar em estado da UI.
- Evitar conteúdo sensível em logs; usar IDs de correlação opacos.
- Revisar dependências e licenças; registrar exceções.
- Documentar rotação/revogação para qualquer credencial nova.

## Release

O workflow `release.yml` produz checksums e publica assets Linux/macOS para tags
versionadas. A permissão de escrita existe apenas no job de publicação. Assinatura
e notarização usam secrets em runtime, keychain efêmero e limpeza obrigatória;
nunca armazene certificado, senha, Apple ID ou token no repositório.

Veja [releasing.md](releasing.md) para categorias de secrets e operação. Antes de
uma distribuição de produção, acrescente SBOM/proveniência, verificação de
dependências, matriz de compatibilidade, rollout e rollback.
