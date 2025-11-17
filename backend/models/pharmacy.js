// models/pharmacy_register.js
import mongoose from "mongoose";

const pharmacySchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    registrationId: { type: String, required: true },
    address: { type: String, required: true },
    emailId: { type: String, required: true },
    phoneNumber: { type: String, required: true },
    userId: { type: String, unique: true, sparse: true },
    username: { type: String },
    password: { type: String },
    sector: { type: String, default: "Pharmacy" },
    status: {
      type: String,
      enum: ["Pending", "Approved", "Rejected"],
      default: "Pending",
    },
  },
  { timestamps: true }
);

export default mongoose.model("Pharmacy", pharmacySchema);
