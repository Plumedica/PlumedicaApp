// routes/doctorRoutes.js
import express from "express";
import Doctor from "../models/doctor_register.js";
import { generateCredentials } from "../utils/generatedCredentials.js";
import { sendCredentialsEmail } from "../utils/SendEmails.js";
import argon2 from "argon2";

const router = express.Router();

// ✅ Register a new doctor
router.post("/register", async (req, res) => {
  try {
    const doctor = new Doctor(req.body);
    await doctor.save();
    res.status(201).json({ message: "Doctor Registered Successfully", doctor });
  } catch (error) {
    res.status(500).json({ message: "Error saving doctor", error: error.message });
  }
});

// ✅ Fetch all doctors
router.get("/register", async (req, res) => {
  try {
    const doctors = await Doctor.find();
    res.json(doctors);
  } catch (error) {
    res.status(500).json({ message: "Error fetching doctors" });
  }
});

//Login Doctor credentials
router.post("/login", async (req, res) => {
  const { username, password } = req.body;
  try {
    const doctor = await Doctor.findOne({ username });
    if (!doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    } 
    const validPassword = await argon2.verify(doctor.password, password);
    if (!validPassword) {
      return res.status(401).json({ message: "Invalid password" });
    } 
    res.json({ message: "Login successful", doctor });
  } catch (error) {
    res.status(500).json({ message: "Error during login", error: error.message });
  }
});



// ✅ Update doctor status and generate credentials if approved
router.put("/register/:id/status", async (req, res) => {
  const { status } = req.body;

  try {
    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) return res.status(404).json({ message: "Doctor not found" });

    // ✅ If status is "Approved" and credentials not yet generated
    if (status === "Approved" && !doctor.userId) {
      const dob = "2010"; // TODO: Replace with actual DOB field if available
      const { userId, username, password } = generateCredentials(
        doctor.fullName,
        doctor.email,
        dob,
        doctor.contact
      );

      // ✅ Hash the password securely before saving to DB
      const hashedPassword = await argon2.hash(password, {
        type: argon2.argon2id,
        memoryCost: 2 ** 16,
        timeCost: 4,
        parallelism: 1,
      });

      doctor.userId = userId;
      doctor.username = username;
      doctor.password = hashedPassword; // store hash only
      doctor.status = "Approved";

      await doctor.save();

      // ✅ Send plaintext credentials by email (only this one time)
      await sendCredentialsEmail(doctor.email, doctor.fullName, {
        userId,
        username,
        password, // send the real password (not hash)
        sector: "Doctor",
      });

      return res.json({
        message: "Doctor approved, credentials generated and email sent",
        doctor,
      });
    }

    // For Rejected or already Approved
    doctor.status = status;
    await doctor.save();

    res.json({ message: `Doctor ${status}`, doctor });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error updating doctor status", error: error.message });
  }
});

export default router;
