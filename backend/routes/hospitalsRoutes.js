import express from "express";
import Hospital from "../models/hospitals_register.js";
import { generateCredentials } from "../utils/generatedCredentials.js";
import { sendCredentialsEmail } from "../utils/SendEmails.js";
import argon2 from "argon2";  


const router = express.Router();

// 🟢 POST: Register Hospital
router.post("/register", async (req, res) => {
  try {
    const hospital = new Hospital(req.body);
    await hospital.save();
    res.status(201).json({ message: "Hospital Registered Successfully", hospital });
  } catch (error) {
    res.status(500).json({ message: "Error saving hospital", error: error.message });
  }
});



//Login Doctor credentials
router.post("/login", async (req, res) => {
  const { username, password } = req.body;
  try {
    const hospital = await Hospital.findOne({ username });
    if (!hospital) {
      return res.status(404).json({ message: "Hospital not found" });
    } 
    const validPassword = await argon2.verify(hospital.password, password);
    if (!validPassword) {
      return res.status(401).json({ message: "Invalid password" });
    } 
    res.json({ message: "Login successful", hospital });
  } catch (error) {
    res.status(500).json({ message: "Error during login", error: error.message });
  }
});



// 🟡 GET: Fetch All Hospitals
router.get("/register", async (req, res) => {
  try {
    const hospitals = await Hospital.find();
    res.json(hospitals);
  } catch (error) {
    res.status(500).json({ message: "Error fetching hospitals", error: error.message });
  }
});

// 🟠 PUT: Update Hospital Status
router.put("/register/:id/status", async (req, res) => {
  const { status } = req.body;

  try {
    const hospital = await Hospital.findById(req.params.id);
    if (!hospital) return res.status(404).json({ message: "Hospital not found" });

    // ✅ If Approved and credentials not yet generated
    if (status === "Approved" && !hospital.userId) {
      const dob = "2010"; // placeholder, not used but kept for compatibility
      const { userId, username, password } = generateCredentials(
        hospital.name,
        hospital.mailId,
        dob,
        hospital.phoneNumber
      );
const hashedPassword = await argon2.hash(password, {
        type: argon2.argon2id,
        memoryCost: 2 ** 16,
        timeCost: 4,
        parallelism: 1,
      });
      hospital.userId = userId;
      hospital.username = username;
      hospital.password = hashedPassword;
      hospital.status = "Approved";

      await hospital.save();

      // ✅ Send credentials via email
      await sendCredentialsEmail(hospital.mailId, hospital.name, {
        userId,
        username,
        password,
        sector: "Hospital",
      });

      return res.json({
        message: "Hospital approved, credentials generated and email sent",
        hospital,
      });
    }

    // 🟠 For Rejected or Already Approved
    hospital.status = status;
    await hospital.save();

    res.json({ message: `Hospital ${status}`, hospital });
  } catch (error) {
    console.error("Error in updating hospital status:", error);
    res.status(500).json({
      message: "Error updating hospital status",
      error: error.message,
    });
  }
});


export default router;
