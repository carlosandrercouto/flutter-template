import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import express from "express";
import cors from "cors";

// Initialize Firebase Admin App
admin.initializeApp();

// Initialize Express App
const app = express();

// Configure CORS middleware
app.use(cors({ origin: true }));

// Setup route: GET /v1/mass-data
app.get("/v1/mass-data", async (req: express.Request, res: express.Response) => {
  try {
    // Get default bucket
    const bucket = admin.storage().bucket();
    const file = bucket.file("data.json");

    // Check if file exists to prevent stream error crashing the app
    const [exists] = await file.exists();
    if (!exists) {
      res.status(404).json({ error: "File data.json not found in the storage bucket." });
      return;
    }

    // Set Header
    res.setHeader("Content-Type", "application/json");

    // Pipe stream to avoid memory heap issues
    const readStream = file.createReadStream();
    
    // Handle stream errors
    readStream.on("error", (err) => {
      console.error("Stream error:", err);
      if (!res.headersSent) {
        res.status(500).json({ error: "Failed to read data from storage" });
      }
    });

    readStream.pipe(res);
  } catch (error) {
    console.error("Error processing request:", error);
    if (!res.headersSent) {
      res.status(500).json({ error: "Internal server error" });
    }
  }
});

// Export Express API as a Firebase Function
export const api = functions.https.onRequest(app);
