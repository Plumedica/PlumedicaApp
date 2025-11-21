import express from "express";
import Hospital from "../models/hospitals_register.js";
import { generateCredentials } from "../utils/generatedCredentials.js";
import { sendCredentialsEmail } from "../utils/SendEmails.js";
import argon2 from "argon2";

const router = express.Router();

// REGISTER HOSPITAL
router.post("/register", async (req, res) => {
  try {
    const { email } = req.body;

    // Check email exists
   const existing = await Hospital.findOne({ email: req.body.email });
       if (existing) {
         // Email already registered
         return res.status(400).json({ message: "Email already registered!" });
       }

    // Save hospital
    const newHospital = new Hospital(req.body);
    await newHospital.save();

    res.status(201).json({
      message: "Hospital Registered Successfully",
      hospital: newHospital
    });
  } catch (error) {
    console.error("❌ Error saving hospital:", error);
    res.status(500).json({
      message: "Error saving hospital",
      error: error.message
    });
  }
});

// LOGIN
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const hospital = await Hospital.findOne({ username });
    if (!hospital) {
      return res.status(404).json({ success: false, message: "Hospital not found" });
    }

    const validPassword = await argon2.verify(hospital.password, password);
    if (!validPassword) {
      return res.status(401).json({ success: false, message: "Invalid password" });
    }

    res.status(200).json({
      success: true,
      message: "Login successful",
      hospital,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error during login",
      error: error.message,
    });
  }
});


// GET ALL HOSPITALS
router.get("/register", async (req, res) => {
  try {
    const hospitals = await Hospital.find();
    res.json(hospitals);
  } catch (error) {
    res.status(500).json({ message: "Error fetching hospitals", error: error.message });
  }
});

// UPDATE STATUS
router.put("/register/:id/status", async (req, res) => {
  const { status } = req.body;

  try {
    const hospital = await Hospital.findById(req.params.id);
    if (!hospital) return res.status(404).json({ message: "Hospital not found" });

    // APPROVE → generate credentials
    if (status === "Approved" && !hospital.userId) {
      const dob = "2010"; 
      const { userId, username, password } = generateCredentials(
        hospital.name,
        hospital.email,  // FIXED
        dob,
        hospital.phoneNumber
      );

      const hashedPassword = await argon2.hash(password);

      hospital.userId = userId;
      hospital.username = username;
      hospital.password = hashedPassword;
      hospital.status = "Approved";

      await hospital.save();

      // Send credentials email
      await sendCredentialsEmail(hospital.email, hospital.name, {
        userId,
        username,
        password,
        sector: "Hospital",
      });

      return res.json({
        message: "Hospital approved, credentials generated & email sent",
        hospital,
      });
    }

    // REJECT or change status
    hospital.status = status;
    await hospital.save();

    res.json({ message: `Hospital ${status}`, hospital });
  } catch (error) {
    console.error("❌ Error updating status:", error);
    res.status(500).json({
      message: "Error updating hospital status",
      error: error.message,
    });
  }
});

export default router;
