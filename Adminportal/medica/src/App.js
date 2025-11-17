import React from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import "./App.css";

import Register from "./components/register_page.js";
import Login from "./components/login_page.js";
import ForgotPassword from "./components/forgotpassword.js";
import Homepage from "./components/Homepage.js";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/forgot-password" element={<ForgotPassword />} />
        <Route path="/dashboard" element={<Homepage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
