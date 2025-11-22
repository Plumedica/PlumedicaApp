// models/doctor_register.js
import mongoose from "mongoose";

const doctorSchema = new mongoose.Schema(
  {
    fullName: { type: String, required: true },
    regNumber: { type: String, required: true },
    specialisation: { type: String, required: true },
    yearOfReg: { type: Number, required: true },
    pg: String,
    mbbs: String,
    contact: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    address: String,
    shareLocation: { type: Boolean, default: false },

    // FIX: sparse allows multiple null values
    userId: { type: String, sparse: true },
    username: { type: String },
    password: { type: String },

    sector: { type: String, default: "Doctor" },

    status: {
      type: String,
      enum: ["Pending", "Approved", "Rejected"],
      default: "Pending",
    },
    resetToken: String,
resetTokenExpiry: Date,

  },
  { timestamps: true }
);

export default mongoose.model("Doctor", doctorSchema);
