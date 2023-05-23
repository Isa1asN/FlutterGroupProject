import express from "express";
import { verifyUserToken, IsNotUser } from "../middleware/auth.js";
import { createWordOfTD, getWords } from "../controllers/wordOfTD.js";

export const wordRouter = express.Router()

// create or post a new word of the day
wordRouter.post("/word", verifyUserToken, IsNotUser, createWordOfTD );

// get all the existing word of the day
wordRouter.get("/words", verifyUserToken, IsNotUser, getWords );
