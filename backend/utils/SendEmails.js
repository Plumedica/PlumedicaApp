// utils/sendEmail.js
import nodemailer from "nodemailer";

export async function sendCredentialsEmail(to, name, { userId, username, password, sector }) {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  // ✅ Determine portal name dynamically
  let portalType = "Portal";
  if (sector?.toLowerCase() === "doctor") portalType = "Doctor Portal";
  else if (sector?.toLowerCase() === "hospital") portalType = "Hospital Portal";
  else if (sector?.toLowerCase() === "pharmacy") portalType = "Pharmacy Portal";

  const mailOptions = {
    from: `"Plumedica Support" <${process.env.EMAIL_USER}>`,
    to,
    subject: `Your Plumedica ${portalType} Login Credentials`,
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6;">
        <h3>Dear ${name},</h3>
        <p>Your <b>${sector}</b> account has been <b>approved successfully!</b></p>
        <p>Please find your login credentials below:</p>
        <ul>
          <li><b>User ID:</b> ${userId}</li>
          <li><b>Username:</b> ${username}</li>
          <li><b>Password:</b> ${password}</li>
        </ul>
        <p>Use these credentials to log in to the Plumedica <b>${portalType}</b>.</p>
        <p><i>Note:</i> Please change your password after your first login.</p>
        <hr />
        <p>Regards,<br/>Plumedica Team</p>
      </div>
    `,
  };

  await transporter.sendMail(mailOptions);
}
