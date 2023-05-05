import mongoose from "mongoose";

const ExampleSchema = mongoose.Schema({
    sentence: {
        type: String,
        required: true
    },
    translation: {
        type: String,
        required: true
    },
    audioUrl: String
});

const VocabSchema = mongoose.Schema(
    {
        title :{
            type: String,
            required: true,
            min:3,
            max:50
        },
        description :{
            type: String,
            required: true,
        },
        category: {
            type: String,
            max: 20
        },
        createdById : String,
        examples: {
            type: [ExampleSchema],
            default:[]
        }
    },
    {timeStamps: true}
)
const Vocabulary = mongoose.model("Vocabulary", VocabSchema);
export default Vocabulary;