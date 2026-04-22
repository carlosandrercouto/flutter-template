import * as admin from "firebase-admin";
import express from "express";
import cors from "cors";

// Initialize Firebase Admin App
admin.initializeApp();

// Initialize Express App
const app = express();

// Configure CORS middleware
app.use(cors({ origin: true }));

// =============================================================================
// Auth Middleware
// =============================================================================

/**
 * Middleware que valida o Firebase ID Token enviado no header Authorization.
 *
 * Espera o formato: `Authorization: Bearer <idToken>`
 * Rejeita com 401 se o header estiver ausente, malformado ou com token inválido.
 */
async function verifyToken(
  req: express.Request,
  res: express.Response,
  next: express.NextFunction
): Promise<void> {
  const authHeader = req.headers.authorization ?? "";

  if (!authHeader.startsWith("Bearer ")) {
    res
      .status(401)
      .json({ error: "Missing or invalid Authorization header." });
    return;
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    await admin.auth().verifyIdToken(idToken);
    next();
  } catch (error) {
    console.error("Token verification failed:", error);
    res.status(401).json({ error: "Unauthorized: invalid or expired token." });
  }
}

// =============================================================================
// Routes
// =============================================================================

// Setup route: GET /mass-data (autenticado via Firebase ID Token)
app.get("/mass-data", verifyToken, async (req: express.Request, res: express.Response) => {
  try {
    const bucket = admin.storage().bucket();
    const file = bucket.file("data.json");

    const [exists] = await file.exists();
    if (!exists) {
      res.status(404).json({ error: "File data.json not found in the storage bucket." });
      return;
    }

    res.setHeader("Content-Type", "application/json");

    const readStream = file.createReadStream();
    readStream.on("error", (err) => {
      console.error("Stream error:", err);
      if (!res.headersSent) {
        res.status(500).json({ error: "Failed to read data from storage." });
      }
    });

    readStream.pipe(res);
  } catch (error) {
    console.error("Error processing request:", error);
    if (!res.headersSent) {
      res.status(500).json({ error: "Internal server error." });
    }
  }
});

// Setup route: GET /home/transactions (autenticado via Firebase ID Token)
app.get(
  "/home/transactions",
  verifyToken,
  async (req: express.Request, res: express.Response) => {
    try {
      const bucket = admin.storage().bucket();
      const file = bucket.file("transaction_data.json");

      const [exists] = await file.exists();
      if (!exists) {
        res
          .status(404)
          .json({ error: "File transaction_data.json not found in the storage bucket." });
        return;
      }

      res.setHeader("Content-Type", "application/json");

      const readStream = file.createReadStream();
      readStream.on("error", (err) => {
        console.error("Stream error:", err);
        if (!res.headersSent) {
          res.status(500).json({ error: "Failed to read data from storage." });
        }
      });

      readStream.pipe(res);
    } catch (error) {
      console.error("Error processing request:", error);
      if (!res.headersSent) {
        res.status(500).json({ error: "Internal server error." });
      }
    }
  }
);

// Export Express API as a Firebase Function (Gen 2)
import { onRequest } from "firebase-functions/v2/https";
export const api = onRequest({ invoker: "public" }, app);
