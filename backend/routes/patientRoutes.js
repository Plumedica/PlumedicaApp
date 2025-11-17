import express from "express";
import argon2 from "argon2";
import Patient from "../models/patient_register.js";

const router = express.Router();

// Generate Unique Patient ID
function generateUserID(name, dob, mobile) {
  const prefix = "PM";
  const initials = name
    .trim()
    .split(" ")
    .map((n) => n[0].toUpperCase())
    .join("")
    .substring(0, 2);

  const year = dob.slice(2, 4);
  const lastTwoPhone = mobile.slice(-2);

  return `${prefix}${initials}${year}${lastTwoPhone}`;
}

router.post("/register", async (req, res) => {
  try {
    const { name, dob, gender, email, mobile, password } = req.body;

    if (!name || !dob || !gender || !email || !mobile || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const existing = await Patient.findOne({ email });
    if (existing) {
      return res.status(400).json({ message: "Email already exists" });
    }

    const userID = generateUserID(name, dob, mobile);

    const idExists = await Patient.findOne({ userID });
    if (idExists) {
      return res.status(400).json({ message: "UserID already exists, try again later" });
    }

    const hashedPassword = await argon2.hash(password);

    const newPatient = new Patient({
      name,
      dob,
      gender,
      email,
      mobile,
      password: hashedPassword,
      userID,
    });

    await newPatient.save();

    res.status(201).json({
      message: "Patient registered successfully",
      patient: {
        id: newPatient._id,
        name: newPatient.name,
        email: newPatient.email,
        userID: newPatient.userID,
      },
    });
  } catch (err) {
    console.error("Registration error:", err);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

//Login patient credentials
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const patient = await Patient.findOne({ email });
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    } 
    const validPassword = await argon2.verify(patient.password, password);
    if (!validPassword) {
      return res.status(401).json({ message: "Invalid password" });
    } 
    res.json({ message: "Login successful", patient });
  } catch (error) {
    res.status(500).json({ message: "Error during login", error: error.message });
  }
});


export default router;
