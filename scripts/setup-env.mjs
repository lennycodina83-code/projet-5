import { randomBytes } from "node:crypto";
import { readFile, writeFile } from "node:fs/promises";

const template = await readFile(new URL("../.env.example", import.meta.url), "utf8");
const password = randomBytes(24).toString("hex");
const secret = randomBytes(32).toString("base64url");
const content = template
  .replaceAll("change-me-local-password", password)
  .replace("your-secret-key-here-change-in-production", secret);

try {
  await writeFile(new URL("../.env", import.meta.url), content, { flag: "wx" });
  console.log(".env created with local credentials.");
} catch (error) {
  if (error.code !== "EEXIST") throw error;
  console.log(".env already exists; existing values preserved.");
}
