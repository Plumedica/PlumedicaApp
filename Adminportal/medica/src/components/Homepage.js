import React, { useState, useEffect } from "react";
import { Building2, Pill, Shield, Stethoscope, Briefcase } from "lucide-react";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.bundle.min.js";
import Logo from "../assets/logo.png";

// ===== Sidebar =====
const Sidebar = ({ active, setActive }) => {
  const menus = [
    { name: "Hospital", icon: <Building2 size={20} /> },
    { name: "Pharmacy", icon: <Pill size={20} /> },
    { name: "Insurances", icon: <Shield size={20} /> },
    { name: "Doctors", icon: <Stethoscope size={20} /> },
    { name: "Jobs", icon: <Briefcase size={20} /> },
  ];

  return (
    <div
      className="d-flex flex-column flex-shrink-0 p-3"
      style={{
        width: "240px",
        backgroundColor: "#b3e5fc",
        minHeight: "100vh",
      }}
    >
      <a
        href="#"
        className="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-decoration-none"
      >
        <img src={Logo} alt="logo" width="40" height="40" className="me-2" />
        <span className="fs-4 fw-bold text-success">Plumedica</span>
      </a>
      <hr />
      <ul className="nav nav-pills flex-column mb-auto">
        {menus.map((menu) => (
          <li className="nav-item" key={menu.name}>
            <button
              className={`nav-link text-start w-100 d-flex align-items-center gap-2 ${
                active === menu.name
                  ? "active text-white"
                  : "text-dark bg-transparent"
              }`}
              style={{
                backgroundColor:
                  active === menu.name ? "#a7e0c3" : "transparent",
                border: "none",
              }}
              onClick={() => setActive(menu.name)}
            >
              {menu.icon}
              {menu.name}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

// ===== Header =====
const Header = () => (
  <nav
    className="navbar navbar-expand-lg shadow-sm"
    style={{ backgroundColor: "#a7e0c3" }}
  >
    <div className="container-fluid">
      <span className="navbar-brand fw-bold text-success ms-3">Plumedica</span>
    </div>
  </nav>
);

// ===== Doctors Section =====
const DoctorsSection = () => {
  const [doctors, setDoctors] = useState([]);
  const [expanded, setExpanded] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchDoctors = async () => {
    try {
      const res = await fetch("http://localhost:3000/doctors/register");
      if (!res.ok) throw new Error("Failed to fetch doctors");
      const data = await res.json();
      setDoctors(data);
    } catch (err) {
      console.error(err);
      setError("Failed to load doctors");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDoctors();
  }, []);

  const toggleDetails = (id) => {
    setExpanded((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleAction = async (id, action) => {
    try {
      const res = await fetch(
        `http://localhost:3000/doctors/register/${id}/status`,
        {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ status: action }),
        }
      );
      if (!res.ok) throw new Error("Failed to update status");

      setDoctors((prev) =>
        prev.map((doc) =>
          doc._id === id ? { ...doc, status: action } : doc
        )
      );

      alert(`Doctor ${action} successfully!`);
    } catch (err) {
      console.error(err);
      alert("Failed to update status.");
    }
  };

  if (loading) return <p>Loading doctors...</p>;
  if (error) return <p className="text-danger">{error}</p>;
  if (!doctors.length) return <p>No doctors found.</p>;

  return (
    <div>
      <h3 className="fw-bold text-success mb-3">Doctors List</h3>
      <div className="row g-3">
        {doctors.map((doctor) => (
          <div className="col-md-4" key={doctor._id}>
            <div className="card shadow-sm border-0 h-100">
              <div className="card-body">
                <h5 className="card-title text-success">{doctor.fullName}</h5>
                <p className="card-text text-muted mb-1">
                  {doctor.specialisation}
                </p>
                <p>
                  Status: <strong>{doctor.status || "Pending"}</strong>
                </p>

                {!expanded[doctor._id] ? (
                  <button
                    className="btn btn-outline-success btn-sm"
                    onClick={() => toggleDetails(doctor._id)}
                  >
                    View More
                  </button>
                ) : (
                  <>
                    <hr />
                    <p><strong>Email:</strong> {doctor.email}</p>
                    <p><strong>Phone:</strong> {doctor.contact}</p>
                    <p><strong>Qualification:</strong> {doctor.mbbs}, {doctor.pg}</p>
                    <p><strong>Experience:</strong> {doctor.yearOfReg} years</p>

                    <div className="d-flex gap-2 mt-2">
                      <button
                        className="btn btn-success btn-sm"
                        onClick={() => handleAction(doctor._id, "Approved")}
                        disabled={doctor.status === "Approved"}
                      >
                        Accept
                      </button>
                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => handleAction(doctor._id, "Rejected")}
                        disabled={doctor.status === "Rejected"}
                      >
                        Reject
                      </button>
                      <button
                        className="btn btn-outline-secondary btn-sm ms-auto"
                        onClick={() => toggleDetails(doctor._id)}
                      >
                        Hide
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

// ===== Hospitals Section =====
const HospitalsSection = () => {
  const [hospitals, setHospitals] = useState([]);
  const [expanded, setExpanded] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchHospitals = async () => {
    try {
      const res = await fetch("http://localhost:3000/hospitals/register");
      if (!res.ok) throw new Error("Failed to fetch hospitals");
      const data = await res.json();
      setHospitals(data);
    } catch (err) {
      console.error("Error fetching hospitals:", err);
      setError("Failed to load hospitals.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHospitals();
  }, []);

  const toggleDetails = (id) => {
    setExpanded((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const handleAction = async (id, action) => {
    try {
      const res = await fetch(
        `http://localhost:3000/hospitals/register/${id}/status`,
        {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ status: action }),
        }
      );

      if (!res.ok) throw new Error("Failed to update hospital status");

      setHospitals((prev) =>
        prev.map((hos) =>
          hos._id === id ? { ...hos, status: action } : hos
        )
      );

      alert(`Hospital ${action} successfully!`);
    } catch (err) {
      console.error("Error updating hospital status:", err);
      alert("Failed to update status.");
    }
  };

  if (loading) return <p>Loading hospitals...</p>;
  if (error) return <p className="text-danger">{error}</p>;
  if (!hospitals.length) return <p>No hospitals found.</p>;

  return (
    <div>
      <h3 className="fw-bold text-success mb-3">Hospitals List</h3>
      <div className="row g-3">
        {hospitals.map((hospital) => (
          <div className="col-md-4" key={hospital._id}>
            <div className="card shadow-sm border-0 h-100">
              <div className="card-body">
                <h5 className="card-title text-success">
                  {hospital.name || "Unnamed Hospital"}
                </h5>
                <p className="card-text text-muted mb-1">
                  {hospital.specialisation || "General"}
                </p>
                <p>
                  Status: <strong>{hospital.status || "Pending"}</strong>
                </p>

                {!expanded[hospital._id] ? (
                  <button
                    className="btn btn-outline-success btn-sm"
                    onClick={() => toggleDetails(hospital._id)}
                  >
                    View More
                  </button>
                ) : (
                  <>
                    <hr />
                    <p><strong>Address:</strong> {hospital.address || "N/A"}</p>
                    <p><strong>Email:</strong> {hospital.mailId || "N/A"}</p>
                    <p><strong>Phone:</strong> {hospital.phoneNumber || "N/A"}</p>
                    <p><strong>GST ID:</strong> {hospital.gstId || "N/A"}</p>
                    <p><strong>Registration ID:</strong> {hospital.registrationId || "N/A"}</p>

                    <div className="d-flex gap-2 mt-2">
                      <button
                        className="btn btn-success btn-sm"
                        onClick={() => handleAction(hospital._id, "Approved")}
                        disabled={hospital.status === "Approved"}
                      >
                        Accept
                      </button>
                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => handleAction(hospital._id, "Rejected")}
                        disabled={hospital.status === "Rejected"}
                      >
                        Reject
                      </button>
                      <button
                        className="btn btn-outline-secondary btn-sm ms-auto"
                        onClick={() => toggleDetails(hospital._id)}
                      >
                        Hide
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

const PharmacySection = () => {
  const [pharmacies, setPharmacies] = useState([]);
  const [expanded, setExpanded] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // ✅ Fetch all pharmacies
  const fetchPharmacies = async () => {
    try {
      const res = await fetch("http://localhost:3000/pharmacies/register");
      if (!res.ok) throw new Error("Failed to fetch pharmacies");
      const data = await res.json();
      setPharmacies(data);
    } catch (err) {
      console.error("Error fetching pharmacies:", err);
      setError("Failed to load pharmacies.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPharmacies();
  }, []);

  // ✅ Toggle view more/less
  const toggleDetails = (id) => {
    setExpanded((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  // ✅ Approve / Reject Pharmacy
  const handleAction = async (id, action) => {
    try {
      const res = await fetch(
        `http://localhost:3000/pharmacies/register/${id}/status`,
        {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ status: action }),
        }
      );

      if (!res.ok) throw new Error("Failed to update pharmacy status");

      setPharmacies((prev) =>
        prev.map((pharmacy) =>
          pharmacy._id === id ? { ...pharmacy, status: action } : pharmacy
        )
      );

      alert(`Pharmacy ${action} successfully!`);
    } catch (err) {
      console.error("Error updating pharmacy status:", err);
      alert("Failed to update status.");
    }
  };

  // ✅ Render States
  if (loading) return <p>Loading pharmacies...</p>;
  if (error) return <p className="text-danger">{error}</p>;
  if (!pharmacies.length) return <p>No pharmacies found.</p>;

  // ✅ Render UI
  return (
    <div>
      <h3 className="fw-bold text-success mb-3">Pharmacies List</h3>
      <div className="row g-3">
        {pharmacies.map((pharmacy) => (
          <div className="col-md-4" key={pharmacy._id}>
            <div className="card shadow-sm border-0 h-100">
              <div className="card-body">
                <h5 className="card-title text-success">
                  {pharmacy.name || "Unnamed Pharmacy"}
                </h5>
                <p className="card-text text-muted mb-1">
                  Reg ID: {pharmacy.registrationId || "N/A"}
                </p>
                <p>
                  Status: <strong>{pharmacy.status || "Pending"}</strong>
                </p>

                {!expanded[pharmacy._id] ? (
                  <button
                    className="btn btn-outline-success btn-sm"
                    onClick={() => toggleDetails(pharmacy._id)}
                  >
                    View More
                  </button>
                ) : (
                  <>
                    <hr />
                    <p><strong>Address:</strong> {pharmacy.address || "N/A"}</p>
                    <p><strong>Email:</strong> {pharmacy.emailId || "N/A"}</p>
                    <p><strong>Phone:</strong> {pharmacy.phoneNumber || "N/A"}</p>
                    <p><strong>GST ID:</strong> {pharmacy.gstId || "N/A"}</p>

                    <div className="d-flex gap-2 mt-2">
                      <button
                        className="btn btn-success btn-sm"
                        onClick={() => handleAction(pharmacy._id, "Approved")}
                        disabled={pharmacy.status === "Approved"}
                      >
                        Accept
                      </button>
                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => handleAction(pharmacy._id, "Rejected")}
                        disabled={pharmacy.status === "Rejected"}
                      >
                        Reject
                      </button>
                      <button
                        className="btn btn-outline-secondary btn-sm ms-auto"
                        onClick={() => toggleDetails(pharmacy._id)}
                      >
                        Hide
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

// ===== Content =====
const Content = ({ active }) => {
  return (
    <div className="p-4">
      {active === "Hospital" && <HospitalsSection />}
      {active === "Pharmacy" && <PharmacySection />}
      {active === "Insurances" && (
        <h3 className="fw-bold text-success mb-3">Insurance Partners</h3>
      )}
      {active === "Doctors" && <DoctorsSection />}
    </div>
  );
};

// ===== Main Homepage =====
const Homepage = () => {
  const [active, setActive] = useState("Hospital");

  return (
    <div className="d-flex" style={{ backgroundColor: "#f8ffff" }}>
      <Sidebar active={active} setActive={setActive} />
      <div className="flex-grow-1">
        <Header />
        <main>
          <Content active={active} />
        </main>
      </div>
    </div>
  );
};

export default Homepage;
