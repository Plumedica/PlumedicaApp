// models/hospitals_register.js
import mongoose from "mongoose";

const hospitalSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    registrationId: { type: String, required: true },
    address: { type: String, required: true },
    gstId: { type: String, required: true },
    specialisation: { type: String, required: true },
    mailId: { type: String, required: true },
    phoneNumber: { type: String, required: true },
    userId: { type: String, unique: true, sparse: true },
    username: { type: String },
    password: { type: String },
    sector: { type: String, default: "Hospital" },
    status: {
      type: String,
      enum: ["Pending", "Approved", "Rejected"],
      default: "Pending",
    },
  },
  { timestamps: true }
);

export default mongoose.model("Hospital", hospitalSchema);
