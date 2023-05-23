import mongoose from "mongoose";

const progressSchema = mongoose.Schema(
    {
        userId: {
            type: String,
            unique: true,
            required: true,
          },
          alphabet: {
            type: Number,
            required: true,
            default: 0,
          },
          sound: {
            type: Number,
            required: true,
            default: 0,
          },
          word: {
            type: Number,
            required: true,
            default: 0,
          },
          sentence: {
            type: Number,
            required: true,
            default: 0,
          },
          paragraph: {
            type: Number,
            required: true,
            default: 0,
          }
            },
    {timeStamps: true}
)
const CourseProgress = mongoose.model("CourseProgress", progressSchema);
export default CourseProgress;

