import express from "express";
import Doctor from "../models/doctor_register.js";
import argon2 from "argon2";
import { generateCredentials } from "../utils/generatedCredentials.js";
import { sendCredentialsEmail } from "../utils/SendEmails.js";

const router = express.Router();


// ==============================
// ✅ REGISTER DOCTOR
// ==============================
router.post("/register", async (req, res) => {
  try {
    // Convert yearOfReg to a number (ensure type correctness)
    if (req.body.yearOfReg) {
      req.body.yearOfReg = Number(req.body.yearOfReg);
    }

    // Check if a doctor with the same email already exists
    const existing = await Doctor.findOne({ email: req.body.email });
    if (existing) {
      // Email already registered
      return res.status(400).json({ message: "Email already registered!" });
    }

    // Create new doctor model instance with request body data
    const doctor = new Doctor(req.body);

    // Save doctor model instance to DB
    await doctor.save();

    // Return success response
    res.status(201).json({
      message: "Doctor Registered Successfully",
      doctor,
    });
  } catch (error) {
    console.error("🔥 ERROR WHILE SAVING DOCTOR:", error);
    res.status(500).json({
      message: "Failed to save doctor",
      error: error.message,
    });
  }
});


// ==============================
// ✅ GET ALL DOCTORS
// ==============================
router.get("/register", async (req, res) => {
  try {
    const doctors = await Doctor.find();
    res.json(doctors);
  } catch (error) {
    res.status(500).json({ message: "Error fetching doctors" });
  }
});


// ==============================
// ✅ LOGIN DOCTOR
// ==============================
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const doctor = await Doctor.findOne({ username });
    if (!doctor) {
      return res.status(404).json({ success: false, message: "Doctor not found" });
    }

    const validPassword = await argon2.verify(doctor.password, password);
    if (!validPassword) {
      return res.status(401).json({ success: false, message: "Invalid password" });
    }

    res.status(200).json({
      success: true,
      message: "Login successful",
      doctor,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error during login",
      error: error.message,
    });
  }
});



// ==============================
// ✅ UPDATE STATUS + GENERATE CREDENTIALS
// ==============================
router.put("/register/:id/status", async (req, res) => {
  const { status } = req.body;

  try {
    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }

    // APPROVE DOCTOR
    if (status === "Approved" && !doctor.userId) {
      const dob = "2010";

      const { userId, username, password } = generateCredentials(
        doctor.fullName,
        doctor.email,
        dob,
        doctor.contact
      );

      // Hash password before saving
      const hashedPassword = await argon2.hash(password);

      doctor.userId = userId;
      doctor.username = username;
      doctor.password = hashedPassword;
      doctor.status = "Approved";

      await doctor.save();

      // Send email
      await sendCredentialsEmail(doctor.email, doctor.fullName, {
        userId,
        username,
        password,
        sector: "Doctor",
      });

      return res.json({
        message: "Doctor approved, credentials sent",
        doctor,
      });
    }

    // For any other status (Rejected, Pending, etc.)
    doctor.status = status;
    await doctor.save();

    res.json({ message: `Doctor ${status}`, doctor });

  } catch (error) {
    res.status(500).json({
      message: "Error updating status",
      error: error.message,
    });
  }
});


export default router;
