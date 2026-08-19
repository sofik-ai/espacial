# Build e release

## Comportamento operacional

- `ci.yml` roda fronteiras, formatação, Clippy e docs no Linux, e testes no Linux
  e macOS. Actions externas estão fixadas por SHA e Cargo sempre usa o lockfile.
- Uma tag `vMAJOR.MINOR.PATCH` que corresponda à versão do workspace dispara
  `release.yml`.
- Linux é compilado para `x86_64-unknown-linux-gnu` e empacotado como `.tar.gz`.
- macOS é compilado para `aarch64-apple-darwin` e empacotado como `.zip`.
- Cada arquivo tem um `.sha256`; o nome macOS indica `unsigned`, `signed` ou
  `notarized` sem ambiguidade.
- O job final tem a única permissão `contents: write` do fluxo e cria a GitHub
  Release. Não existe deploy, upload a terceiros ou sobrescrita de release.

Uma execução manual serve para validar um ref/tag existente; ela cria artefatos de
Actions, mas só uma execução causada por push de tag publica a GitHub Release.

## Secrets de assinatura macOS

Cadastre estas categorias como GitHub Actions repository secrets. Nunca passe
valores em argumentos de CLI, arquivos versionados ou logs.

| Secret | Conteúdo esperado |
|---|---|
| `MACOS_CERTIFICATE_P12` | Developer ID Application `.p12`, codificado integralmente em base64 |
| `MACOS_CERTIFICATE_PASSWORD` | senha de exportação do `.p12` |
| `MACOS_SIGNING_IDENTITY` | seletor exato da identidade Developer ID Application |

O runner cria um keychain efêmero sem alterar o keychain padrão, libera a chave
somente para `codesign`, assina com hardened runtime e timestamp, verifica ambos os
binários e apaga keychain/certificado em um passo `always()`.

## Secrets opcionais de notarização

Use uma chave de API do App Store Connect com o menor acesso capaz de notarizar:

| Secret | Conteúdo esperado |
|---|---|
| `MACOS_NOTARY_PRIVATE_KEY` | arquivo `.p8` codificado integralmente em base64 |
| `MACOS_NOTARY_KEY_ID` | identificador da chave |
| `MACOS_NOTARY_ISSUER_ID` | identificador do issuer |

Com as três categorias e a assinatura configuradas, `notarytool` submete o ZIP e
espera aceitação. O estágio atual distribui binários CLI em ZIP: o ticket pode ser
consultado online, mas não pode ser grampeado diretamente em um executável. Quando
o desktop virar `.app`, `.pkg` ou `.dmg`, adicione stapling e avaliação Gatekeeper
antes de substituir este empacotamento.

## Procedimento de release

1. Garanta CI verde e worktree limpo.
2. Atualize a versão do workspace e changelog/spec.
3. Execute `./scripts/check.sh` e `./scripts/verify-release-tag.sh vX.Y.Z`.
4. Crie uma tag anotada `vX.Y.Z` no commit aprovado e publique a tag.
5. Verifique todos os jobs e os checksums da GitHub Release.

Tags, releases e assets existentes são imutáveis por política; corrija uma falha
com uma nova versão em vez de sobrescrever artefatos publicados.
