import mongoose from "mongoose";

const VocabSchema = mongoose.Schema(
    {
        word :{
            type: String,
            required: true,
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
        description :{
            type: String,
            required: true,
            max: 100,
        },
        createdById : String,
        localId : Number
    },
    {timeStamps: true}
)
const Vocabulary = mongoose.model("Vocabulary", VocabSchema);
export default Vocabulary;
