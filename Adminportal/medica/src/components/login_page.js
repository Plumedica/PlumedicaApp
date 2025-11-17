import React, { useState } from "react";
import { Container, Row, Col, Card, Form, Button, InputGroup } from "react-bootstrap";
import logo from "../assets/logo.png"; // Your logo path
import { Eye, EyeSlash } from "react-bootstrap-icons"; // For show/hide password
import { useNavigate } from "react-router-dom"; 

const LoginPage = () => {
  const [form, setForm] = useState({ email: "", password: "" });
  const [showPassword, setShowPassword] = useState(false);
  const navigate = useNavigate();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Login form submitted:", form);
    navigate('/dashboard');
    // Add your login API call here
  };

  return (
    <Container fluid className="bg-light min-vh-100 d-flex align-items-center justify-content-center">
      <Row className="w-100">
        <Col xs={12} sm={10} md={8} lg={6} xl={5} className="mx-auto">
          <Card className="p-4 shadow-sm" style={{ maxWidth: "450px", margin: "0 auto" }}>
            {/* Logo */}
            <div className="text-center mb-4">
              <img
                src={logo}
                alt="Logo"
                style={{ width: "80px", height: "80px" }}
                className="mb-3"
              />
              <h2 className="text-primary">Plumedica</h2>
              <p className="text-muted">Login to your account</p>
            </div>

            {/* Login Form */}
            <Form onSubmit={handleSubmit}>
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
                <InputGroup>
                  <Form.Control
                    type={showPassword ? "text" : "password"}
                    placeholder="Password"
                    name="password"
                    value={form.password}
                    onChange={handleChange}
                    required
                  />
                  <Button
                    variant="outline-secondary"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? <EyeSlash /> : <Eye />}
                  </Button>
                </InputGroup>
              </Form.Group>

              <Form.Group className="mb-3 d-flex justify-content-between align-items-center">
                <Form.Check type="checkbox" label="Remember me" />
                <a href="/forgot-password" className="text-primary">
                  Forgot password?
                </a>
              </Form.Group>

              <Button type="submit" variant="primary" className="w-100 py-2">
                Login
              </Button>
            </Form>

            {/* Footer */}
            <p className="text-center text-muted mt-4">
              Don't have an account?{" "}
              <a href="/register" className="text-primary">
                Register
              </a>
            </p>
          </Card>
        </Col>
      </Row>
    </Container>
  );
};

export default LoginPage;
