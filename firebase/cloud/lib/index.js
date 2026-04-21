"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.api = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
// Initialize Firebase Admin App
admin.initializeApp();
// Initialize Express App
const app = (0, express_1.default)();
// Configure CORS middleware
app.use((0, cors_1.default)({ origin: true }));
// Setup route: GET /v1/mass-data
app.get("/v1/mass-data", async (req, res) => {
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
    }
    catch (error) {
        console.error("Error processing request:", error);
        if (!res.headersSent) {
            res.status(500).json({ error: "Internal server error" });
        }
    }
});
// Export Express API as a Firebase Function
exports.api = functions.https.onRequest(app);
//# sourceMappingURL=index.js.map