import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import morgan from 'morgan';
import mongoose from 'mongoose';

import dotenv from 'dotenv';
dotenv.config();



import doctorRoutes from './routes/doctorRoutes.js';
import hospitalRoutes from './routes/hospitalsRoutes.js';
import pharmacyRoutes from "./routes/pharmacyRoutes.js";
import Patient from './routes/patientRoutes.js';

const app = express();
const PORT = process.env.PORT || 3000;
app.use(cors());
app.use(bodyParser.json());
app.use(morgan('dev')); 
app.use(bodyParser.urlencoded({ extended: true }));

// Sample route
app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.use('/doctors', doctorRoutes);
app.use('/hospitals', hospitalRoutes);
app.use("/pharmacies", pharmacyRoutes);
app.use("/patients", Patient);

mongoose
  .connect(process.env.MONGODB_URL,)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch((err) => console.error("❌ MongoDB connection failed:", err));
  

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});