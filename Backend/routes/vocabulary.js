import express from "express";
import { verifyUserToken, IsUser,IsModerator, IsNotAdmin } from "../middleware/auth.js";
import { createVocabulary, deleteVocab, editAllVocabs, editVocab, getVocabularies } from "../controllers/vocabulary.js";

export const vocabRoute = express.Router()

vocabRoute.post("/vocabulary",verifyUserToken, IsNotAdmin, createVocabulary)

vocabRoute.get("/vocabularies",verifyUserToken,IsNotAdmin, getVocabularies)

vocabRoute.put("/vocab",verifyUserToken,IsNotAdmin , editVocab);

vocabRoute.delete("/del-vocab/:localId",verifyUserToken,IsNotAdmin, deleteVocab);


vocabRoute.post("/edit-all",verifyUserToken, IsNotAdmin, editAllVocabs)