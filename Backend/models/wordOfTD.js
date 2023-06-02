import mongoose from "mongoose";

const WordSchema = new mongoose.Schema(
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
        },
        localId : {
            type : Number,
            required : true,
        },
        createdBy : String
        
    },
    {timeStamps: true}
)
const WordOfTD = mongoose.model("WordOfTD", WordSchema);
export default WordOfTD;