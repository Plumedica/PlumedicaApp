// utils/generateCredentials.js
import crypto from "crypto";

export function generateCredentials(fullName, email, dob, phone) {
  // Example fullName = "Kurva Ramu"
  const initials = fullName
    .split(" ")
    .map((part) => part[0]?.toUpperCase() || "")
    .join(""); // KR

  const year = dob ? dob.slice(-2) : "00"; // last 2 digits of DOB year
  const phoneSuffix = phone ? phone.slice(-2) : "00"; // last 2 digits of phone
  const userId = `PM${initials}${year}${phoneSuffix}`; // PMKR1010

  const username = email; // full email as username

  // Generate a strong random 8-char password
  const password = crypto
    .randomBytes(6)
    .toString("base64")
    .replace(/[^a-zA-Z0-9]/g, "")
    .slice(0, 8);

  return { userId, username, password };
}
