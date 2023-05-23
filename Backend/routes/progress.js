import express from 'express';
import { verifyUserToken } from "../middleware/auth.js";
import {setProgress, getCourseProgress} from "../controllers/progress.js"

export const courseRouter = express.Router();

// set or update the course progress for a learner
courseRouter.post('/setProgress', verifyUserToken, setProgress);

// route for getting the course proress
courseRouter.get('/course', verifyUserToken, getCourseProgress);


