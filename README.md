# Espacial

[![CI](https://github.com/sofik-ai/espacial/actions/workflows/ci.yml/badge.svg)](https://github.com/sofik-ai/espacial/actions/workflows/ci.yml)

Fundação de uma plataforma colaborativa de sessões com LLM para equipes. Esta
etapa estabelece fronteiras, processo de engenharia e uma base Rust compilável;
chat, persistência colaborativa e orquestração de modelos ainda não fazem parte
do produto.

## Começar

Requer Rust estável (MSRV 1.85).

```sh
cargo fmt --all --check
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo test --workspace --all-targets --all-features
cargo run -p espacial-server
cargo run -p espacial-desktop
```

Releases versionadas são produzidas por tags `vMAJOR.MINOR.PATCH`. Consulte
[docs/engineering/releasing.md](docs/engineering/releasing.md) para artefatos,
assinatura e notarização.

## Mapa do repositório

- `crates/espacial-domain`: tipos e invariantes puros de negócio.
- `crates/espacial-protocol`: contratos serializáveis e versionados entre cliente e servidor.
- `crates/espacial-application`: casos de uso e portas, sem detalhes de runtime.
- `crates/espacial-infrastructure`: adaptadores concretos das portas.
- `apps/espacial-server`: composition root do servidor de fundo.
- `apps/espacial-desktop`: composition root do cliente; depende apenas do protocolo.
- `assets/`: marca canônica e ícones gerados para macOS, Linux e web.
- `docs/`: constituição, arquitetura, papéis e operação.
- `specs/`: artefatos por iniciativa e templates do fluxo.

Leia [CONSTITUTION.md](CONSTITUTION.md) antes de alterar decisões estruturais e
[docs/engineering/development.md](docs/engineering/development.md) antes de abrir
uma implementação.
