# CryptoMutants (MGG)

Coleccion ERC-721 de 12 mutantes geneticamente unicos, inspirada en el juego
*Mutants Genetic Gladiators* y en la mecanica clasica de CryptoKitties.

**Autor:** Diego Andres Gonzalez Graciano

**Whitepaper:** [`Cryptomutants.pdf`](./Cryptomutants.pdf)

## Despliegue

| | |
| --- | --- |
| **Red** | Sepolia Testnet |
| **Contrato** | [`0xf9e168a936cc3f35d5298e3be81406d66144dbe3`](https://sepolia.etherscan.io/address/0xf9e168a936cc3f35d5298e3be81406d66144dbe3) |
| **Token** | [Ver en Etherscan](https://sepolia.etherscan.io/token/0xf9e168a936cc3f35d5298e3be81406d66144dbe3) |
| **Tx despliegue** | [`0xe6fc9b...42e8`](https://sepolia.etherscan.io/tx/0xe6fc9ba60bf71379faad1635e04c565f5c319be2d8d01139bfdfbb7a91c242e8) |
| **Tx primer mint** | [`0x27ae14...529d`](https://sepolia.etherscan.io/tx/0x27ae147ed8e74076ece8cdfb5baec42ae3c8264d52515a762379ede47054529d) |


## Idea base

Cada mutante carga **2 genes ordenados** elegidos de un conjunto de 4:

- Cyber
- Sable
- Mitico
- Galactico

## Stats

Para cada mutante:

```
HP     = HP_primario     + HP_secundario     / 2
ATK    = ATK_primario    + ATK_secundario    / 2
SPEED  = SPEED_primario  + SPEED_secundario  / 2
```

### Genes base

| Gen        | HP   | ATK | SPEED |
| ---------- | ---- | --- | ----- |
| Cyber      | 1837 | 271 | 4.00  |
| Sable      | 1516 | 380 | 5.56  |
| Mitico     | 1659 | 451 | 4.76  |
| Galactico  | 1049 | 165 | 11.11 |

### Roster derivado

| ID | Nombre        | Genetica           | HP   | ATK | SPEED |
| -- | ------------- | ------------------ | ---- | --- | ----- |
|  1 | Dezinger      | Cyber-Sable        | 2595 | 461 |  6.78 |
|  2 | Autonoraptor  | Cyber-Mitico       | 2666 | 496 |  6.38 |
|  3 | Invadron      | Cyber-Galactico    | 2361 | 353 |  9.55 |
|  4 | Ejecutor      | Sable-Cyber        | 2434 | 515 |  7.56 |
|  5 | Valkiria      | Sable-Mitico       | 2345 | 605 |  7.94 |
|  6 | Geminium      | Sable-Galactico    | 2040 | 462 | 11.11 |
|  7 | Tecno Tao     | Mitico-Cyber       | 2577 | 586 |  6.76 |
|  8 | Oriax         | Mitico-Sable       | 2417 | 641 |  7.54 |
|  9 | Cthlig        | Mitico-Galactico   | 2183 | 533 | 10.31 |
| 10 | Aniquilador   | Galactico-Cyber    | 1967 | 300 | 13.11 |
| 11 | Sundance Bug  | Galactico-Sable    | 1807 | 355 | 13.89 |
| 12 | Nebulon       | Galactico-Mitico   | 1878 | 390 | 13.49 |

## Mecanica de mint

- Mint publico y gratuito (solo se paga gas).
- 1 mutante por wallet en el mint inicial.
- El usuario elige: llama a `mint(uint256 tokenId)` para reclamar el
  mutante que quiera, si todavia esta disponible.
- Despues del mint, las transferencias secundarias son libres.