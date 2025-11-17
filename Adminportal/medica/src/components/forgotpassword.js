import React, { useState } from "react";
import { Container, Row, Col, Card, Form, Button } from "react-bootstrap";
import logo from "../assets/logo.png"; // Your logo path

const ForgotPassword = () => {
  const [email, setEmail] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Password reset requested for:", email);
    // Here, call your API to send password reset email
    alert(`Password reset link sent to ${email}`);
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
                style={{ width: "80px", height: "80px" }}
                className="mb-3"
              />
              <h2 className="text-#800080">MyApp</h2>
              <p className="text-muted">Forgot your password? Enter your email below.</p>
            </div>

            {/* Forgot Password Form */}
            <Form onSubmit={handleSubmit}>
              <Form.Group className="mb-3">
                <Form.Control
                  type="email"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </Form.Group>

              <Button type="submit" variant="primary" className="w-100 py-2">
                Send Reset Link
              </Button>
            </Form>

            {/* Footer */}
            <p className="text-center text-muted mt-4">
              Remember your password?{" "}
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

export default ForgotPassword;
