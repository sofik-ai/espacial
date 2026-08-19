# Identidade da aplicação

Os assets desta pasta são derivados mecanicamente do símbolo oficial Espacial em
`assets/brand/espacial-mark.svg`; a geometria da marca não deve ser redesenhada
durante a geração.

- `macos/Espacial.icns`: ícone do bundle `Espacial.app`.
- `linux/`: SVG escalável, PNGs hicolor e entrada desktop.
- `web/`: favicon SVG/ICO, rasterizações usuais e manifest básico.

Em macOS, regenere os arquivos depois de uma mudança aprovada da marca:

```sh
./scripts/generate-icons.sh
./scripts/verify-icon-assets.sh
```

Os arquivos gerados são versionados para que builds Linux não precisem de uma
toolchain gráfica ou de acesso ao diretório de origem da marca.
