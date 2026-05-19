const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "jimelliot.c@vit.ac.in",
    pass: "chwv klqz gjqk xeez",
  },
});

exports.sendWelcomeEmail = functions.firestore
    .document("users/{userId}")
    .onCreate(async (snap, context) => {

      const data = snap.data();

      const mailOptions = {
        from: "CHAIR Application <jimelliot.c@vit.ac.in>",
        to: data.email,
        subject: "Welcome to CHAIR Application",

        text: `
Dear ${data.name},

Welcome to the Cognitive Health Assessment Indicative Record (CHAIR) Application.

Your account has been successfully created.

Login ID: ${data.loginId}
Role: ${data.role}
Hospital: ${data.hospitalName}

Please verify your registered email address before signing in.

Regards,
CHAIR Team
VIT Chennai
`,
      };

      try {
        await transporter.sendMail(mailOptions);
        console.log("Welcome email sent");
      } catch (error) {
        console.error("Email error:", error);
      }
    });