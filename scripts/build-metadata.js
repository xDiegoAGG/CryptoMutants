/**
 * build-metadata.js
 *
 * Toma la plantilla de metadata en `metadata/` y produce los 12 archivos
 * finales en `metadata-final/` reemplazando el placeholder __IMAGES_CID__
 * por el CID de IPFS de la carpeta de imagenes.
 *
 * Uso:
 *   node scripts/build-metadata.js <IMAGES_CID>
 *
 * Ejemplo:
 *   node scripts/build-metadata.js bafybeigdyrztktx5jfjl7s3wqnflwxtjmkvejymxr4n5qjp6m3hjdklfxa
 *
 * Despues de correr este script, sube `metadata-final/` a Pinata para
 * obtener el CID de la carpeta de metadata, que es el que va al contrato.
 */

const fs = require("fs");
const path = require("path");

const TEMPLATE_DIR = path.resolve(__dirname, "..", "metadata");
const OUTPUT_DIR = path.resolve(__dirname, "..", "metadata-final");
const PLACEHOLDER = "__IMAGES_CID__";

function main() {
  const cid = process.argv[2];

  if (!cid) {
    console.error("Falta el CID. Uso:");
    console.error("  node scripts/build-metadata.js <IMAGES_CID>");
    process.exit(1);
  }

  if (!/^[a-zA-Z0-9]+$/.test(cid)) {
    console.error(
      "El CID se ve raro (solo deberia tener letras y numeros). Lo recibido:",
      cid
    );
    process.exit(1);
  }

  if (!fs.existsSync(TEMPLATE_DIR)) {
    console.error("No encontre la carpeta de plantillas:", TEMPLATE_DIR);
    process.exit(1);
  }

  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const files = fs
    .readdirSync(TEMPLATE_DIR)
    .filter((f) => f.endsWith(".json"))
    .sort((a, b) => parseInt(a, 10) - parseInt(b, 10));

  if (files.length === 0) {
    console.error("No encontre archivos .json en", TEMPLATE_DIR);
    process.exit(1);
  }

  console.log(`Generando ${files.length} archivos de metadata con CID = ${cid}`);
  console.log("");

  for (const file of files) {
    const src = path.join(TEMPLATE_DIR, file);
    const dst = path.join(OUTPUT_DIR, file);
    const content = fs.readFileSync(src, "utf8").replaceAll(PLACEHOLDER, cid);

    JSON.parse(content);

    fs.writeFileSync(dst, content);
    console.log(`  OK  ${file}`);
  }

  console.log("");
  console.log("Listo. Los archivos finales estan en:");
  console.log(`  ${OUTPUT_DIR}`);
  console.log("");
  console.log("Siguiente paso: sube esa carpeta a Pinata como una carpeta");
  console.log("y copia el CID de la carpeta resultante (ese es el METADATA_CID");
  console.log('que va al constructor del contrato como "ipfs://<CID>/").');
}

main();
