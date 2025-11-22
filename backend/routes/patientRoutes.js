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

    // Username = email
    const username = email.toLowerCase().trim();

    // Check if email already exists
    const existing = await Patient.findOne({ email });
    if (existing) {
      return res.status(400).json({ message: "Email already exists" });
    }

    // Generate userID (always unique)
    const userID = generateUserID(name, dob, mobile);

    // Hash password
    const hashedPassword = await argon2.hash(password);

    const newPatient = new Patient({
      name,
      dob,
      gender,
      email,
      mobile,
      password: hashedPassword,
      userID,
      username,   // <-- AUTOMATICALLY SET HERE
    });

    await newPatient.save();

    res.status(201).json({
      message: "Patient registered successfully",
      patient: {
        id: newPatient._id,
        name: newPatient.name,
        email: newPatient.email,
        userID: newPatient.userID,
        username: newPatient.username,
      },
    });

  } catch (err) {
    console.error("Registration error:", err);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});


//Login patient credentials
// Login patient credentials
router.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const patient = await Patient.findOne({
      $or: [{ username: username.toLowerCase().trim() }, { email: username.toLowerCase().trim() }]
    });

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient not found"
      });
    }

    const validPassword = await argon2.verify(patient.password, password);
    if (!validPassword) {
      return res.status(401).json({
        success: false,
        message: "Invalid password"
      });
    }

    return res.status(200).json({
      success: true,
      message: "Login successful",
      patient: {
        id: patient._id,
        name: patient.name,
        email: patient.email,
        userID: patient.userID,
      }
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Error during login",
      error: error.message
    });
  }
});


router.post("/forgot-password", async (req, res) => {
  const { email } = req.body;

  const patient = await Patient.findOne({ email });
  if (!patient) return res.status(404).json({ message: "No patient exists with this email" });

  const token = crypto.randomBytes(32).toString("hex");
  patient.resetToken = token;
  patient.resetTokenExpiry = Date.now() + 1000 * 60 * 15; // 15 mins
  await patient.save();

  const resetLink = `http://10.2.0.1:3000/patients/reset-password/${token}?module=patient`;

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: { user: process.env.EMAIL_USER, pass: process.env.EMAIL_PASS },
  });

  await transporter.sendMail({
    to: patient.email,
    subject: "Reset Your Password",
    html: `<p>Click here to reset: <a href="${resetLink}">${resetLink}</a></p>`,
  });

  res.json({ success: true, message: "Reset email sent" });
});



router.post("/reset-password/:token", async (req, res) => {
  const { password } = req.body;
  const { token } = req.params;

  const patient = await Patient.findOne({
    resetToken: token,
    resetTokenExpiry: { $gt: Date.now() }
  });

  if (!patient) return res.status(400).json({ message: "Invalid or expired token" });

  patient.password = await argon2.hash(password);
  patient.resetToken = undefined;
  patient.resetTokenExpiry = undefined;

  await patient.save();

  res.json({ success: true, message: "Password updated successfully" });
});


export default router;
