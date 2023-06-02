import express from "express";
import { verifyUserToken, IsNotUser, IsModerator, IsAdmin, IsNotAdmin } from "../middleware/auth.js";
import { createWordOfTD, deleteWord, editWord, getTodaysWord, getWords, loadMyWords, setWordOfTD } from "../controllers/wordOfTD.js";

export const wordRouter = express.Router()



// get all the existing word of the day
wordRouter.get("/words", verifyUserToken, IsAdmin, getWords );

wordRouter.post("/theword",verifyUserToken,IsAdmin,setWordOfTD);

wordRouter.get("/today-word",verifyUserToken,IsNotAdmin, getTodaysWord)


// create or post a new word of the day
wordRouter.post("/word", verifyUserToken, IsModerator, createWordOfTD );

// load words shared by the moderator for himself
wordRouter.get("/mywords", verifyUserToken, IsModerator, loadMyWords );

// edit word shared by the moderator for himself
wordRouter.put("/editword", verifyUserToken, IsModerator, editWord );

// delete word shared by the moderator
wordRouter.delete("/deleteword/:localId", verifyUserToken, IsModerator, deleteWord );
