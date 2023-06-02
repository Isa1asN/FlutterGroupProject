import mongoose from "mongoose";

const TodayWordSchema = new mongoose.Schema(
    {
        word :{
            type: String,
            required: true,
            unique: true,
            min:3,
            max:50
        },
        category: {
            type: String,
            required: true,
            max : 20,
        },
        meaning :{
            type: String,
            required: true,
            max:50
        },
        example :{
            type: String,
            required: true,
        }
    },
    {timeStamps: true}
)
const TodaysWord = mongoose.model("TodaysWord", TodayWordSchema);
export default TodaysWord;