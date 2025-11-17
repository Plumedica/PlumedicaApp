import React, { useState } from "react";
import logo from "../assets/logo.png"; // Your logo path
import { Container, Row, Col, Card, Form, Button } from "react-bootstrap";

const RegisterPage = () => {
  const [form, setForm] = useState({
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
  });

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (form.password !== form.confirmPassword) {
      alert("Passwords do not match");
      return;
    }
    try {
      const response = await fetch("http://localhost:5000/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      if (response.ok) {
        alert("Registration successful!");
        setForm({ username: "", email: "", password: "", confirmPassword: "" });
      } else {
        alert("Registration failed");
      }
    } catch (error) {
      alert("Error connecting to server");
    }
  };

  return (
    <Container fluid className="bg-light min-vh-100 d-flex align-items-center justify-content-center">
      <Row className="w-100">
        <Col xs={12} sm={10} md={8} lg={6} xl={5} className="mx-auto">
          <Card className="p-4 shadow-sm" style={{ maxWidth: "450px", margin: "0 auto" }}>
            {/* Logo & App Name */}
            <div className="text-center mb-4">
              <img
                src={logo}
                alt="Logo"
                className="mb-3"
                style={{ width: "80px", height: "80px" }}
              />
              <h2 className="text-primary">Plumedica</h2>
              <p className="text-muted">Create your account</p>
            </div>

            {/* Registration Form */}
            <Form onSubmit={handleSubmit}>
              <Form.Group className="mb-3">
                <Form.Control
                  type="text"
                  placeholder="Username"
                  name="username"
                  value={form.username}
                  onChange={handleChange}
                  required
                />
              </Form.Group>

              <Form.Group className="mb-3">
                <Form.Control
                  type="email"
                  placeholder="Email"
                  name="email"
                  value={form.email}
                  onChange={handleChange}
                  required
                />
              </Form.Group>

              <Form.Group className="mb-3">
                <Form.Control
                  type="password"
                  placeholder="Password"
                  name="password"
                  value={form.password}
                  onChange={handleChange}
                  required
                />
              </Form.Group>

              <Form.Group className="mb-4">
                <Form.Control
                  type="password"
                  placeholder="Confirm Password"
                  name="confirmPassword"
                  value={form.confirmPassword}
                  onChange={handleChange}
                  required
                />
              </Form.Group>

              <Button variant="primary" type="submit" className="w-100 py-2">
                Register
              </Button>
            </Form>

            {/* Footer */}
            <p className="text-center text-muted mt-4">
              Already have an account?{" "}
              <a href="/" className="text-primary">
                Login
              </a>
            </p>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default RegisterPage;
