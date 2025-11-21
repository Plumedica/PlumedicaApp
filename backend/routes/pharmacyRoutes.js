import express from "express";
import Pharmacy from "../models/pharmacy.js";
import { generateCredentials } from "../utils/generatedCredentials.js";
import { sendCredentialsEmail } from "../utils/SendEmails.js";
import argon2 from "argon2";

const router = express.Router();

// ✅ Correct POST - Register Pharmacy
router.post("/register", async (req, res) => {
  try {
   const { name, registrationId, address, phoneNumber, email } = req.body;

    if (!name || !registrationId || !address || !phoneNumber || !email) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // 🔹 Check if email already exists BEFORE saving
     const existing = await Pharmacy.findOne({ email: req.body.email });
           if (existing) {
             // Email already registered
             return res.status(400).json({ message: "Email already registered!" });
           }

    // 🔹 Now save pharmacy
    const pharmacy = new Pharmacy(req.body);
    await pharmacy.save();

    return res
      .status(201)
      .json({ message: "Pharmacy registered successfully", pharmacy });

  } catch (error) {
    res
      .status(500)
      .json({ message: "Error saving pharmacy", error: error.message });
  }
});


// Fetch All Pharmacies
router.get("/register", async (req, res) => {
  try {
    const pharmacies = await Pharmacy.find();
    res.json(pharmacies);
  } catch (error) {
    res.status(500).json({ message: "Error fetching pharmacies", error: error.message });
  }
});


//Login Pharamacy credentials
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const pharmacy = await Pharmacy.findOne({ username });
    if (!pharmacy) {
      return res.status(404).json({ success: false, message: "Pharmacy not found" });
    }

    const validPassword = await argon2.verify(pharmacy.password, password);
    if (!validPassword) {
      return res.status(401).json({ success: false, message: "Invalid password" });
    }

    res.status(200).json({
      success: true,
      message: "Login successful",
      pharmacy,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error during login",
      error: error.message,
    });
  }
});



// ✅ PUT: Update Pharmacy Status
router.put("/register/:id/status", async (req, res) => {
  const { status } = req.body;

  try {
    const pharmacy = await Pharmacy.findById(req.params.id);
    if (!pharmacy)
      return res.status(404).json({ message: "Pharmacy not found" });

    // ✅ If Approved and credentials not yet generated
    if (status === "Approved" && !pharmacy.userId) {
      const { userId, username, password } = generateCredentials(
        pharmacy.name,
        pharmacy.mailId || pharmacy.email || pharmacy.emailId, // ✅ ensures correct email field
        "2010", // placeholder, for compatibility
        pharmacy.phoneNumber
      );
      const hashedPassword = await argon2.hash(password, {
              type: argon2.argon2id,
              memoryCost: 2 ** 16,
              timeCost: 4,
              parallelism: 1,
            });

      pharmacy.userId = userId;
      pharmacy.username = username;
      pharmacy.password = hashedPassword;
      pharmacy.status = "Approved";

      await pharmacy.save();

      // ✅ Determine correct email field safely
      const recipientEmail =
        pharmacy.mailId || pharmacy.email || pharmacy.emailId;

      if (!recipientEmail) {
        console.warn(`⚠️ No email found for pharmacy: ${pharmacy.name}`);
        return res
          .status(400)
          .json({ message: "Email not found for this pharmacy" });
      }

      // ✅ Send credentials email
      await sendCredentialsEmail(recipientEmail, pharmacy.name, {
        userId,
        username,
        password,
        sector: "Pharmacy",
      });

      return res.json({
        message: "Pharmacy approved, credentials generated and email sent",
        pharmacy,
      });
    }

    // 🟠 For Rejected or Already Approved
    pharmacy.status = status;
    await pharmacy.save();

    res.json({ message: `Pharmacy ${status}`, pharmacy });
  } catch (error) {
    console.error("Error updating pharmacy status:", error);
    res.status(500).json({
      message: "Error updating pharmacy status",
      error: error.message,
    });
  }
});


export default router;
