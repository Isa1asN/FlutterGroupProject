import express from "express";
import {register, login, userEvent, adminEvent} from "../controllers/authController.js"
import { verifyUserToken, IsAdmin, IsUser } from "../middleware/auth.js";
import { forgotPassword, resetPassword } from '../controllers/forgotPassword.js';
import { logout, deleteAccount } from "../controllers/authController.js";


export const router = express.Router()

// Register a new User
router.post('/register', register);

// Login
router.post('/login', login);

// Forgot Password
router.post('/forgotPassword', forgotPassword);

// Reset Password
router.post('/resetPassword', resetPassword);

// Logout 
router.post('/logout', logout);

// Delete user Account
router.delete('/deleteAccount', deleteAccount);

// Auth learner only
router.get('/events', verifyUserToken, IsUser, userEvent);

// Auth Admin only
router.get('/special', verifyUserToken, IsAdmin, adminEvent);
