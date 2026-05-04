require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");

const app = express();

// Middleware
app.use(express.json());

// Routes
const postRoutes = require("./routes/post.routes");
app.use("/posts", postRoutes);

// Health check (for K8s probes)
app.get("/health", (req, res) => {
  res.status(200).json({ status: "OK" });
});

// -----------------------------
// Environment variables (clean handling)
// -----------------------------
const PORT = process.env.PORT || 3000;

const MONGO_URI = `mongodb://${process.env.MONGO_HOSTS}/${process.env.MONGO_DB}?replicaSet=${process.env.MONGO_REPLICA_SET}`;

// -----------------------------
// DB Connection
// -----------------------------
mongoose
  .connect(MONGO_URI)
  .then(() => {
    console.log("MongoDB connected successfully");

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("DB connection error:", err);
    process.exit(1); // important for Kubernetes restart
  });
